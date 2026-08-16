#!/bin/bash
# ╔══════════════════════════════════════════════════════════╗
# ║              repo-launch — tmux session launcher         ║
# ║  Opens repos from ~/Repositories with a fuzzy picker.   ║
# ║  Configured "flat" parent dirs are transparently        ║
# ║  expanded so only their children are selectable.        ║
# ╚══════════════════════════════════════════════════════════╝

# ─── Configuration ────────────────────────────────────────
REPO_ROOT="${REPO_ROOT:-$HOME/Repositories}"
DOCUMENTS_ROOT="${DOCUMENTS_ROOT:-$HOME/Documents}"

# Directories inside REPO_ROOT whose *children* should be
# listed directly (the parent itself won't be selectable).
# Edit this array to add more "flat" parents.
FLAT_PARENTS=(
  "VUB"
  "Castars"
  "ObsidianVaults"
  # "forks"   ← uncomment / add more as needed
)

# ─── Colour palette for fzf (Gruvbox) ────────────────────
FZF_COLORS="
  --color=bg+:#3c3836,bg:#282828,spinner:#d79921,hl:#b16286
  --color=fg:#ebdbb2,header:#cc241d,info:#458588,pointer:#d79921
  --color=marker:#d79921,fg+:#ebdbb2,prompt:#458588,hl+:#b16286
"

# ─── Helpers ──────────────────────────────────────────────
die() { echo "✗ $*" >&2; exit 1; }

require() {
  for cmd in "$@"; do
    command -v "$cmd" &>/dev/null || die "'$cmd' is not installed or not in PATH."
  done
}

is_flat_parent() {
  local dir="$1"
  local base
  base=$(basename "$dir")
  for p in "${FLAT_PARENTS[@]}"; do
    [[ "$base" == "$p" ]] && return 0
  done
  return 1
}

# ─── Build the candidate list ─────────────────────────────
build_candidates() {
  local -a candidates=()
  local -a search_roots=("$REPO_ROOT")

  # Add Documents root only if it differs from REPO_ROOT
  if [[ "$DOCUMENTS_ROOT" != "$REPO_ROOT" ]]; then
    search_roots+=("$DOCUMENTS_ROOT")
  fi

  for root in "${search_roots[@]}"; do
    for entry in "$root"/*/; do
      [[ -d "$entry" ]] || continue
      if is_flat_parent "$entry"; then
        for child in "$entry"*/; do
          [[ -d "$child" ]] && candidates+=("$child")
        done
      else
        candidates+=("$entry")
      fi
    done
  done

  for c in "${candidates[@]}"; do
    local label
    if [[ "$c" == "$DOCUMENTS_ROOT/"* ]]; then
      label="Documents/${c#"$DOCUMENTS_ROOT/"}"
    else
      label="${c#"$REPO_ROOT"/}"
    fi
    label="${label%/}"
    printf '%s\t%s\n' "$label" "$c"
  done
}

# ─── Pick with fzf ────────────────────────────────────────
pick_repo() {
  local selection
  selection=$(
    build_candidates \
    | fzf \
        --with-nth=1 \
        --delimiter=$'\t' \
        --prompt="  repo » " \
        --pointer="▶" \
        --marker="●" \
        --height=60% \
        --layout=reverse \
        --border=rounded \
        --border-label=" 󰊢 Repositories " \
        --border-label-pos=3 \
        --info=inline \
        --header="  ctrl-c / esc to abort" \
         --preview='
             set dir (string split \t {})[-1]
             if git -C $dir rev-parse --show-toplevel &>/dev/null 2>&1
                 echo "📁 $dir"
                 echo ""
                 git -C $dir log --oneline --color=always -5 2>/dev/null
                 echo ""
                 git -C $dir status --short --branch 2>/dev/null
             else
                 echo " $dir"
                 echo ""
                 ls -lAh --color=always $dir 2>/dev/null | head -30
             end
         ' \
        --preview-window=right:50%:wrap \
        $FZF_COLORS
  ) || return 1

  # Return the path (second field)
  awk -F'\t' '{print $2}' <<< "$selection"
}

# ─── tmux session launcher ────────────────────────────────
launch_tmux() {
  local repo_path="$1"
  local session_name
  session_name=$(basename "$repo_path" | tr ' ./' '---')

  # Reattach if session already exists
  if tmux has-session -t "$session_name" 2>/dev/null; then
    echo "  Session '$session_name' already exists — attaching…"
    if [[ -n "$TMUX" ]]; then
      tmux switch-client -t "$session_name"
    else
      tmux attach-session -t "$session_name"
    fi
    return
  fi

  # ── Create session + window 1: "git" ────────────────────
  tmux new-session -d -s "$session_name" -n "git" -c "$repo_path"

   # Pane 1 — lazygit or opencode (full width, top ~70 %)
  if ! git -C "$repo_path" rev-parse --show-toplevel &>/dev/null; then
    tmux send-keys -t "$session_name:git" "opencode" Enter
  else
    tmux send-keys -t "$session_name:git" "lazygit" Enter
  fi

  # Split horizontally → pane 2 at the bottom
  # tmux split-window -v -p 15 -t "$session_name:git" -c "$repo_path"

  # Pane 2 — a small shell / quick commands area
  tmux send-keys -t "$session_name:git.2" \
    "echo '  $(basename "$repo_path")  |  '"\$"'(git branch --show-current 2>/dev/null || echo "no git")'" \
    Enter

  # ── Window 2: "files" — yazi + shell side by side ───────
  tmux new-window -t "$session_name" -n "files" -c "$repo_path"

  # Pane 1 — yazi file manager
  tmux send-keys -t "$session_name:files" "lf" Enter

  # Split vertically → pane 2 on the right (40 %)
  # tmux split-window -h -p 30 -t "$session_name:files" -c "$repo_path"

  # Pane 2 — empty shell, ready to go
  tmux send-keys -t "$session_name:files.2" \
    'echo "  shell ready"' Enter

  # ── Window 3: "nvim" — nvim ───────────────────
  tmux new-window -t "$session_name" -n "nvim" -c "$repo_path"
  tmux send-keys -t "$session_name:nvim" "nvim" Enter

   # ── Status-bar cosmetics (scoped to this session, Gruvbox) ---
   # tmux set-option -t "$session_name" status-style         "bg=#282828,fg=#ebdbb2"
   # tmux set-option -t "$session_name" window-status-style  "fg=#a89984"
   # tmux set-option -t "$session_name" window-status-current-style "fg=#b16286,bold"
   if ! git -C "$repo_path" rev-parse --show-toplevel &>/dev/null; then
     tmux set-option -t "$session_name" status-left  "#[fg=#d79921,bold]  #S #[fg=#a89984]│ "
   else
     tmux set-option -t "$session_name" status-left  "#[fg=#d79921,bold] 󰊢 #S #[fg=#a89984]│ "
   fi
   tmux set-option -t "$session_name" status-right "#[fg=#a89984]%H:%M  %d %b | #h"
   tmux set-option -t "$session_name" status-left-length 40

  # Focus window 1 pane 1 (lazygit) on attach
  tmux select-window -t "$session_name:git"
  tmux select-pane  -t "$session_name:git.1"

  # Attach
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
}

# ─── Main ─────────────────────────────────────────────────
main() {
  require fzf tmux

  [[ -d "$REPO_ROOT" ]] || die "REPO_ROOT '$REPO_ROOT' does not exist."

  local repo
  repo=$(pick_repo) || { echo "  Aborted."; exit 0; }

  [[ -d "$repo" ]] || die "Selected path '$repo' is not a directory."

  launch_tmux "$repo"
}

main "$@"
