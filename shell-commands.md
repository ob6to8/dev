*Create file and store text in it*
```
cat > filename.txt << 'EOF'
text
more text
EOF
```

**What it does:** `cat` reads input and `>` redirects it into `filename.txt` (overwriting if it exists). `<< 'EOF'` starts a heredoc — everything typed until

**Why this form:** quoting the delimiter (`'EOF'`) stops the shell from expanding `$variables` or backticks inside the text — safer for arbitrary content. Dr
op the quotes (`<< EOF`) only if you want variable substitution.

For a single line, simpler is `echo "your text" > filename.txt` (`>>` instead of `>` to append rather than overwrite).


*checks for zombie claude processes*
```
ps -eo pid,ppid,tty,stat,etime,command | grep "claude --dangerously" 
```


```
1lsof /dev/ttysXXX | awk '{print $1,$2,$3}' | sort -u
```

The tty column (ttys005, ttys051, etc.) is the identifier — each distinct value is a separate open pane. This checks to confirm a given tty is truly attached to a live parent (not orphaned) rather than trusting elapsed time:
If that returns a zsh (or your shell) entry, the pane is open. If it returns nothing, the device is stale/orphaned and safe to clean up.

To match a ttys00X to an actual visible Warp tab, run tty inside each pane you have open — it prints the device name for that pane, so you can cross-reference against the list above.
