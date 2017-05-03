########################################################
##
## Accounts.ps1
## Client facade to user management Pip.Services
## User accounts commands
##
#######################################################

function New-PipAccount
{
<#
.SYNOPSIS

Creates a new user account

.DESCRIPTION

Creates a new user account

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Post')

.PARAMETER Uri

An operation uri (default: /api/1.0/signup)

.PARAMETER Account

An account with the following structure
- email: string
- name: string
- login: string
- password: string
- about: string (optional)
- theme: string  (optional)
- language: string (optional)
- theme: string (optional)

.EXAMPLE

# Creates a new user account and 
PS> Write-PipLog -Name "test" -Message @{ correlation_id="123"; level=2; source="Powershell" error=@{ message="Failed" }; message="Just a test" }

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Post",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/signup",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object] $Account
    )
    begin {}
    process 
    {
        $route = $Uri

        $session = Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route -Request $Account

        $Connection = if ($Connection -eq $null) { Get-PipConnection -Name $Name } else {$Connection}
        if ($Connection -ne $null) {
            $Connection.Headers["x-session-id"] = $session.id
        }
        
        Write-Output $session
    }
    end {}
}


function Get-PipAccounts
{
<#
.SYNOPSIS

Gets user accounts by specified criteria

.DESCRIPTION

Gets a page with accounts that satisfy specified criteria

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/accounts)

.PARAMETER Filter

A filter with search criteria (default: no filter)

.PARAMETER Skip

A number of records to skip (default: 0)

.PARAMETER Take

A number of records to return (default: 100)

.PARAMETER Total

A include total count (default: false)

.EXAMPLE

# Read top 10 user accounts from test cluster in text format
PS> Get-PipAccounts -Name "test" -Take 10

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Get",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/accounts",
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

        $result = Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route -Params $params

        Write-Output $result.Data
    }
    end {}
}