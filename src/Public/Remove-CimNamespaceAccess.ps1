function Remove-CimNamespaceAccess {
    # .EXTERNALHELP CimNamespace-help.xml
    [OutputType([void])]
    [OutputType('CimNamespace.Ace')]
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

    $Descriptor = $output.Descriptor

    $win32Account = [Security.Principal.NTAccount] $Account
    $AccountSid = $win32Account.Translate([Security.Principal.SecurityIdentifier]).Value

    $Descriptor.DACL = $Descriptor.DACL | ForEach-Object {
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
        Descriptor = $Descriptor
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
