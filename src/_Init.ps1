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
                EnableAccount = 0x01,
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
        }
'@
}
#endregion
