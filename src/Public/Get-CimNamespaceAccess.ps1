function Get-CimNamespaceAccess {
    # .EXTERNALHELP CimNamespace-help.xml
    [CmdletBinding()]
    [OutputType('CimNamespace.Ace')]
    param (
            [Parameter(
                Mandatory = $true
            )]
            [string]
        $NameSpace
    )

    $invokeParams = @{
        ClassName  = '__SystemSecurity'
        MethodName = 'GetSecurityDescriptor'
        Namespace  = $NameSpace
    }

    $output = Use-CimMethod @invokeParams -ErrorAction Stop

    if ($output.ReturnValue -ne 0) {
        throw ('GetSecurityDescriptor failed: {0}' -f $output.ReturnValue)
    }

    foreach ($ace in $output.Descriptor.DACL) {
        $UserProps = @{
            AccountName = '{0}\{1}' -f $ace.Trustee.Domain, $ace.Trustee.Name
            SID         = [Security.Principal.SecurityIdentifier] $ace.Trustee.SidString
            Type        = [Security.AccessControl.AceType] $ace.AceType
            AceFlags    = [Security.AccessControl.AceFlags] $ace.AceFlags
            IsInherited = ($ace.AceFlags -band [Security.AccessControl.AceFlags]::Inherited) -gt 0
            Permission  = [CimNamespace.Dacl.AccessMask] $ace.AccessMask
        }

        New-PSObject -TypeName 'CimNamespace.ACE' -Property $UserProps
    }
}
