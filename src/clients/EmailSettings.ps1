########################################################
##
## EmailSettings.ps1
## Client facade to user management Pip.Services
## Email settings commands
##
#######################################################

function Get-PipEmailSettings
{
<#
.SYNOPSIS

Get user email settings

.DESCRIPTION

Gets all users email settings by its id

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/email_settings/{0})

.PARAMETER Id

A unique user id

.EXAMPLE

PS> Get-PipEmailSettings -Name "test" -Id 123

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
        [string] $Uri = "/api/1.0/email_settings/{0}",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Id
    )
    begin {}
    process 
    {
        $route = $Uri -f $Id

        $result = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route

        Write-Output $result
    }
    end {}
}


function Set-PipEmailSettings
{
<#
.SYNOPSIS

Set user email settings

.DESCRIPTION

Sets all users email settings defined by its id

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Method

An operation method (default: 'Put')

.PARAMETER Uri

An operation uri (default: /api/1.0/email_settings/{0})

.PARAMETER Settings

An user email settings with the following structure
- id: string
- name: string
- email: string
- language: string
- subscriptions: any
- custom_hdr: any
- custom_dat: any

.EXAMPLE

PS> Set-PipEmailSettings -Name "test" -Settings @{ id="123"; name="Test user"; email="test@somewhere.com"; language="en" }

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Name,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Put",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/email_settings/{0}",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object] $Settings
    )
    begin {}
    process 
    {
        $route = $Uri -f $Settings.id

        $result = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Request $Settings

        Write-Output $result
    }
    end {}
}


function Request-PipEmailVerification
{
<#
.SYNOPSIS

Requests email verification message

.DESCRIPTION

Requests a email verification message by user login

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Login

User login

.EXAMPLE

PS> Request-PipEmailVerification -Name "test" -Login test@somewhere.com

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
        [string] $Uri = "/api/1.0/email_settings/resend",
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

        $null = Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route -Request $request
    }
    end {}
}


function Submit-PipEmailVerification
{
<#
.SYNOPSIS

Verifies user email address

.DESCRIPTION

Verifies user email address using reset code sent by email

.PARAMETER Connection

A connection object

.PARAMETER Name

A name to refer to the client facade

.PARAMETER Login

User login

.PARAMETER Code

Reset code

.EXAMPLE

PS> Submit-PipEmailVerification -Name "test" -Login test@somewhere.com -Code 1245

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
        [string] $Uri = "/api/1.0/email_settings/verify",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string] $Login,
        [Parameter(Mandatory=$true, Position = 1, ValueFromPipelineByPropertyName=$true)]
        [string] $Code
    )
    begin {}
    process 
    {
        $route = $Uri

        $request = @{ 
            login = $Login;
            code = $Code;
        }

        $null = Invoke-PipFacade -Connection $Connection -Name $Name -Method $Method -Route $route -Request $request
    }
    end {}
}