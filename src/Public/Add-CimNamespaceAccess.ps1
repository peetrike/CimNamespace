<#
    .Synopsis
        Modify the current security descriptor of a WMI namespace.
    .DESCRIPTION
        A Script for modifying the current security descriptor of a WMI namespace.
    .EXAMPLE
        Set-WMIPermission.ps1 -namespace root/cimv2 -account "contoso\AD - Remote WMI Access" -operation Add -permissions Enable
    .EXAMPLE
        Set-WmiNamespaceSecurity.ps1 root/cimv2 add steve Enable,RemoteAccess
    .NOTES
        Blog links:
        https://docs.microsoft.com/archive/blogs/wmi/scripting-wmi-namespace-security-part-3-of-3

        Modified by Graeme Bray
        Original Content by Steve Lee
#>
function Add-CimNamespaceAccess {
Param (
        [parameter(
            Mandatory=$true,
            Position=0
        )]
        [string]
    $NameSpace,
        [parameter(
            Mandatory=$true,
            Position=1
        )]
        [ValidateSet('Add', 'Remove')]
        [string]
    $Operation,
        [parameter(
            Mandatory=$true,
            Position=2
        )]
        [string]
    $Account,
        [parameter(
            Position=3
        )]
        [string[]]
    $Permission = $null,
        [switch]
    $Inherit,
        [switch]
    $Deny,
        [string]
    $ComputerName = '.',
        [System.Management.Automation.PSCredential]
    $Credential = $null
)

Process {
    $ErrorActionPreference = 'Stop'

    Function Get-AccessMaskFromPermission {
        param ($permissions)

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

        $accessMask = 0

        foreach ($permission in $permissions) {
            $accessMask += $WbemRights.$permission
        }

        $accessMask
    }

    $remoteParams = @{ ComputerName = $computerName }

    if ($PSBoundParameters.ContainsKey('Credential')) {
        $remoteParams.Credential=$credential
    }

    $invokeParams = @{ Namespace = $namespace; Path='__systemsecurity=@' } + $remoteParams

    $output = Invoke-WmiMethod @invokeParams -Name GetSecurityDescriptor
    if ($output.ReturnValue -ne 0) {
        throw "GetSecurityDescriptor failed: $($output.ReturnValue)"
    }

    $acl = $output.Descriptor
    $OBJECT_INHERIT_ACE_FLAG = 0x1
    $CONTAINER_INHERIT_ACE_FLAG = 0x2

    $computerName = (Get-WmiObject @remoteParams Win32_ComputerSystem).Name

    if ($account.Contains('\')) {
        $domainAccount = $account.Split('\')
        $domain = $domainAccount[0]
        if (($domain -eq '.') -or ($domain -eq 'BUILTIN')) {
            $domain = $computerName
        }
        $accountName = $domainAccount[1]
    } elseif ($account.Contains('@')) {
        $domainAccount = $account.Split('@')
        $domain = $domainAccount[1].Split('.')[0]
        $accountName = $domainAccount[0]
    } else {
        $domain = $computerName
        $accountName = $account
    }

    $getParams = @{ Class = 'Win32_Account'; Filter="Domain='$domain' and Name='$accountname'" }

    $win32account = Get-WmiObject @getparams

    if ($null -eq $win32account) {
        throw "Account was not found: $account"
    }

    switch ($operation) {
        'Add' {
            if ($null -eq $permissions) {
                throw '-Permissions must be specified for an add operation'
            }
            $accessMask = Get-AccessMaskFromPermission($permissions)

            $ace = (New-Object System.Management.ManagementClass('win32_Ace')).CreateInstance()
            $ace.AccessMask = $accessMask
            if ($allowInherit) {
                $ace.AceFlags = $OBJECT_INHERIT_ACE_FLAG + $CONTAINER_INHERIT_ACE_FLAG
            } else {
                $ace.AceFlags = 0
            }

            $trustee = (New-Object System.Management.ManagementClass('win32_Trustee')).CreateInstance()
            $trustee.SidString = $win32account.Sid
            $ace.Trustee = $trustee

            $ACCESS_ALLOWED_ACE_TYPE = 0x0
            $ACCESS_DENIED_ACE_TYPE = 0x1

            if ($deny) {
                $ace.AceType = $ACCESS_DENIED_ACE_TYPE
            } else {
                $ace.AceType = $ACCESS_ALLOWED_ACE_TYPE
            }

            $acl.DACL += $ace.psobject.immediateBaseObject
        }

        'Remove' {
            if ($null -ne $permissions) {
                throw 'Permissions cannot be specified for a delete operation'
            }

            [System.Management.ManagementBaseObject[]]$newDACL = @()
            foreach ($ace in $acl.DACL) {
                if ($ace.Trustee.SidString -ne $win32account.Sid) {
                    $newDACL += $ace.psobject.immediateBaseObject
                }
            }

            $acl.DACL = $newDACL.psobject.immediateBaseObject
        }

        default {
            throw "Unknown operation: $operation`nAllowed operations: add remove"
        }
    }

    $setparams = @{ Name = 'SetSecurityDescriptor'; ArgumentList=$acl.psobject.immediateBaseObject } + $invokeParams

    $output = Invoke-WmiMethod @setparams
    if ($output.ReturnValue -ne 0) {
        throw ("SetSecurityDescriptor failed: $($output.ReturnValue)" -f $output.ReturnValue)
    }
}
}
