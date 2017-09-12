########################################################
##
## Sms.ps1
## Client facade to user management Pip.Services
## Sms commands
##
#######################################################

function Send-PipSms
{
<#
.SYNOPSIS

Requests sms message to arbitrary address

.DESCRIPTION

Requests sms message to arbitrary address

.PARAMETER Connection

A connection object

.PARAMETER Message

Message object with the following fields:
- from: string
- to: string
- text: string

.PARAMETER Recipient

Optional recipient identified who is a system user

.EXAMPLE

Send-PipSms -Message @{ to="+79102348237"; text="This is a test sms" }

#>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Hashtable] $Connection,
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Method = "Post",
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string] $Uri = "/api/1.0/sms",
        [Parameter(Mandatory=$true, Position = 0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Object] $Message,
        [Parameter(Mandatory=$false, Position = 1, ValueFromPipelineByPropertyName=$true)]
        [Object] $Recipient
    )
    begin {}
    process 
    {
        $route = $Uri
        $params = $null

        if ($Recipient -ne $null) {
            $params = @{
                recipient_id = $Recipient.id
                recipient_name = $Recipient.name
                recipient_sms = $Recipient.sms
                language = $Recipient.language
            }
        }

        $null = Invoke-PipFacade -Connection $Connection -Method $Method -Route $route -Params $params -Request $Message
    }
    end {}
}
