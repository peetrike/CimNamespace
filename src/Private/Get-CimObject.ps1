function Get-CimObject {
    [CmdletBinding()]
    param (
            [parameter(
                Mandatory = $true,
                Position = 0
            )]
            [string]
        $ClassName,
            [string]
        $Filter,
            [string]
        $Namespace
    )

    $CommandParams = @{}
    if ($Namespace) {
        $CommandParams.Namespace = $Namespace
    }
    if ($Filter) {
        $CommandParams.Filter = $Filter
    }

    if ($Command = Get-Command Get-CimInstance -ErrorAction SilentlyContinue) {
        $CommandParams.ClassName = $ClassName
    } else {
        $CommandParams.Class  = $ClassName
        $Command = Get-Command Get-WmiObject
    }
    & $Command @CommandParams
}
