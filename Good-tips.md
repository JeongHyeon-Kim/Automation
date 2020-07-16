# Installation process history inquiry  
dnf history

# Rollback action (removing history)
dnf history rollback {history id of wanting to go back}

# Undo action (registering history)
dnf history undo {history id of wanting to undo}

# Undo last action (without id)
dnf history undo last

# Extract file list only & Extract file name only
ls -l | grep -v ^d  > {file name for saving list}  
cut -c 46- {file name for saving list}

# Backup dnf history
mv /var/lib/dnf/history.sqlite history.sqlite_backup

# Clear dnf history
rm -rf /var/lib/dnf/history.sqlite
