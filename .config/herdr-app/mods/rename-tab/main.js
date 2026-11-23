// Rename the shown tab. Enter saves, Esc cancels,
// ctrl-u clears, ctrl-h deletes back. Opened from keys.json in place of the shipped prompt.
import { View, div } from "gpui-kit";
import { v_flex, h_flex, InputState, Input } from "gpui-base";
import { run, props, closeOverlay, theme, spaces } from "herdr";

export default class Rename extends View {
  init(_props, cx) {
    const space = spaces().find((s) => s.active);
    const tab = space?.tabs.find((t) => t.active);
    this.kind = "tab";
    this.target = this.kind === "space" ? space : tab;
    const text = this.target?.name ?? "";
    this.input = InputState.new({ value: text });
    if (text) this.input.set_selected_range({ start: 0, end: text.length });
    this.input.on("submit", () => this.submit());
    this.input.focus();
    cx.timer.after(600, () => this.input.focus());
    this.handle = cx.focus_handle();
  }

  close() {
    if (props()?.overlay) closeOverlay(props().overlay);
  }

  submit() {
    this.close();
    if (this.target) run(`${this.kind}.rename`, { id: this.target.id, name: this.input.value() });
  }

  key(e, cx) {
    const c = e.modifiers.control;
    if (e.key === "escape") this.close();
    else if (c && e.key === "u") this.input.set_value("");
    else if (c && e.key === "h") {
      const v = this.input.value();
      let { start, end } = this.input.selected_range();
      if (start === end) {
        if (start === 0) return cx.stop_propagation();
        start -= /[\udc00-\udfff]/.test(v[start - 1]) && start > 1 ? 2 : 1;
      }
      this.input.set_value(v.slice(0, start) + v.slice(end));
      this.input.set_selected_range({ start, end: start });
    } else return;
    cx.stop_propagation();
    cx.notify();
  }

  render() {
    const t = theme();
    return v_flex()
      .id("rename")
      .track_focus(this.handle)
      .on_key_down((e, cx) => this.key(e, cx))
      .w_full()
      .min_h(0)
      .p(18)
      .bg(t.popover)
      .text_color(t.foreground)
      .child(
        h_flex()
          .items_center()
          .child(div().flex_1().text_size(15).font_semibold().child(`Rename ${this.kind}`))
          .child(div().text_size(11).text_color(t.dim).child("Esc")),
      )
      .child(
        Input.new(this.input)
          .mt(14)
          .h(36)
          .px(10)
          .rounded(9)
          .border_1()
          .border_color(t.accent)
          .bg(t.background)
          .text_size(12.8)
          .text_color(t.foreground),
      );
  }
}
