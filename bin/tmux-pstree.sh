#!/bin/bash
#
# List all process tree (with pid's) of each tmux session, divided per tmux panel.
#
# from: 
# http://superuser.com/questions/212714/how-to-find-which-tmux-session-a-process-belongs-to/594765#594765

for s in `tmux list-sessions -F '#{session_name}'` ; do
  echo -e "\ntmux session name: $s\n--------------------"
  for p in `tmux list-panes -s -F '#{pane_pid}' -t "$s"` ; do
    pstree -p -a $p
  done
done
