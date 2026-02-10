# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

function lf() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
# Set terminal colorscheme to wallpapers
wal -nq -i "$(grep "Image=" ~/.config/plasma-org.kde.plasma.desktop-appletsrc | head -n 1 | awk -F= '{print $2}')"

# Exports
export EDITOR=nvim
export PATH="$PATH:$HOME/.local/share/coursier/bin"

# Aliasses
alias lg="lazygit"
alias vim="nvim"

[ -f "/home/cedric/.ghcup/env" ] && . "/home/cedric/.ghcup/env" # ghcup-env