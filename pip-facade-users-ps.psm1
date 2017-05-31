########################################################
##
## pip-facade-users-ps.ps1
## Client facade to user management Pip.Services
## Powershell module entry
##
#######################################################

$path = $PSScriptRoot
if ($path -eq "") { $path = "." }

. "$($path)/src/clients/Sessions.ps1"
. "$($path)/src/clients/Accounts.ps1"
. "$($path)/src/clients/Roles.ps1"
. "$($path)/src/clients/Connections.ps1"
. "$($path)/src/clients/Passwords.ps1"
