########################################################
##
## Passwords.ps1
## Client facade to user management Pip.Services
## Password management commands
##
#######################################################

function Set-PipPassword
{
<#
.SYNOPSIS

Get user roles

.DESCRIPTION

Gets all assigned roles to a user by its id

.PARAMETER Connection

A connection object

.PARAMETER OldPassword

An old password

.PARAMETER NewPassword

A new password

.EXAMPLE

Set-PipPassword -Id 123

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Post",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/passwords/{0}/change",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipelineByPropertyName=$true)]
        [string] $OldPassword,
        [Parameter(Mandatory=$true, Position = 1, ValueFromPipelineByPropertyName=$true)]
        [string] $NewPassword
    )
    begin {}
    process 
    {
        if ($Connection -eq $null) {
            $Connection = Get-PipConnection
        }
        if ($Connection -eq $null) {
            throw "Server is not connected"
        }

        $userId = $null
        if ($Connection.Session -ne $null) {
            $userId = $Connection.Session.user_id
        }
        if ($userId -eq $null) {
            throw "Session is not opened"
        }

        $route = $Uri -f $userId

        $params = @{ 
            old_password = $OldPassword;
            new_password = $NewPassword;
        }

        $null = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Params $params
    }
    end {}
}


function Request-PipPassword
{
<#
.SYNOPSIS

Requests password recovery email

.DESCRIPTION

Requests a password recovery email. The email is set to the account primary email with reset code

.PARAMETER Connection

A connection object

.PARAMETER Login

User login

.EXAMPLE

Request-PipPassword -Login test@somewhere.com

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Post",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/passwords/recover",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Login
    )
    begin {}
    process 
    {
        $route = $Uri

        $request = @{ 
            login = $Login;
        }

        $null = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Request $request
    }
    end {}
}


function Reset-PipPassword
{
<#
.SYNOPSIS

Resets user password

.DESCRIPTION

Resets user password using reset code sent by email

.PARAMETER Connection

A connection object

.PARAMETER Login

User login

.PARAMETER Code

Reset code

.PARAMETER Password

A new password

.EXAMPLE

Reset-PipPassword -Login test@somewhere.com -Code 1245 -Password pass123

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Post",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/passwords/reset",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Login,
        [Parameter(Mandatory=$true, Position = 1, ValueFromPipelineByPropertyName=$true)]
        [string] $Code,
        [Parameter(Mandatory=$true, Position = 2, ValueFromPipelineByPropertyName=$true)]
        [string] $Password
    )
    begin {}
    process 
    {
        $route = $Uri

        $request = @{ 
            login = $Login;
            code = $Code;
            password = $Password;
        }

        $null = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Request $request
    }
    end {}
}