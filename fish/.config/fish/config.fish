source /usr/share/cachyos-fish-config/cachyos-config.fish
source ~/.config/fish/env.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

set -gx EDITOR nvim

function lf
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
		builtin cd -- "$cwd"
	end
	command rm -f -- "$tmp"
end

function lg
  command lazygit
end

# opencode
fish_add_path /home/cedric/.opencode/bin
