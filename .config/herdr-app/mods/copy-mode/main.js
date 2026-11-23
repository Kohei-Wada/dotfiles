// Vim-style copy mode for the focused terminal: the selection is the cursor.
// h j k l, w b e, 0 ^ $, gg G, ctrl-u ctrl-d, counts; v / V to select, y to copy, Esc or q to leave.

import { View, div } from "gpui-kit";
import { focused, panes, terminals, run, hc, theme, props, closeOverlay } from "herdr";

const wide = (c) => /[ᄀ-ᅟ⺀-꓏가-힣豈-﫿︰-﹏＀-｠￠-￦]|[\ud800-\udbff]/.test(c);
const cls = (c) => (c === undefined || /\s/.test(c) ? 0 : /[\p{L}\p{N}_]/u.test(c) ? 1 : 2);

// A line as cells: cells[i] = char starting at column i (wide chars leave a null after them).
function toCells(line) {
  const cells = [];
  for (const c of line ?? "") {
    cells.push(c);
    if (wide(c)) cells.push(null);
  }
  return cells;
}

export default class CopyMode extends View {
  init(_props, cx) {
    const f = focused();
    this.term = f?.terminal ?? panes().find((p) => p.pane === f?.pane)?.terminal ?? null;
    this.pane = f?.pane ?? null;
    this.visual = null;
    this.count = "";
    this.pending = "";
    this.queue = Promise.resolve();
    this.lines = null;
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(100, () => this.handle.focus());
    if (!this.term) return this.quit();
    this.do(cx, async (cx) => {
      await this.apply(cx, "terminal.select", { at: "cursor" });
      if (!this.sel()) this.quit();
    });
    cx.spawn(async () => {
      try {
        const r = await hc(["read", this.term, "--json", "--lines", "100000"]);
        if (r.code === 0) this.lines = JSON.parse(r.stdout).text.split("\n");
      } catch {}
    });
  }

  sel() {
    return terminals().find((t) => t.address === this.term)?.selection ?? null;
  }

  // Commands land on the next frame; wait until the selection reflects them.
  async apply(cx, cmd, args) {
    const before = JSON.stringify(this.sel());
    try {
      await run(cmd, { terminal: this.term, ...args });
    } catch {
      return false;
    }
    for (let i = 0; i < 12; i++) {
      if (JSON.stringify(this.sel()) !== before) return true;
      await cx.sleep(16);
    }
    return false;
  }

  // Keys run one after another, each waiting for the selection the previous one made.
  do(cx, fn) {
    const prev = this.queue;
    this.queue = new Promise((done) =>
      cx.spawn(async (cx) => {
        await prev;
        try {
          await fn(cx);
        } catch {}
        done();
      }),
    );
  }

  // Row in the terminal -> text line from hc read, aligned on the last row.
  lineAt(row) {
    if (!this.lines) return null;
    const total = panes().find((p) => p.terminal === this.term)?.scroll?.total ?? terminals().find((t) => t.address === this.term)?.rows;
    if (!total) return null;
    return this.lines[this.lines.length - total + row];
  }

  // Next/previous word position from {row, col}, vim-style; null when the text is unknown.
  wordMove(pos, kind) {
    let { row, col } = pos;
    let cells = toCells(this.lineAt(row));
    if (this.lineAt(row) == null) return null;
    const at = () => cls(cells[col]);
    const fwd = () => {
      if (col + 1 < cells.length) {
        col++;
        while (cells[col] === null && col + 1 < cells.length) col++;
        return true;
      }
      const next = this.lineAt(row + 1);
      if (next == null) return false;
      row++;
      cells = toCells(next);
      col = 0;
      return "nl";
    };
    const back = () => {
      if (col > 0) {
        col--;
        while (cells[col] === null && col > 0) col--;
        return true;
      }
      if (row === 0 || this.lineAt(row - 1) == null) return false;
      row--;
      cells = toCells(this.lineAt(row));
      col = Math.max(0, cells.length - 1);
      return "nl";
    };
    if (kind === "w") {
      const start = at();
      let moved;
      while ((moved = fwd()) === true && start !== 0 && at() === start);
      while (moved && at() === 0 && (moved = fwd()));
    } else if (kind === "e") {
      let moved = fwd();
      while (moved && at() === 0 && (moved = fwd()));
      const c = at();
      while (cls(cells[col + 1]) === c && c !== 0 && fwd() === true);
    } else if (kind === "b") {
      let moved = back();
      while (moved && at() === 0 && (moved = back()));
      const c = at();
      while (col > 0 && cls(cells[col - 1]) === c && c !== 0 && back() === true);
    }
    return { row, col };
  }

  // Move the selection's end to pos with relative steps (visual) or by reselecting (normal).
  async goTo(cx, pos) {
    const s = this.sel();
    if (!s || !pos) return;
    if (!this.visual) return this.apply(cx, "terminal.select", { at: pos });
    let { row, col } = s.end;
    for (; row < pos.row; row++) await this.apply(cx, "terminal.adjust_selection", { direction: "down" });
    for (; row > pos.row; row--) await this.apply(cx, "terminal.adjust_selection", { direction: "up" });
    col = this.sel()?.end.col ?? col;
    for (; col < pos.col; col++) await this.apply(cx, "terminal.adjust_selection", { direction: "right" });
    for (; col > pos.col; col--) await this.apply(cx, "terminal.adjust_selection", { direction: "left" });
  }

  async step(cx, direction, n) {
    for (let i = 0; i < n; i++) if (!(await this.apply(cx, "terminal.adjust_selection", { direction }))) break;
    if (!this.visual) {
      const e = this.sel()?.end;
      if (e) await this.apply(cx, "terminal.select", { at: e });
    }
  }

  quit(keep) {
    if (this.closed) return;
    this.closed = true;
    if (!keep && this.term) run("terminal.clear_selection", { terminal: this.term });
    if (props()?.overlay) closeOverlay(props().overlay);
  }

  async close() {
    if (!this.closed && this.term) await run("terminal.clear_selection", { terminal: this.term });
  }

  key(e, cx) {
    const k = e.keystroke;
    const ch = e.key_char;
    if (k === "escape" || (k === "q" && !this.pending)) return this.quit();
    if (k === "ctrl-c" || k === "ctrl-[") return this.quit();
    if (ch && /[0-9]/.test(ch) && (this.count || ch !== "0")) {
      this.count += ch;
      return;
    }
    const n = Math.max(1, parseInt(this.count || "1", 10));
    this.count = "";
    if (this.pending === "g") {
      this.pending = "";
      if (ch === "g") this.do(cx, (cx) => this.step(cx, "home", 1));
      return;
    }
    const dir = { h: "left", j: "down", k: "up", l: "right" }[ch];
    if (dir && !e.modifiers.control) return this.do(cx, (cx) => this.step(cx, dir, n));
    if (k === "left" || k === "right" || k === "up" || k === "down") return this.do(cx, (cx) => this.step(cx, k, n));
    if (k === "ctrl-u" || k === "ctrl-b" || k === "pageup") return this.do(cx, (cx) => this.step(cx, "page_up", n));
    if (k === "ctrl-d" || k === "ctrl-f" || k === "pagedown") return this.do(cx, (cx) => this.step(cx, "page_down", n));
    switch (ch) {
      case "0":
        return this.do(cx, (cx) => this.step(cx, "line_start", 1));
      case "$":
        return this.do(cx, (cx) => this.step(cx, "line_end", 1));
      case "^":
        return this.do(cx, async (cx) => {
          const e = this.sel()?.end;
          const cells = toCells(e && this.lineAt(e.row));
          const col = cells.findIndex((c) => c && cls(c) !== 0);
          if (e) await this.goTo(cx, { row: e.row, col: Math.max(0, col) });
        });
      case "G":
        return this.do(cx, (cx) => this.step(cx, "end", 1));
      case "g":
        this.pending = "g";
        return;
      case "w":
      case "b":
      case "e":
        return this.do(cx, async (cx) => {
          let pos = this.sel()?.end;
          for (let i = 0; i < n && pos; i++) pos = this.wordMove(pos, ch) ?? pos;
          await this.goTo(cx, pos);
        });
      case "v":
      case "V":
      {
        const was = this.visual;
        this.visual = was === ch ? null : ch;
        return this.do(cx, async (cx) => {
          const s = this.sel();
          if (!s) return;
          if (!this.visual) return this.apply(cx, "terminal.select", { at: s.end });
          const anchor = was ? s.start : s.end;
          await this.apply(cx, "terminal.select", { at: anchor, mode: ch === "V" ? "line" : "cell" });
          if (was) await this.goTo(cx, s.end);
        });
      }
      case "y":
        return this.do(cx, async () => {
          if (!this.visual) return;
          await run("terminal.copy");
          this.quit();
        });
    }
  }

  render(cx) {
    const t = theme();
    const label = this.visual === "V" ? "-- VISUAL LINE --" : this.visual ? "-- VISUAL --" : "-- COPY --";
    return div()
      .id("copy-mode")
      .track_focus(this.handle)
      .size_full()
      .flex()
      .items_center()
      .justify_center()
      .bg(t.popover)
      .text_size(12)
      .font_semibold()
      .text_color(this.visual ? t.accent : t.foreground)
      .on_key_down((e, cx) => {
        this.key(e, cx);
        cx.stop_propagation();
        cx.notify();
      })
      .child(this.count ? `${label}  ${this.count}` : label);
  }
}
