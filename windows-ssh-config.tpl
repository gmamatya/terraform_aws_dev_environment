add-content -path "$env:USERPROFILE\.ssh\config" -value @'

Host ${hostname}
  HostName ${hostname}
  User ${user}
  IdentityFile ${identityfile}
  StrictHostKeyChecking no
'@