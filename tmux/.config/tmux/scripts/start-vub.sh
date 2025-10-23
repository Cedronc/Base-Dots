#!/bin/zsh

SESSIONNAME="VUB"
tmux has-session -t $SESSIONNAME &> /dev/null

if [ $? != 0 ] 
 then
    tmux new-session -s $SESSIONNAME -n lazygit -c ~/Documents/git/VUB/.
    tmux send-keys -t $SESSIONNAME "lazygit" C-m 
    tmux new-window -n nvim -c ~/Documents/git/VUB/.
    tmux new-window -c ~/Documents/MyVault/. -n MyVault
    tmux select-window -t nvim
fi

tmux attach -t $SESSIONNAME

