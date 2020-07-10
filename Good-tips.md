# Installation process history inquiry  
dnf history


# Installation rollback  
dnf history rollback {history id of wanting to go back}

# Extract file list only & Extract file name only
ls -l | grep -v ^d  > {file name for saving list}  
cut -c 46- {file name for saving list}
