require "config.options"
require "config.builtin_plugins"
require "config.command"
require "config.autocmd"
require "config.terminal"
require "config.cmdwin"
require "config.keymaps"

-- after all the above, load plugins
require "config.lazy"
