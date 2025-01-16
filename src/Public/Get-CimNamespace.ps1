function Get-CimNamespace {
    # .EXTERNALHELP CimNamespace-help.xml
    [CmdletBinding()]
    param (
            [string]
        $NameSpace = 'ROOT',
            [switch]
        $Recurse
    )

    $QueryParam = @{
        Namespace = $NameSpace
        ClassName = '__NAMESPACE'
    }

    Get-CimObject @QueryParam -ErrorAction SilentlyContinue | Tee-Object -Variable NameSpaceList

    if ($Recurse) {
        foreach ($n in $NameSpaceList) {
            $NewNamespace = Join-Path -Path $NameSpace -ChildPath $n.Name
            Get-CimNameSpace -NameSpace $NewNamespace -Recurse:$Recurse
        }
    }
}
