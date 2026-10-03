# Mute herdr sounds for remote (mosh/ssh) clients; every attached client plays its own copy.
[ -n "$SSH_CONNECTION" ] && export HERDR_DISABLE_SOUND=1
