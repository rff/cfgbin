#!/bin/bash
#
# List all process tree (with pid's) of each tmux session, divided per tmux panel.
#
# from: 
# http://superuser.com/questions/212714/how-to-find-which-tmux-session-a-process-belongs-to/594765#594765

for s in `tmux list-sessions -F '#{session_name}'` ; do
  echo "====================="
  echo "tmux session name: $s"
  echo "====================="
  for w in `tmux list-windows -F '#{window_index}' -t $s` ; do
    echo "---------------------"
    echo "tmux window index: $w"
    echo "---------------------"
    for p in `tmux list-panes -F '#{pane_index}' -t $s:$w` ; do
      pane_id="$s:$w.$p"
      pid=`tmux display-message -p -t ${pane_id} '#{pane_pid}'`
      echo "[=== pane $pane_id ===]  "
      pstree -p -a $pid
    done
  done
done
