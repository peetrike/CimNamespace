function Get-CimNamespace {
    # .EXTERNALHELP CimNamespace-help.xml
    [CmdletBinding()]
    param (
            [string]
        $NameSpace = 'ROOT',
            [switch]
        $Recurse
    )

    $nameSpaceList = $null
    Get-CimObject -Namespace $NameSpace -ClassName '__NAMESPACE' -ErrorAction SilentlyContinue |
        Tee-Object -Variable nameSpaceList

    if ($Recurse) {
        foreach ($n in $nameSpaceList) {
            $name = $n.Name
            Write-Debug -Message "Processing namespace $name"
            $NewNamespace = Join-Path -Path $NameSpace -ChildPath $name
            Get-CimNameSpace -NameSpace $NewNamespace -Recurse
        }
    }
}
