########################################################
##
## Sessions.ps1
## Client facade to user management Pip.Services
## Session management commands
##
#######################################################


function Register-PipUser
{
<#
.SYNOPSIS

Signs up a new user

.DESCRIPTION

Performs signup and opens a new session

.PARAMETER Connection

A connection object

.PARAMETER Method

An operation method (default: 'Post')

.PARAMETER Uri

An operation uri (default: /api/1.0/signup)

.PARAMETER User

An user info with the following structure
- email: string
- name: string
- login: string
- password: string
- about: string (optional)
- theme: string  (optional)
- language: string (optional)
- theme: string (optional)

.EXAMPLE

Register-PipUser -User @{ name="Test User"; login="test"; email="test@somewhere.com"; password="test123" }

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Post",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/signup",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object] $User
    )
    begin {}
    process 
    {
        $route = $Uri

        $session = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Request $User

        $Connection = if ($Connection -eq $null) { Get-IqtConnection } else { $Connection }
        if ($Connection -ne $null) {
            $Connection.Headers["x-session-id"] = $session.id
            $Connection.Session = $session
        }
        
        Write-Output $session
    }
    end {}
}


function Open-PipSession
{
<#
.SYNOPSIS

Opens a new user session with client facade

.DESCRIPTION

Open-PipSession opens connection and starts a new user session with client facade

.PARAMETER Connection

A connection object

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/signin)

.PARAMETER SessionHeader

Header name where session id is placed (default: x-session-id)

.PARAMETER Login

User login

.PARAMETER Password

User password

.EXAMPLE

$test = Open-PipSession -Login "test1@somewhere.com" -Password "mypassword"

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Get",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/signin",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $SessionHeader = "x-session-id",
        [Parameter(Mandatory=$true, Position = 4, ValueFromPipelineByPropertyName=$true)]
        [string] $Login,
        [Parameter(Mandatory=$true, Position = 5, ValueFromPipelineByPropertyName=$true)]
        [string] $Password
    )
    begin {}
    process 
    {
        $route = $Uri
        $params = @{
            login = $Login
            password = $Password
        }

        $session = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Params $params

        $Connection = if ($Connection -eq $null) { Get-PipConnection } else {$Connection}
        if ($Connection -ne $null) {
            $Connection.Headers[$SessionHeader] = $session.id
            $Connection.Session = $session
        }
        
        Write-Output $session
    }
    end {}
}


function Close-PipSession
{
<#
.SYNOPSIS

Closes previously opened user session with client facade

.DESCRIPTION

Open-PipSession closes previously opened user session with client facade

.PARAMETER Connection

A connection object

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/signout)

.EXAMPLE

Close-PipConnection

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Get",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/signout",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $SessionHeader = "x-session-id"
    )
    begin {}
    process 
    {
        $route = $Uri

        $session = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route

        $Connection = if ($Connection -eq $null) { Get-PipConnection } else {$Connection}
        if ($Connection -ne $null) {
            $Connection.Headers[$SessionHeader] = $null
            $Connection.Session = $null
        }
        
        Write-Output $session
    }
    end {}
}


function Get-PipSessions
{
<#
.SYNOPSIS

Gets sessions by specified criteria

.DESCRIPTION

Gets a page with sessions that satisfy specified criteria

.PARAMETER Connection

A connection object

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/sessions)

.PARAMETER Filter

A filter with search criteria (default: no filter)

.PARAMETER Skip

A number of records to skip (default: 0)

.PARAMETER Take

A number of records to return (default: 100)

.PARAMETER Total

A include total count (default: false)

.EXAMPLE

Get-PipSessions -Take 10

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Get",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/sessions",
        [Parameter(Mandatory=$false, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Filter = @{},
        [Parameter(Mandatory=$false, Position = 1, ValueFromPipelineByPropertyName=$true)]
        [int] $Skip = 0,
        [Parameter(Mandatory=$false, Position = 2, ValueFromPipelineByPropertyName=$true)]
        [int] $Take = 100,
        [Parameter(Mandatory=$false, Position = 3, ValueFromPipelineByPropertyName=$true)]
        [bool] $Total
    )
    begin {}
    process 
    {
        $route = $Uri

        $params = $Filter +
        @{ 
            skip = $Skip;
            take = $Take
            total = $Total
        }

        $result = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Params $params

        Write-Output $result.Data
    }
    end {}
}


function Get-PipCurrentSession
{
<#
.SYNOPSIS

Gets the current session

.DESCRIPTION

Gets the current session

.PARAMETER Connection

A connection object

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/sessions/current)

.EXAMPLE

Get-PipCurrentSession

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Get",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/sessions/current"
    )
    begin {}
    process 
    {
        $route = $Uri

        $result = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Params $params

        Write-Output $result
    }
    end {}
}
