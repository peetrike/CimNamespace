# Implement your module commands in this script.

Write-Verbose -Message 'Initializing module CimNamespace'

$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
foreach ($import in @($Public + $Private)) {
    try {
        . $import.FullName
    } catch {
        Write-Error -Message ('Failed to import function {0}: {1}' -f $import.FullName, $_)
    }
}

# Export only the functions in Public folder.
foreach ($function in $Public) {
    Export-ModuleMember -Function $function.BaseName
}

#region Shared enums

try {
    $null = [CimNamespace.Dacl.AccessMask]
} catch {
    Add-Type -TypeDefinition @'
        using System;
        namespace CimNamespace.Dacl {
            [Flags]
            public enum AccessMask {
                None,
                Enable        = 0x01,
                MethodExecute = 0x02,
                FullWrite     = 0x04,
                PartialWrite  = 0x08,
                ProviderWrite = 0x10,
                RemoteAccess  = 0x20,
                Subscribe     = 0x40,
                Publish       = 0x80,
                ReadSecurity  = 0x20000,
                WriteSecurity = 0x40000
            };
            public enum AceType {
                Allow,
                Deny,
                Audit
            }
        }
'@
}
$script:INHERITED_ACE_FLAG = 0x10
#endregion
