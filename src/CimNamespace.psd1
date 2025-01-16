@{
    ModuleToProcess   = 'CimNamespace.psm1'
    ModuleVersion     = '0.1.0'

    GUID              = '50e1a28c-b1d4-4192-9993-a931198f24d8'

    Author            = 'CPG4285'
    CompanyName       = 'Telia Eesti'
    Copyright         = 'Copyright (c) 2022 Telia Eesti'

    Description       = 'Commands managing CIM namespaces'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '2.0'

    <# CompatiblePSEditions = @(
        'Core'
        'Desktop'
    ) #>

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @('bin\CimNamespace.dll')

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # Expensive for import time, no more than one should be used.
    TypesToProcess    = @('CimNamespace.Types.ps1xml')

    # Format files (.ps1xml) to be loaded when importing this module.
    # Expensive for import time, no more than one should be used.
    FormatsToProcess  = @('CimNamespace.Format.ps1xml')

    # Functions to export from this module
    FunctionsToExport = @(
        'Add-CimNamespaceAccess'
        'Get-CimNamespace'
        'Get-CimNamespaceAccess'
        'Remove-CimNamespaceAccess'
    )

    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all files packaged with this module
    # FileList          = @()

    PrivateData       = @{
        PSData = @{
            Tags         = @(
                'cim'
                'wmi'
                'namespace'
                'PSEdition_Core'
                'PSEdition_Desktop'
                'Windows'
            )

            LicenseUri   = 'https://github.com/peetrike/CimNamespace/blob/main/LICENSE'
            ProjectUri   = 'https://github.com/peetrike/cimnamespace'
            ReleaseNotes = 'https://github.com/peetrike/CimNamespace/blob/main/CHANGELOG.md'

            # A URL to an icon representing this module.
            # IconUri = ''

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()
        }
    }
}
