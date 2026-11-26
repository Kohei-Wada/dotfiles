import assert from "node:assert/strict";
import { test } from "node:test";
import { type Buffer, VimEngine } from "./engine.ts";

// "|" marks the cursor.
function parse(s: string): Buffer {
	const lines = s.split("\n");
	const line = lines.findIndex((l) => l.includes("|"));
	const col = lines[line]!.indexOf("|");
	lines[line] = lines[line]!.replace("|", "");
	return { lines, line, col };
}

function show(b: Buffer): string {
	const lines = [...b.lines];
	const l = lines[b.line]!;
	lines[b.line] = l.slice(0, b.col) + "|" + l.slice(b.col);
	return lines.join("\n");
}

function run(start: string, keys: string, mode: "normal" | "insert" = "normal") {
	const vim = new VimEngine();
	vim.mode = "normal";
	const b = parse(start);
	for (const k of keys) vim.feed(b, k);
	assert.equal(vim.mode, mode, `mode after ${keys}`);
	return show(b);
}

const cases: [string, string, string, ("normal" | "insert")?][] = [
	["|foo bar baz", "w", "foo |bar baz"],
	["|foo bar baz", "2w", "foo bar |baz"],
	["foo bar |baz", "b", "foo |bar baz"],
	["|foo bar", "e", "fo|o bar"],
	["|foo.bar", "w", "foo|.bar"],
	["|foo.bar", "W", "foo.ba|r"],
	["foo |bar baz", "dw", "foo |baz"],
	["foo |bar baz", "cw", "foo | baz", "insert"],
	["foo |bar baz", "ciw", "foo | baz", "insert"],
	["foo |bar baz", "daw", "foo |baz"],
	["foo |bar baz", "D", "foo| "],
	["foo |bar baz", "C", "foo |", "insert"],
	["a\n|b\nc", "dd", "a\n|c"],
	["a\n|b\nc", "ddp", "a\nc\n|b"],
	["a\n|b\nc", "yyP", "a\n|b\nb\nc"],
	["a\n|b\nc", "2dd", "|a"],
	["a\n|b\nc\nd", "dj", "a\n|d"],
	["|a\nb\nc", "G", "a\nb\n|c"],
	["a\nb\n|c", "gg", "|a\nb\nc"],
	["a\nb\n|c", "2G", "a\n|b\nc"],
	["|hello world", "fo", "hell|o world"],
	["|hello world", "fo;", "hello w|orld"],
	["|hello world", "to", "hel|lo world"],
	["|hello world", "dtw", "|world"],
	["hello |world", "Fe", "h|ello world"],
	["|abc", "x", "|bc"],
	["|abc", "3x", "|"],
	["|abc", "xp", "b|ac"],
	["|abc", "rz", "|zbc"],
	["|abc", "~", "A|bc"],
	["f(|a, b)", "ci(", "f(|)", "insert"],
	["f(a, |b)", "da(", "|f"],
	['say "hi |there" now', 'ci"', 'say "|" now', "insert"],
	["  |foo", "0", "|  foo"],
	["|  foo", "^", "  |foo"],
	["|foo", "$", "fo|o"],
	["|foo", "A", "foo|", "insert"],
	["  f|oo", "I", "  |foo", "insert"],
	["|a\nb", "o", "a\n|\nb", "insert"],
	["a\n|b", "O", "a\n|\nb", "insert"],
	["  |foo\nbar", "cc", "  |\nbar", "insert"],
	["|foo\nbar", "J", "foo| bar"],
	["foo |bar", "s", "foo |ar", "insert"],
	["|foo bar", "yw$p", "foo barfoo| "],
	["|foo", "d2", "|foo"],
	["|foo", "0x", "|oo"],
	["|foo bar baz", "d2w", "|baz"],
	["foo\n|\nbar", "w", "foo\n\n|bar"],
	["|foo\n\nbar", "w", "foo\n|\nbar"],
	["foo\n|bar", "b", "|foo\nbar"],
];

for (const [start, keys, expected, mode] of cases) {
	test(`${JSON.stringify(start)} ${keys}`, () => {
		assert.equal(run(start, keys, mode ?? "normal"), expected);
	});
}

test("u requests undo", () => {
	const vim = new VimEngine();
	vim.mode = "normal";
	assert.deepEqual(vim.feed(parse("|a"), "u"), { kind: "undo" });
});

test("esc from insert moves cursor left", () => {
	const vim = new VimEngine();
	const b = parse("abc|");
	vim.enterNormal(b);
	assert.equal(show(b), "ab|c");
});
