require "config.options"
require "config.builtin_plugins"
require "config.command"
require "config.autocmd"
require "config.terminal"

-- after all the above, load plugins
require "config.lazy"
