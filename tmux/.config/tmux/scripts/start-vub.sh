#!/bin/zsh

SESSIONNAME="VUB"
tmux has-session -t $SESSIONNAME &> /dev/null

if [ $? != 0 ] 
 then
    tmux new-session -s $SESSIONNAME -n lazygit -d -c "~/Documents/git/VUB/."
    tmux send-keys -t $SESSIONNAME "lazygit" C-m 
    tmux new-window -n nvim
    tmux send-keys -t nvim "nvim ." C-m 
    tmux new-window -c "~/Documents/MyVault/." -n MyVault
    tmux send-keys "nvim ." C-m 
fi

tmux attach -t $SESSIONNAME

