########################################################
##
## SmsSettings.ps1
## Client facade to user management Pip.Services
## Sms settings commands
##
#######################################################

function Get-PipSmsSettings
{
<#
.SYNOPSIS

Get user sms settings

.DESCRIPTION

Gets all users sms settings by its id

.PARAMETER Connection

A connection object

.PARAMETER Method

An operation method (default: 'Get')

.PARAMETER Uri

An operation uri (default: /api/1.0/sms_settings/{0})

.PARAMETER Id

A unique user id

.EXAMPLE

Get-PipSmsSettings -Id 123

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Get",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/sms_settings/{0}",
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


function Set-PipSmsSettings
{
<#
.SYNOPSIS

Set user sms settings

.DESCRIPTION

Sets all users sms settings defined by its id

.PARAMETER Connection

A connection object

.PARAMETER Method

An operation method (default: 'Put')

.PARAMETER Uri

An operation uri (default: /api/1.0/sms_settings/{0})

.PARAMETER Settings

An user sms settings with the following structure
- id: string
- name: string
- phone: string
- language: string
- subscriptions: any
- custom_hdr: any
- custom_dat: any

.EXAMPLE

Set-PipSmsSettings -Settings @{ id="123"; name="Test user"; phone="+79102348273"; language="en" }

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Put",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/sms_settings/{0}",
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


function Request-PipSmsVerification
{
<#
.SYNOPSIS

Requests sms verification message

.DESCRIPTION

Requests a sms verification message by user login

.PARAMETER Connection

A connection object

.PARAMETER Login

User login

.EXAMPLE

Request-PipSmsVerification -Login test@somewhere.com

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Post",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/sms_settings/resend",
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


function Submit-PipPhoneVerification
{
<#
.SYNOPSIS

Verifies user phone number

.DESCRIPTION

Verifies user phone number using reset code sent via sms

.PARAMETER Connection

A connection object

.PARAMETER Login

User login

.PARAMETER Code

Reset code

.EXAMPLE

Submit-PipPhoneVerification -Login test@somewhere.com -Code 1245

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Post",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/sms_settings/verify",
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

        $null = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Request $request
    }
    end {}
}