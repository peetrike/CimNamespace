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
        $Namespace,
            [string[]]
        $Property = '*'
    )

    $query = 'SELECT {0} FROM {1}' -f ($Property -join ','), $ClassName
    if ($Filter) { $query += ' WHERE {0}' -f $Filter }

    $searcher = [wmisearcher] $query

    if ($Namespace) { $searcher.Scope = [System.Management.ManagementScope] $Namespace }

    $searcher.Get()
}
