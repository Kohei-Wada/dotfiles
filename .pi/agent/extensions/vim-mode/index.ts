import { CustomEditor, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { matchesKey, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { type Buffer, VimEngine } from "./engine.ts";

const UP = "\x1b[A";
const DOWN = "\x1b[B";

// Reaches into Editor's private state; pi-tui has no public cursor setter.
interface EditorInternals {
	state: { lines: string[]; cursorLine: number; cursorCol: number };
	pushUndoSnapshot(): void;
	undo(): void;
	setCursorCol(col: number): void;
}

class VimEditor extends CustomEditor {
	private vim = new VimEngine();

	private get internals(): EditorInternals {
		return this as unknown as EditorInternals;
	}

	private snapshot(): Buffer {
		const s = this.internals.state;
		return { lines: [...s.lines], line: s.cursorLine, col: s.cursorCol };
	}

	private apply(b: Buffer, changed: boolean): void {
		const ed = this.internals;
		if (changed) {
			ed.pushUndoSnapshot();
			ed.state.lines = b.lines;
		}
		ed.state.cursorLine = b.line;
		ed.setCursorCol(b.col);
		if (changed) this.onChange?.(this.getText());
		this.tui.requestRender();
	}

	handleInput(data: string): void {
		if (matchesKey(data, "escape") || matchesKey(data, "ctrl+[")) {
			if (this.vim.mode === "insert") {
				const b = this.snapshot();
				this.vim.enterNormal(b);
				this.apply(b, false);
			} else if (this.vim.pendingKeys) {
				this.vim.reset();
				this.tui.requestRender();
			} else {
				super.handleInput("\x1b");
			}
			return;
		}

		if (this.vim.mode === "insert") {
			super.handleInput(data);
			return;
		}

		if (matchesKey(data, "ctrl+h")) data = "h";

		const printable = [...data].length === 1 && data.charCodeAt(0) >= 32;
		if (!printable) {
			this.vim.reset();
			super.handleInput(data);
			if (matchesKey(data, "enter") && this.getText() === "") this.vim.mode = "insert";
			return;
		}

		// Plain j/k go through the editor so history browsing and sticky columns keep working.
		if (!this.vim.pendingKeys && (data === "j" || data === "k")) {
			super.handleInput(data === "j" ? DOWN : UP);
			return;
		}

		const b = this.snapshot();
		const effect = this.vim.feed(b, data);
		if (effect.kind === "undo") {
			this.internals.undo();
			const after = this.snapshot();
			after.col = Math.min(after.col, Math.max(0, after.lines[after.line]!.length - 1));
			this.apply(after, false);
			return;
		}
		this.apply(b, effect.kind === "changed");
	}

	render(width: number): string[] {
		const lines = super.render(width);
		if (lines.length === 0) return lines;
		const label = this.vim.mode === "normal" ? ` NORMAL ${this.vim.pendingKeys}` : " INSERT ";
		const last = lines.length - 1;
		if (visibleWidth(lines[last]!) >= label.length) {
			lines[last] = truncateToWidth(lines[last]!, width - label.length, "") + label;
		}
		return lines;
	}
}

export default function (pi: ExtensionAPI) {
	pi.on("session_start", (_event, ctx) => {
		ctx.ui.setEditorComponent((tui, theme, kb) => new VimEditor(tui, theme, kb));
	});
}
