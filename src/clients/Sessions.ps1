########################################################
##
## Sessions.ps1
## Client facade to user management Pip.Services
## Session management commands
##
#######################################################


function Open-PipSession
{
<#
.SYNOPSIS

Opens a new user session with client facade

.DESCRIPTION

Open-PipSession opens connection and starts a new user session with client facade

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.EXAMPLE

PS> $test = Open-PipSession -Name "test" -Login "test1@somewhere.com" -Password "mypassword"

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true, Position = 4, ValueFromPipelineByPropertyName=$true)]
        [string] $Login,
        [Parameter(Mandatory=$true, Position = 5, ValueFromPipelineByPropertyName=$true)]
        [string] $Password
    )
    begin {}
    process 
    {
        $route = "/api/1.0/signin"
        $params = @{
            login = $Login
            password = $Password
        }

        $session = Invoke-PipFacade -Connection $Connection -Method "Get" -Route $route -Params $params

        $Connection = if ($Connection -eq $null) { Get-PipConnection -Name $Name } else {$Connection}
        if ($Connection -ne $null) {
            $Connection.Headers["x-session-id"] = $session.id
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

.PARAMETER Name

A name to refer to the client facade

.EXAMPLE

PS> Close-PipConnection -Name "test"

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name
    )
    begin {}
    process 
    {
        $route = "/api/1.0/signout"

        $session = Invoke-PipFacade -Connection $Connection -Method "Get" -Route $route

        $Connection = if ($Connection -eq $null) { Get-PipConnection -Name $Name } else {$Connection}
        if ($Connection -ne $null) {
            $Connection.Headers["x-session-id"] = $session.id
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

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Filter

A filter with search criteria (default: no filter)

.PARAMETER Skip

A number of records to skip (default: 0)

.PARAMETER Take

A number of records to return (default: 100)

.EXAMPLE

# Read top 10 user sessions from test cluster in text format
PS> Get-PipSessions -Name "test" -Take 10

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
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
        $route = "/api/1.0/sessions"

        $params = $Filter +
        @{ 
            skip = $Skip;
            take = $Take
            total = $Total
        }

        $result = Invoke-PipFacade -Connection $Connection -Name $Name -Method "Get" -Route $route -Params $params

        Write-Output $result.Data
    }
    end {}
}

