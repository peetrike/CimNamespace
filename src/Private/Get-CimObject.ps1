function Get-CimObject {
    [CmdletBinding(
        DefaultParameterSetName = 'Default'
    )]
    param (
            [Parameter(
                Mandatory = $true,
                ParameterSetName = 'Default',
                Position = 0
            )]
            [string]
        $ClassName,
            [Parameter(
                ParameterSetName = 'Default'
            )]
            [string]
        $Filter,
            [Parameter(
                ParameterSetName = 'Default'
            )]
            [string[]]
        $Property = '*',
            [Parameter(
                Mandatory = $true,
                ParameterSetName = 'Query'
            )]
            [string]
        $Query,
            [string]
        $Namespace = 'ROOT\cimv2'
    )

    if ($PSCmdlet.ParameterSetName -eq 'Default') {
        $Query = @(
            'SELECT {0} FROM {1}' -f ($Property -join ','), $ClassName
            if ($Filter) { 'WHERE {0}' -f $Filter }
        ) -join ' '
    }

    $searcher = [wmisearcher] $Query

    if ($Namespace) { $searcher.Scope = [System.Management.ManagementScope] $Namespace }

    $searcher.Get()
}
