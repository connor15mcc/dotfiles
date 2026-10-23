# dismiss default greeting
set -g fish_greeting
# enable transient prompts
set -g fish_transient_prompt 1

fish_add_path $HOME/.local/share/mise/shims
fish_add_path $HOME/.local/bin
fish_add_path $HOME/go/bin
fish_add_path $HOME/.cargo/bin

fish_vi_key_bindings
# <C-k> for accept; <C-n>, <C-p> to scroll
bind --mode insert ctrl-k accept-autosuggestion
bind --mode insert ctrl-n down-or-search
bind --mode insert ctrl-p up-or-search
# launch vim with buffer from normal mode
bind V edit_command_buffer
bind v,v edit_command_buffer
# substitute last command with `!!`
bind --mode insert !,! bang_bang

# ssh-agent (I'm sure there's a better way but)
if not pgrep ssh-agent | string collect >/dev/null
  eval (ssh-agent -c)
  set -Ux SSH_AGENT_PID $SSH_AGENT_PID
  set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
end

set -gx ZELLIJ_SOCKET_DIR $HOME/.local/state/zellij
mkdir -p $ZELLIJ_SOCKET_DIR

set -g mise_fish_mode eval_after_arrow
mise activate fish | source
atuin init fish | source
atuin pty-proxy init fish | source
zoxide init fish --cmd cd | source
