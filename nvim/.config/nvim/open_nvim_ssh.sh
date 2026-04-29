#!/bin/bash

# ╔══════════════════════════════════════════════════════════╗
# ║              nvim-ssh — SSH host launcher                ║
# ║  Opens SSH connections with a fuzzy picker for known     ║
# ║  hosts from ~/.ssh/known_hosts.                         ║
# ╚══════════════════════════════════════════════════════════╝

# ─── Configuration ────────────────────────────────────────
DEFAULT_PORT=22
KNOWN_HOSTS_FILE="${HOME}/.ssh/known_hosts"

# ─── Colour palette for fzf ───────────────────────────────
FZF_COLORS="
  --color=bg+:#1e1e2e,bg:#11111b,spinner:#f5c2e7,hl:#cba6f7
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5c2e7
  --color=marker:#f5c2e7,fg+:#cdd6f4,prompt:#cba6f7,hl+:#cba6f7
"

# ─── Helpers ──────────────────────────────────────────────
die() { echo "✗ $*" >&2; exit 1; }

require() {
  for cmd in "$@"; do
    command -v "$cmd" &>/dev/null || die "'$cmd' is not installed or not in PATH."
  done
}

# ─── Build the host list ────────────────────────────────
build_host_list() {
  if [ ! -f "$KNOWN_HOSTS_FILE" ]; then
    echo "No known_hosts file found at $KNOWN_HOSTS_FILE"
    return 1
  fi

  # Extract hosts (first field only) and create tab-separated list with labels
  grep -oE '^[^\s]+' "$KNOWN_HOSTS_FILE" | sort -u | while read -r host; do
    printf '%s\t%s\n' "$host" "$host"
  done
}

# ─── Pick host with fzf ─────────────────────────────────
pick_host() {
  local selection
  selection=$(
    build_host_list \
    | fzf \
        --with-nth=1 \
        --delimiter=$'\t' \
        --prompt="  ssh » " \
        --pointer="▶" \
        --marker="●" \
        --height=60% \
        --layout=reverse \
        --border=rounded \
        --border-label=" 󰒋 SSH Hosts " \
        --border-label-pos=3 \
        --info=inline \
        --header="  ctrl-c / esc to abort" \
        --preview='
            host=$(echo {} | cut -f 2)
            echo "🌐 Host: $host"
            echo "🔑 Port: '$DEFAULT_PORT'"
            echo ""
            echo "📝 SSH Command:"
            echo "  ssh $host -p '$DEFAULT_PORT'"
        ' \
        --preview-window=right:50%:wrap \
        $FZF_COLORS
  ) || return 1

  # Return the host (second field)
  awk -F'$'\t'' '{print $2}' <<< "$selection"
}

# ─── Main ─────────────────────────────────────────────────
main() {
  require fzf

  local selected_host
  selected_host=$(pick_host)
  echo "$selected_host\n"
  
  if [ $? -ne 0 ]; then
    read -p "Enter hostname manually: " selected_host
  fi

  read -p "Enter username (leave empty for none): " username

  # Construct the nvim command
  if [ -z "$username" ]; then
    nvim "oil-ssh://$selected_host:$DEFAULT_PORT/"
  else
    nvim "oil-ssh://$username@$selected_host:$DEFAULT_PORT/"
  fi
}

main "$@"
