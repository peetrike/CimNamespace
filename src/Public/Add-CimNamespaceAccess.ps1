function Add-CimNamespaceAccess {
    # .EXTERNALHELP CimNamespace-help.xml
    [CmdletBinding()]
    param (
            [Parameter(
                Mandatory = $true,
                Position = 0
            )]
            [string]
        $NameSpace,
            [Parameter(
                Mandatory = $true,
                Position = 1
            )]
            [string]
        $Account,
            [Parameter(
                Mandatory = $true,
                Position = 2
            )]
            [CimNamespace.Dacl.AccessMask]
        $Permission,
            [switch]
        $Inherit,
            [switch]
        $Deny,

        #region Common parameters
            [switch]
        $PassThru
        #endregion
    )

    $invokeParams = @{
        ClassName   = '__SystemSecurity'
        Namespace   = $NameSpace
        ErrorAction = [Management.Automation.ActionPreference]::Stop
    }

    $output = Use-CimMethod -MethodName GetSecurityDescriptor @invokeParams
    if ($output.ReturnValue -ne 0) {
        throw ('GetSecurityDescriptor failed: {0}' -f $output.ReturnValue)
    }

    $acl = $output.Descriptor

    $win32Account = [Security.Principal.NTAccount] $Account

    $trustee = New-CimObject -ClassName 'win32_Trustee' -Property @{
        SidString = $win32account.Translate([Security.Principal.SecurityIdentifier]).Value
    }

    $AceProps = @{
        AccessMask = [UInt32] $Permission
        AceFlags   = if ($Inherit) {
            [UInt32] (
                [Security.AccessControl.AceFlags]::ObjectInherit +
                [Security.AccessControl.AceFlags]::ContainerInherit
            )
        } else {
            [UInt32] 0
        }
        Trustee    = $trustee
        AceType    = if ($Deny) {
            [uint32] [Security.AccessControl.AceType]::AccessDenied
        } else {
            [uint32] [Security.AccessControl.AceType]::AccessAllowed
        }
    }

    $acl.DACL += New-CimObject -ClassName 'win32_Ace' -Property $AceProps

    $setArguments = @{
        Descriptor = $acl
    }

    $output = Use-CimMethod -MethodName SetSecurityDescriptor -Arguments $setArguments @invokeParams
    if ($output.ReturnValue -ne 0) {
        throw ('SetSecurityDescriptor failed: {0}' -f $output.ReturnValue)
    }

    if ($PassThru) {
        Get-CimNamespaceAccess -NameSpace $NameSpace
    }
}
