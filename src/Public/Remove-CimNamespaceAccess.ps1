function Remove-CimNamespaceAccess {
    # .EXTERNALHELP CimNamespace-help.xml
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
            [Parameter(
                Mandatory=$true,
                Position=0
            )]
            [string]
        $NameSpace,
            [Parameter(
                Mandatory = $true,
                ParameterSetName = 'AccountName',
                Position = 2
            )]
            [string]
        $Account,
            [Parameter(
                Mandatory = $true,
                Position = 2
            )]
            [CimNamespace.Dacl.AccessMask]
        $Permission,

        #region Common parameters
            [switch]
        $PassThru
        #endregion
    )

    $invokeParams = @{
        ClassName   = '__SystemSecurity'
        Namespace   = $NameSpace
        ErrorAction = [Management.Automation.ActionPreference]::Stop
        WhatIf      = $false
        Confirm     = $false
    }

    $output = Use-CimMethod -MethodName 'GetSecurityDescriptor' @invokeParams
    if ($output.ReturnValue -ne 0) {
        throw "GetSecurityDescriptor failed: $($output.ReturnValue)"
    }

    $acl = $output.Descriptor

    $win32Account = [Security.Principal.NTAccount] $Account
    $AccountSid = $win32Account.Translate([Security.Principal.SecurityIdentifier]).Value

    $acl.DACL = $acl.DACL | ForEach-Object {
        if ($_.Trustee.SidString -ne $AccountSid) {
            $_
        } else {
            $newMask = $_.AccessMask - $Permission
            if ($newMask -ne 0) {
                $_.AccessMask = $newMask
                $_
            }
        }
    }

    $SetArguments = @{
        Descriptor = $acl
    }

    if ($PSCmdlet.ShouldProcess($Account)) {
        $output = Use-CimMethod -MethodName SetSecurityDescriptor -Arguments $SetArguments @invokeParams
        if ($output.ReturnValue -ne 0) {
            throw ('SetSecurityDescriptor failed: {0}' -f $output.ReturnValue)
        }
    }

    if ($PassThru) {
        Get-CimNamespaceAccess -NameSpace $NameSpace
    }
}
