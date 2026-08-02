hl.config {
  general = {
    gaps_in = 5,
    gaps_out = 20,

    border_size = 2,

    -- https://wiki.hypr.land/Configuring/Basics/Variables/ for info about colors
    col = {
      active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },

    -- Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false,

    -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
    allow_tearing = false,

    layout = "dwindle",
  },

  dwindle = {
    preserve_split = true, -- You probably want this
  },
}
