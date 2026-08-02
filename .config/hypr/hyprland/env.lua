hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

local runtimeDir = os.getenv("XDG_RUNTIME_DIR")
if runtimeDir then
    hl.env("SSH_AUTH_SOCK", runtimeDir .. "/ssh-agent.socket")
end

hl.env("XMODIFIERS", "@im=fcitx")
hl.env("INPUT_METHOD", "fcitx")
