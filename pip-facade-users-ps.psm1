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
