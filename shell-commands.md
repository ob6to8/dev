$ ps -eo pid,ppid,tty,stat,etime,command | grep "claude --dangerously" 
checks for zombie claude processes

$ 1lsof /dev/ttysXXX | awk '{print $1,$2,$3}' | sort -u
The tty column (ttys005, ttys051, etc.) is the identifier — each distinct value is a separate open pane. This checks to confirm a given tty is truly attached to a live parent (not orphaned) rather than trusting elapsed time:
If that returns a zsh (or your shell) entry, the pane is open. If it returns nothing, the device is stale/orphaned and safe to clean up.

To match a ttys00X to an actual visible Warp tab, run tty inside each pane you have open — it prints the device name for that pane, so you can cross-reference against the list above.
