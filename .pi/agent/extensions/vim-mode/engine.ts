export type Mode = "normal" | "insert";

export interface Buffer {
	lines: string[];
	line: number;
	col: number;
}

export type Effect =
	| { kind: "none" }
	| { kind: "changed" }
	| { kind: "undo" }
	| { kind: "passthrough" };

interface Pos {
	line: number;
	col: number;
}

type CharClass = 0 | 1 | 2;

function charClass(ch: string | undefined, big: boolean): CharClass {
	if (ch === undefined || /\s/.test(ch)) return 0;
	if (big) return 1;
	return /\w/.test(ch) ? 1 : 2;
}

function charAt(b: Buffer, p: Pos): string | undefined {
	const l = b.lines[p.line];
	if (l === undefined) return undefined;
	return p.col < l.length ? l[p.col] : "\n";
}

function next(b: Buffer, p: Pos): Pos | null {
	const l = b.lines[p.line]!;
	if (p.col < l.length) return { line: p.line, col: p.col + 1 };
	if (p.line + 1 < b.lines.length) return { line: p.line + 1, col: 0 };
	return null;
}

function prev(b: Buffer, p: Pos): Pos | null {
	if (p.col > 0) return { line: p.line, col: p.col - 1 };
	if (p.line > 0) return { line: p.line - 1, col: b.lines[p.line - 1]!.length };
	return null;
}

function classAt(b: Buffer, p: Pos, big: boolean): CharClass {
	const ch = charAt(b, p);
	return ch === "\n" ? 0 : charClass(ch, big);
}

function isEmptyLine(b: Buffer, p: Pos): boolean {
	return b.lines[p.line]!.length === 0 && p.col === 0;
}

function wordForward(b: Buffer, p: Pos, big: boolean): Pos {
	let cur: Pos | null = p;
	const start = classAt(b, p, big);
	if (start !== 0) {
		while (cur && classAt(b, cur, big) === start && charAt(b, cur) !== "\n") cur = next(b, cur);
	}
	while (cur && classAt(b, cur, big) === 0) {
		if (isEmptyLine(b, cur) && (cur.line !== p.line)) return cur;
		const n = next(b, cur);
		if (!n) return cur;
		cur = n;
	}
	return cur ?? p;
}

function wordEnd(b: Buffer, p: Pos, big: boolean): Pos {
	let cur = next(b, p);
	while (cur && classAt(b, cur, big) === 0) cur = next(b, cur);
	if (!cur) return p;
	const cls = classAt(b, cur, big);
	for (;;) {
		const n = next(b, cur);
		if (!n || classAt(b, n, big) !== cls || charAt(b, n) === "\n") return cur;
		cur = n;
	}
}

function wordBackward(b: Buffer, p: Pos, big: boolean): Pos {
	let cur = prev(b, p);
	while (cur && classAt(b, cur, big) === 0) {
		if (isEmptyLine(b, cur)) return cur;
		cur = prev(b, cur);
	}
	if (!cur) return { line: 0, col: 0 };
	const cls = classAt(b, cur, big);
	for (;;) {
		const pr = prev(b, cur);
		if (!pr || classAt(b, pr, big) !== cls || charAt(b, pr) === "\n") return cur;
		cur = pr;
	}
}

function firstNonBlank(line: string): number {
	const m = /\S/.exec(line);
	return m ? m.index : 0;
}

interface Range {
	start: Pos;
	end: Pos; // exclusive
	linewise: boolean;
}

function cmp(a: Pos, b: Pos): number {
	return a.line - b.line || a.col - b.col;
}

function ordered(a: Pos, b: Pos): [Pos, Pos] {
	return cmp(a, b) <= 0 ? [a, b] : [b, a];
}

function textIn(b: Buffer, r: Range): string {
	if (r.linewise) return b.lines.slice(r.start.line, r.end.line + 1).join("\n") + "\n";
	const out: string[] = [];
	for (let i = r.start.line; i <= r.end.line; i++) {
		const l = b.lines[i]!;
		const s = i === r.start.line ? r.start.col : 0;
		const e = i === r.end.line ? r.end.col : l.length;
		out.push(l.slice(s, e));
	}
	return out.join("\n");
}

function deleteRange(b: Buffer, r: Range): void {
	if (r.linewise) {
		b.lines.splice(r.start.line, r.end.line - r.start.line + 1);
		if (b.lines.length === 0) b.lines.push("");
		b.line = Math.min(r.start.line, b.lines.length - 1);
		b.col = firstNonBlank(b.lines[b.line]!);
		return;
	}
	const head = b.lines[r.start.line]!.slice(0, r.start.col);
	const tail = b.lines[r.end.line]!.slice(r.end.col);
	b.lines.splice(r.start.line, r.end.line - r.start.line + 1, head + tail);
	b.line = r.start.line;
	b.col = r.start.col;
}

function insertText(b: Buffer, text: string): void {
	const l = b.lines[b.line]!;
	const parts = (l.slice(0, b.col) + text + l.slice(b.col)).split("\n");
	const lastLen = text.split("\n").at(-1)!.length;
	b.lines.splice(b.line, 1, ...parts);
	b.line += parts.length - 1;
	b.col = (parts.length === 1 ? b.col : 0) + lastLen;
}

const PENDING_CHAR = new Set(["f", "F", "t", "T", "r"]);
const OPERATORS = new Set(["d", "c", "y"]);

export class VimEngine {
	mode: Mode = "normal";
	private pending = "";
	private register = "";
	private registerLinewise = false;
	private lastFind: { cmd: string; ch: string } | null = null;

	get pendingKeys(): string {
		return this.pending;
	}

	enterNormal(b: Buffer): void {
		this.mode = "normal";
		this.pending = "";
		if (b.col > 0) b.col--;
		this.clamp(b);
	}

	reset(): void {
		this.pending = "";
	}

	private clamp(b: Buffer): void {
		b.line = Math.max(0, Math.min(b.line, b.lines.length - 1));
		const len = b.lines[b.line]!.length;
		const max = this.mode === "normal" ? Math.max(0, len - 1) : len;
		b.col = Math.max(0, Math.min(b.col, max));
	}

	/** Feed one printable key in normal mode. */
	feed(b: Buffer, key: string): Effect {
		this.pending += key;
		const res = this.run(b, this.pending);
		if (res !== "incomplete") {
			this.pending = "";
			if (this.mode === "normal") this.clamp(b);
			return res;
		}
		return { kind: "none" };
	}

	private find(b: Buffer, cmd: string, ch: string, count: number): Pos | null {
		const l = b.lines[b.line]!;
		let col = b.col;
		for (let i = 0; i < count; i++) {
			let idx: number;
			if (cmd === "f" || cmd === "t") {
				const from = cmd === "t" && i === 0 ? col + 2 : col + 1;
				idx = l.indexOf(ch, cmd === "t" && i > 0 ? col + 2 : from);
				if (idx < 0) return null;
				col = cmd === "t" ? idx - 1 : idx;
			} else {
				const from = cmd === "T" && i === 0 ? col - 2 : col - 1;
				idx = from < 0 ? -1 : l.lastIndexOf(ch, cmd === "T" && i > 0 ? col - 2 : from);
				if (idx < 0) return null;
				col = cmd === "T" ? idx + 1 : idx;
			}
		}
		return { line: b.line, col };
	}

	/** Resolve a motion. Returns target, whether inclusive, and whether linewise. */
	private motion(
		b: Buffer,
		m: string,
		count: number,
		forOperator: boolean,
	): { pos: Pos; inclusive: boolean; linewise: boolean } | "incomplete" | null {
		const p = { line: b.line, col: b.col };
		const repeat = (fn: (q: Pos) => Pos): Pos => {
			let q = p;
			for (let i = 0; i < count; i++) q = fn(q);
			return q;
		};
		switch (m) {
			case "h":
				return { pos: { line: p.line, col: Math.max(0, p.col - count) }, inclusive: false, linewise: false };
			case "l": {
				const len = b.lines[p.line]!.length;
				return { pos: { line: p.line, col: Math.min(len, p.col + count) }, inclusive: false, linewise: false };
			}
			case "j":
				if (p.line + count >= b.lines.length && !forOperator) return null;
				return { pos: { line: Math.min(b.lines.length - 1, p.line + count), col: p.col }, inclusive: false, linewise: true };
			case "k":
				if (p.line - count < 0 && !forOperator) return null;
				return { pos: { line: Math.max(0, p.line - count), col: p.col }, inclusive: false, linewise: true };
			case "0":
				return { pos: { line: p.line, col: 0 }, inclusive: false, linewise: false };
			case "^":
				return { pos: { line: p.line, col: firstNonBlank(b.lines[p.line]!) }, inclusive: false, linewise: false };
			case "$": {
				const line = Math.min(b.lines.length - 1, p.line + count - 1);
				return { pos: { line, col: Math.max(0, b.lines[line]!.length - 1) }, inclusive: true, linewise: false };
			}
			case "w":
			case "W": {
				const big = m === "W";
				let q = repeat((x) => wordForward(b, x, big));
				// cw/dw never cross onto the next line's start
				if (forOperator && q.line > p.line) {
					const len = b.lines[p.line]!.length;
					q = count === 1 ? { line: p.line, col: len } : q;
				}
				return { pos: q, inclusive: false, linewise: false };
			}
			case "e":
			case "E":
				return { pos: repeat((x) => wordEnd(b, x, m === "E")), inclusive: true, linewise: false };
			case "b":
			case "B":
				return { pos: repeat((x) => wordBackward(b, x, m === "B")), inclusive: false, linewise: false };
			case "G": {
				const line = this.explicitCount ? Math.min(b.lines.length, count) - 1 : b.lines.length - 1;
				return { pos: { line, col: firstNonBlank(b.lines[line]!) }, inclusive: false, linewise: true };
			}
			case "g":
				return "incomplete";
			case "gg": {
				const line = this.explicitCount ? Math.min(b.lines.length, count) - 1 : 0;
				return { pos: { line, col: firstNonBlank(b.lines[line]!) }, inclusive: false, linewise: true };
			}
			case ";":
			case ",": {
				if (!this.lastFind) return null;
				let cmd = this.lastFind.cmd;
				if (m === ",") cmd = { f: "F", F: "f", t: "T", T: "t" }[cmd]!;
				const pos = this.find(b, cmd, this.lastFind.ch, count);
				return pos ? { pos, inclusive: cmd === "f" || cmd === "t", linewise: false } : null;
			}
		}
		if (PENDING_CHAR.has(m[0]!) && m[0] !== "r") {
			if (m.length < 2) return "incomplete";
			const cmd = m[0]!;
			const ch = m.slice(1);
			this.lastFind = { cmd, ch };
			const pos = this.find(b, cmd, ch, count);
			return pos ? { pos, inclusive: cmd === "f" || cmd === "t", linewise: false } : null;
		}
		return null;
	}

	private textObject(b: Buffer, obj: string): Range | null {
		const l = b.lines[b.line]!;
		if (l.length === 0) return null;
		const around = obj[0] === "a";
		const kind = obj[1];
		if (kind === "w" || kind === "W") {
			const big = kind === "W";
			const cls = charClass(l[b.col], big);
			let s = b.col;
			let e = b.col;
			while (s > 0 && charClass(l[s - 1], big) === cls) s--;
			while (e < l.length && charClass(l[e], big) === cls) e++;
			if (around) {
				if (cls !== 0 && e < l.length && charClass(l[e], big) === 0) {
					while (e < l.length && charClass(l[e], big) === 0) e++;
				} else {
					while (s > 0 && charClass(l[s - 1], big) === 0) s--;
				}
			}
			return { start: { line: b.line, col: s }, end: { line: b.line, col: e }, linewise: false };
		}
		const pairs: Record<string, [string, string]> = {
			"(": ["(", ")"], ")": ["(", ")"], b: ["(", ")"],
			"[": ["[", "]"], "]": ["[", "]"],
			"{": ["{", "}"], "}": ["{", "}"], B: ["{", "}"],
			"<": ["<", ">"], ">": ["<", ">"],
		};
		if (kind === '"' || kind === "'" || kind === "`") {
			const before = l.lastIndexOf(kind, l[b.col] === kind ? b.col - 1 : b.col);
			let s: number;
			let e: number;
			if (l[b.col] === kind && before < 0) {
				s = b.col;
				e = l.indexOf(kind, b.col + 1);
			} else {
				s = before;
				e = l.indexOf(kind, Math.max(b.col, s + 1));
			}
			if (s < 0 || e < 0) return null;
			return around
				? { start: { line: b.line, col: s }, end: { line: b.line, col: e + 1 }, linewise: false }
				: { start: { line: b.line, col: s + 1 }, end: { line: b.line, col: e }, linewise: false };
		}
		const pair = kind ? pairs[kind] : undefined;
		if (!pair) return null;
		const [open, close] = pair;
		const text = b.lines.join("\n");
		let offset = 0;
		for (let i = 0; i < b.line; i++) offset += b.lines[i]!.length + 1;
		offset += b.col;
		let depth = 0;
		let s = -1;
		for (let i = offset; i >= 0; i--) {
			const ch = text[i];
			if (ch === close && i !== offset) depth++;
			else if (ch === open) {
				if (depth === 0) {
					s = i;
					break;
				}
				depth--;
			}
		}
		if (s < 0) return null;
		depth = 0;
		let e = -1;
		for (let i = s + 1; i < text.length; i++) {
			const ch = text[i];
			if (ch === open) depth++;
			else if (ch === close) {
				if (depth === 0) {
					e = i;
					break;
				}
				depth--;
			}
		}
		if (e < 0) return null;
		const toPos = (off: number): Pos => {
			let line = 0;
			while (off > b.lines[line]!.length) {
				off -= b.lines[line]!.length + 1;
				line++;
			}
			return { line, col: off };
		};
		return around
			? { start: toPos(s), end: toPos(e + 1), linewise: false }
			: { start: toPos(s + 1), end: toPos(e), linewise: false };
	}

	private explicitCount = false;

	private run(b: Buffer, keys: string): Effect | "incomplete" {
		const m = /^(\d*)([\s\S]*)$/.exec(keys)!;
		let countStr = m[1]!;
		let rest = m[2]!;
		if (countStr === "0") {
			countStr = "";
			rest = "0";
		}
		if (rest === "") return "incomplete";
		this.explicitCount = countStr !== "";
		const count = countStr ? Number.parseInt(countStr, 10) : 1;
		const cmd = rest[0]!;
		const changed: Effect = { kind: "changed" };
		const none: Effect = { kind: "none" };

		if (OPERATORS.has(cmd)) {
			let mrest = rest.slice(1);
			const m2 = /^(\d*)([\s\S]*)$/.exec(mrest)!;
			let count2 = 1;
			if (m2[1] && m2[1] !== "0") {
				count2 = Number.parseInt(m2[1], 10);
				mrest = m2[2]!;
				this.explicitCount = true;
			}
			if (mrest === "") return "incomplete";
			const total = count * count2;
			let range: Range | null = null;
			if (mrest === cmd) {
				const end = Math.min(b.lines.length - 1, b.line + total - 1);
				range = { start: { line: b.line, col: 0 }, end: { line: end, col: 0 }, linewise: true };
			} else if (mrest[0] === "i" || mrest[0] === "a") {
				if (mrest.length < 2) return "incomplete";
				range = this.textObject(b, mrest);
			} else {
				let motionKey = mrest;
				// cw behaves like ce when on a word
				if (cmd === "c" && (mrest === "w" || mrest === "W") && classAt(b, b, mrest === "W") !== 0) {
					motionKey = mrest === "w" ? "e" : "E";
				}
				const mv = this.motion(b, motionKey, total, true);
				if (mv === "incomplete") return "incomplete";
				if (!mv) return none;
				const cur = { line: b.line, col: b.col };
				if (mv.linewise) {
					const [s, e] = ordered(cur, mv.pos);
					range = { start: { line: s.line, col: 0 }, end: { line: e.line, col: 0 }, linewise: true };
				} else {
					let [s, e] = ordered(cur, mv.pos);
					if (mv.inclusive) e = { line: e.line, col: Math.min(b.lines[e.line]!.length, e.col + 1) };
					range = { start: s, end: e, linewise: false };
				}
			}
			if (!range) return none;
			this.register = textIn(b, range);
			this.registerLinewise = range.linewise;
			if (cmd === "y") {
				const target = range.linewise ? { line: range.start.line, col: b.col } : range.start;
				b.line = target.line;
				b.col = target.col;
				return none;
			}
			if (cmd === "c" && range.linewise) {
				const indent = /^\s*/.exec(b.lines[range.start.line]!)![0];
				b.lines.splice(range.start.line, range.end.line - range.start.line + 1, indent);
				b.line = range.start.line;
				b.col = indent.length;
			} else {
				deleteRange(b, range);
			}
			if (cmd === "c") this.mode = "insert";
			return changed;
		}

		switch (cmd) {
			case "i":
				this.mode = "insert";
				return none;
			case "a":
				this.mode = "insert";
				b.col = Math.min(b.lines[b.line]!.length, b.col + 1);
				return none;
			case "I":
				this.mode = "insert";
				b.col = firstNonBlank(b.lines[b.line]!);
				return none;
			case "A":
				this.mode = "insert";
				b.col = b.lines[b.line]!.length;
				return none;
			case "o":
			case "O": {
				const at = cmd === "o" ? b.line + 1 : b.line;
				b.lines.splice(at, 0, "");
				b.line = at;
				b.col = 0;
				this.mode = "insert";
				return changed;
			}
			case "x":
			case "X": {
				const l = b.lines[b.line]!;
				if (l.length === 0) return none;
				const s = cmd === "x" ? b.col : Math.max(0, b.col - count);
				const e = cmd === "x" ? Math.min(l.length, b.col + count) : b.col;
				if (s === e) return none;
				this.register = l.slice(s, e);
				this.registerLinewise = false;
				b.lines[b.line] = l.slice(0, s) + l.slice(e);
				b.col = s;
				return changed;
			}
			case "s":
				return this.run(b, `${count}cl`);
			case "S":
				return this.run(b, `${count}cc`);
			case "D":
				return this.run(b, `d${count}$`);
			case "C":
				return this.run(b, `c${count}$`);
			case "Y":
				return this.run(b, `${count}yy`);
			case "r": {
				if (rest.length < 2) return "incomplete";
				const ch = rest.slice(1);
				const l = b.lines[b.line]!;
				if (b.col + count > l.length) return none;
				b.lines[b.line] = l.slice(0, b.col) + ch.repeat(count) + l.slice(b.col + count);
				b.col += count - 1;
				return changed;
			}
			case "~": {
				const l = b.lines[b.line]!;
				if (l.length === 0) return none;
				const e = Math.min(l.length, b.col + count);
				const flipped = [...l.slice(b.col, e)]
					.map((c) => (c === c.toUpperCase() ? c.toLowerCase() : c.toUpperCase()))
					.join("");
				b.lines[b.line] = l.slice(0, b.col) + flipped + l.slice(e);
				b.col = Math.min(e, l.length - 1);
				return changed;
			}
			case "J": {
				const n = Math.max(1, count - 1);
				let changedAny = false;
				for (let i = 0; i < n && b.line + 1 < b.lines.length; i++) {
					const left = b.lines[b.line]!.replace(/\s+$/, "");
					const right = b.lines[b.line + 1]!.replace(/^\s+/, "");
					const sep = left.length && right.length && !right.startsWith(")") ? " " : "";
					b.lines.splice(b.line, 2, left + sep + right);
					b.col = left.length;
					changedAny = true;
				}
				return changedAny ? changed : none;
			}
			case "p":
			case "P": {
				if (!this.register) return none;
				const text = this.register.repeat(count);
				if (this.registerLinewise) {
					const newLines = text.slice(0, -1).split("\n");
					const at = cmd === "p" ? b.line + 1 : b.line;
					b.lines.splice(at, 0, ...newLines);
					b.line = at;
					b.col = firstNonBlank(b.lines[at]!);
				} else {
					if (cmd === "p" && b.lines[b.line]!.length > 0) b.col++;
					insertText(b, text);
					b.col = Math.max(0, b.col - 1);
				}
				return changed;
			}
			case "u":
				return { kind: "undo" };
		}

		const mv = this.motion(b, rest, count, false);
		if (mv === "incomplete") return "incomplete";
		if (!mv) return none;
		b.line = mv.pos.line;
		b.col = mv.pos.col;
		return none;
	}
}
