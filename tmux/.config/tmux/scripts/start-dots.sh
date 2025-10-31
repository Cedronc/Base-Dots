#!/bin/zsh

SESSIONNAME="Dots"
tmux has-session -t $SESSIONNAME &> /dev/null

if [ $? != 0 ] 
 then
    tmux new-session -d -s $SESSIONNAME -n lazygit -c ~/Base-Dots/.
    tmux send-keys -t $SESSIONNAME "lazygit" C-m 
    tmux new-window -n nvim -c ~/Base-Dots/.
    tmux send-keys -t $SESSIONNAME "nvim ." C-m
    tmux new-window -c ~/Base-Dots/. -n stow
fi

tmux attach -t $SESSIONNAME

