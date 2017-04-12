# 192.168.197.114 root calvin
function Unblock-Certs
{
    Add-Type -TypeDefinition @"
	    using System.Net;
	    using System.Security.Cryptography.X509Certificates;
	    public class TrustAllCertsPolicy : ICertificatePolicy {
	        public bool CheckValidationResult(
	            ServicePoint srvPoint, X509Certificate certificate,
	            WebRequest request, int certificateProblem) {
	            return true;
	        }
	    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName TrustAllCertsPolicy
}

function Connect-iDRACSession
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $iDRAC_IP = "192.168.2.193",
        $iDRAC_Port = 443,
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   Position=0)][pscredential]$Credentials,
        [switch]$trustCert
    )
    Begin
    {
    if ($trustCert.IsPresent)
        {
        Unblock-Certs
        }
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    }
    Process
    {
    if (!$Credentials)
        {
        $User = Read-Host -Prompt "Please Enter iDRAC username"
        $SecurePassword = Read-Host -Prompt "Enter iDRAC Password for user $user" -AsSecureString
        $Credentials = New-Object System.Management.Automation.PSCredential (�$user�,$Securepassword)
        }
    write-Verbose "Generating Login Token"
    $Global:iDRAC_baseurl = "https://$($iDRAC_IP):$iDRAC_Port" # :$iDRAC_Port"
    $Global:iDRAC_Credentials = $Credentials
    Write-Verbose $idrac_baseurl
    try
        {
        $Tokens = Invoke-RestMethod -UseBasicParsing "$Global:iDRAC_baseurl/redfish/v1/Sessions" -Credential $credentials -ContentType 'Application/Json' -Method Post # ).content | ConvertFrom-Json | select -ExpandProperty value

        }
    catch [System.Net.WebException]
        {
        # Write-Warning $_.Exception.Message
        #Get-SIOWebException -ExceptionMessage $_.Exception.Message
		Write-Host "to be defined"
        Write-Verbose $_
        Write-Warning $_.Exception.Message
        Break
        }
    catch
        {
        Write-Verbose $_
        Write-Warning $_.Exception.Message
        break
        }
        #>
        Write-Host "Successfully connected to iDRac with IP $iDRAC_IP"
        Write-Host " we got the following Schemas: "
        $Global:IDRAC_Schemas = $Schemas
		#$Schemas
		Get-iDRACManagerUri
		Get-iDRACChassisUri
		Get-iDRACSystemUri

    }
    End
    {
    }
}
functi

function Connect-iDRAC
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $iDRAC_IP = "192.168.2.193",
        $iDRAC_Port = 443,
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   Position=0)][pscredential]$Credentials,
        [switch]$trustCert
    )
    Begin
    {
    if ($trustCert.IsPresent)
        {
        Unblock-Certs
        }
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::TLS12
    }
    Process
    {
    if (!$Credentials)
        {
        $User = Read-Host -Prompt "Please Enter iDRAC username"
        $SecurePassword = Read-Host -Prompt "Enter iDRAC Password for user $user" -AsSecureString
        $Credentials = New-Object System.Management.Automation.PSCredential (�$user�,$Securepassword)
        }
    write-Verbose "Generating Login Token"
    $Global:iDRAC_baseurl = "https://$($iDRAC_IP):$iDRAC_Port" # :$iDRAC_Port"
    $Global:iDRAC_Credentials = $Credentials
    Write-Verbose $idrac_baseurl
    try
        {
        $Schemas = (Invoke-WebRequest -UseBasicParsing "$Global:iDRAC_baseurl/redfish/v1/odata" -Credential $credentials -ContentType 'Application/Json' ).content | ConvertFrom-Json | select -ExpandProperty value

        }
    catch [System.Net.WebException]
        {
        # Write-Warning $_.Exception.Message
        #Get-SIOWebException -ExceptionMessage $_.Exception.Message
		Write-Host "to be defined"
        Write-Verbose $_
        Write-Warning $_.Exception.Message
        Break
        }
    catch
        {
        Write-Verbose $_
        Write-Warning $_.Exception.Message
        break
        }
        #>
        Write-Host "Successfully connected to iDRac with IP $iDRAC_IP"
        Write-Host " we got the following Schemas: "
        $Global:IDRAC_Schemas = $Schemas
		#$Schemas
		Get-iDRACManagerUri
		Get-iDRACChassisUri
		Get-iDRACSystemUri

    }
    End
    {
    }
}
function Get-iDRACManagerUri
{
$Myself = $MyInvocation.MyCommand.Name.Substring(9) -replace "URI" 
$Schema = ($global:IDRAC_schemas | where name -Match $Myself).URL
$outputobject = (invoke-WebRequest -ContentType 'application/json;charset=utf-8' -Uri "$global:IDRAC_baseurl$Schema" -Credential $GLobal:idrac_credentials).content | ConvertFrom-Json
$Global:iDRAC_Manager = "$base_api_uri$($outputobject.Members.'@odata.id')"
Write-Host -ForegroundColor Green "==> Got $Myself URI $Global:iDRAC_Manager"
} 
function Get-iDRACSystemUri
{
$Myself = $MyInvocation.MyCommand.Name.Substring(9) -replace "URI" 
$Schema = ($global:IDRAC_schemas | where name -Match $Myself).URL
$outputobject = (invoke-WebRequest -ContentType 'application/json;charset=utf-8' -Uri "$global:IDRAC_baseurl$Schema" -Credential $GLobal:idrac_credentials).content | ConvertFrom-Json
$Global:iDRAC_System = "$base_api_uri$($outputobject.Members.'@odata.id')"
Write-Host -ForegroundColor Green "==> Got $Myself URI $Global:iDRAC_System"
}
function Get-iDRACChassisUri
{
$Myself = $MyInvocation.MyCommand.Name.Substring(9) -replace "URI" 
$Schema = ($global:IDRAC_schemas | where name -Match $Myself).URL
$outputobject = (invoke-WebRequest -ContentType 'application/json;charset=utf-8' -Uri "$global:IDRAC_baseurl$Schema" -Credential $GLobal:idrac_credentials).content | ConvertFrom-Json
$Global:iDRAC_Chassis = "$base_api_uri$($outputobject.Members.'@odata.id')"
Write-Host -ForegroundColor Green "==> Got $Myself URI $Global:iDRAC_Chassis"
}
function Get-iDRACManagerElement
{
[CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("Function")]
        $iDRAC_Element
    )
(invoke-WebRequest -ContentType 'application/json;charset=utf-8' -Uri "$Global:iDRAC_Manager/$iDRAC_Element" -Verbose -Credential $Global:iDRAC_credentials).content | ConvertFrom-Json

}
function Get-iDRACSystemElement
{
[CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("Function")]
        [ValidateSet('Processors','Storage/Controllers','EthernetInterfaces')]
        $iDRAC_Element
    )
$system_element = @()
$members = (invoke-WebRequest -ContentType 'application/json;charset=utf-8' -Uri "$Global:iDRACbaseurl$Global:iDRAC_System/$iDRAC_Element" -Credential $Global:iDRAC_credentials).content | ConvertFrom-Json
if ($members.members.count -gt 1)
    {
	foreach ($member in $members.members)
		{
		Write-Host -ForegroundColor Green "==> getting SystemElement $member"
		$system_element += (invoke-WebRequest -ContentType 'application/json;charset=utf-8' -Uri "$Global:iDRACbaseurl$($member.'@odata.id')" -Credential $Global:iDRAC_credentials).content | ConvertFrom-Json
		}
    }
else
    {
    $system_element = $members[0]
    }

if (!$iDRAC_Element)
	{
	$system_element.PSTypeNames.Insert(0, "System")
	}
else
	{
	$system_element.PSTypeNames.Insert(0, "$iDRAC_Element")
	}
Write-Output $system_element
}
function Get-iDRACChassisElement
{
[CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("Function")]
        [ValidateSet('Power','Thermal')]
        $iDRAC_Element
    )
$members = @()
$Chassis_element = @()

$members += (invoke-WebRequest -ContentType 'application/json;charset=utf-8' -Uri "$Global:iDRACbaseurl$Global:iDRAC_Chassis/$iDRAC_Element" -Credential $Global:iDRAC_credentials).content | ConvertFrom-Json
if ($members.count -gt 1)
    {
#$members
    foreach ($member in $members.member)
        {
        Write-Host -ForegroundColor Green "==> getting ChassisElement  $($member.'@odata.id')"
        $Chassis_element += (invoke-WebRequest -ContentType 'application/json;charset=utf-8' -Uri "$Global:iDRACbaseurl$($member.'@odata.id')" -Credential $Global:iDRAC_credentials -Verbose).content | ConvertFrom-Json
        }
    }
else
    {
    $Chassis_element = $members[0]
    }
if ($iDRAC_Element) 
	{
	$Chassis_element.PSTypeNames.Insert(0, "$iDRAC_Element")
	}
else
	{
	$Chassis_element.PSTypeNames.Insert(0, "Chassis")
	}
Write-Output $Chassis_element
}
function Get-iDRACManagerElement
{
[CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("Function")]
        [ValidateSet('LogServices','NetworkProtocol')]
        $iDRAC_Element
    )
$members = @()
$Manager_element = @()

$members += (invoke-WebRequest -ContentType 'application/json;charset=utf-8' -Uri "$Global:iDRACbaseurl$Global:iDRAC_Manager/$iDRAC_Element" -Credential $Global:iDRAC_credentials).content | ConvertFrom-Json
if ($members.members.count -gt 1)
    {
#$members
    foreach ($member in $members.members)
        {
        Write-Host -ForegroundColor Green "==> getting ManagerElement  $($member.'@odata.id')"
        $Manager_element += (invoke-WebRequest -ContentType 'application/json;charset=utf-8' -Uri "$Global:iDRACbaseurl$($member.'@odata.id')" -Credential $Global:iDRAC_credentials -Verbose).content | ConvertFrom-Json
        }
    }
else
    {
    $Manager_element = $members[0]
    }
if ($iDRAC_Element) 
	{
	$Manager_element.PSTypeNames.Insert(0, "$iDRAC_Element")
	}
else
	{
	$Manager_element.PSTypeNames.Insert(0, "Manager")
	}
Write-Output $Manager_element
}
function Get-iDRACodata
{
[CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName='1')]
        [Alias("@odata.id")]
        $odata
    )

begin
{}
process
{
Write-Host -ForegroundColor Green "==> getting elements for odata Link $odata"
(invoke-WebRequest -ContentType 'application/json;charset=utf-8' -Uri "$Global:iDRACbaseurl$($odata)" -Credential $Global:iDRAC_credentials -Method Get).content | ConvertFrom-Json

}
end
{}

}