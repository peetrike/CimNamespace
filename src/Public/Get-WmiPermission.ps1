#Requires -Version 2

<#
    .SYNOPSIS
        Returns the security descriptor for the CIM NameSpace
    .DESCRIPTION
        Returns the security descriptor for the CIM NameSpace
    .EXAMPLE
        Get-WmiPermission.ps1 -NameSpace root\cimv2

        Returns DACL of root\cimv2 namespace
    .NOTES
        Based on blog article
        https://docs.microsoft.com/archive/blogs/wmi/scripting-wmi-namespace-security-part-2-of-3
#>

[CmdletBinding(
    DefaultParameterSetName = 'ComputerName'
)]
Param (
        [parameter(
            Mandatory = $true,
            Position = 0
        )]
        [string]
    $NameSpace,
        [parameter(
            Mandatory = $true,
            ParameterSetName = 'CimSession'
        )]
        #[CimSession[]]
    $CimSession,
        [parameter(
            ParameterSetName = 'ComputerName'
        )]
        [string]
    $ComputerName,
        [parameter(
            ParameterSetName = 'ComputerName'
        )]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
    $Credential = [System.Management.Automation.PSCredential]::Empty,
        [switch]
    $UseCim = ($PSVersionTable.PSVersion.Major -gt 2)
)

begin {
    Function Get-PermissionFromAccessMask ($accessMask) {
        $WbemRights = @{
            Enable        = 0x01    # WBEM_ENABLE
            MethodExecute = 0x02    # WBEM_METHOD_EXECUTE
            FullWrite     = 0x04    # WBEM_FULL_WRITE_REP
            PartialWrite  = 0x08    # WBEM_PARTIAL_WRITE_REP
            ProviderWrite = 0x10    # WBEM_WRITE_PROVIDER
            RemoteAccess  = 0x20    # WBEM_REMOTE_ACCESS
            Subscribe     = 0x40    # WBEM_RIGHT_SUBSCRIBE
            Publish       = 0x80    # WBEM_RIGHT_PUBLISH
            ReadSecurity  = 0x20000 # READ_CONTROL
            WriteSecurity = 0x40000 # WRITE_DAC
        }

        foreach ($right in $WbemRights.Keys) {
            if ($accessMask -band $WbemRights.$right) {
                $right
            }
        }
    }

    $INHERITED_ACE_FLAG = 0x10

    $invokeParams = @{
        Class       = '__SystemSecurity'
        Name        = 'GetSecurityDescriptor'
        ErrorAction = [Management.Automation.ActionPreference]::Stop
    }

    $sessionParams = @{}

    switch ($PSCmdlet.ParameterSetName) {
        'CimSession' {
            $invokeParams.CimSession = $CimSession
        }
        Default {
            if ($PSBoundParameters.ContainsKey('Credential')) {
                $sessionParams.Credential = $Credential
            }
            if ($ComputerName) {
                    $sessionParams.ComputerName = $ComputerName
            }
        }
    }
}

process {
    #$ErrorActionPreference = [Management.Automation.ActionPreference]::Stop

    $invokeParams.Namespace = $NameSpace

    $output = if ($UseCim) {
        try {
            if (-not $invokeParams.CimSession) {
                $invokeParams.CimSession = New-CimSession @sessionParams -Verbose:$false -ErrorAction Stop
            }
            Invoke-CimMethod @invokeParams
            if (-not $PSCmdlet.ParameterSetName -eq 'CimSession') {
                Remove-CimSession $invokeParams.CimSession
            }
        } catch {
            throw
        }
    } else {
        Invoke-WmiMethod @invokeParams @sessionParams
    }

    if ($output.ReturnValue -ne 0) {
        throw ('GetSecurityDescriptor failed: {0}' -f $output.ReturnValue)
    }

    foreach ($ace in $output.Descriptor.DACL) {
        $UserProps = @{
            #Domain      = $ace.Trustee.Domain
            #Name        = $ace.Trustee.Name
            AccountName = '{0}\{1}' -f $ace.Trustee.Domain, $ace.Trustee.Name
            SID         = [System.Security.Principal.SecurityIdentifier] $ace.Trustee.SidString
            Type        = @('Allow', 'Deny')[$ace.AceType]
            Inherited   = ($ace.AceFlags -band $INHERITED_ACE_FLAG) -gt 0
            Permission  = Get-PermissionFromAccessMask $ace.AccessMask
        }

        New-Object PSCustomObject -Property $UserProps
    }
}
