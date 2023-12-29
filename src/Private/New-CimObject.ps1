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
        $Namespace
    )

    $CommandParams = @{}
    if ($Namespace) {
        $CommandParams.Namespace = $Namespace
    }

    if (Get-Command New-CimInstance -ErrorAction SilentlyContinue) {
        $CommandParams.ClassName = $ClassName
        New-CimInstance @CommandParams -ClientOnly
    } else {
        (New-Object System.Management.ManagementClass($ClassName)).CreateInstance()
    }
}
