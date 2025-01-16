function New-CimObject {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
            [Parameter(
                Mandatory = $true,
                Position = 0
            )]
            [string]
        $ClassName,
            [string]
        $Namespace,
            [Collections.IDictionary]
        $Property
    )

    $CommandParams = @{}
    if ($Namespace) {
        $CommandParams.Namespace = $Namespace
    }

    if (Get-Command New-CimInstance -ErrorAction SilentlyContinue) {
        $CommandParams.ClassName = $ClassName
        New-CimInstance @CommandParams -ClientOnly -Property $Property
    } else {
        $CimObject = (
            New-Object System.Management.ManagementClass -ArgumentList (
                $Namespace,     # Scope
                $ClassName,     # Path
                $null           # ObjectGetOptions
            )
        ).CreateInstance()
        foreach ($key in $Property.Keys) {
            $CimObject.$key = $Property[$key]
        }
        $CimObject
    }
}
