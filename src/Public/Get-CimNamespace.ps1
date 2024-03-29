﻿function Get-CimNamespace {
    # .EXTERNALHELP CimNamespace-help.xml
    [CmdletBinding()]
    param (
            [string]
        $NameSpace = 'ROOT',
            #[CimSession[]]
        $CimSession,
            [switch]
        $Recurse
    )

    $QueryParam = @{
        Namespace = $NameSpace
        ClassName = '__NAMESPACE'
    }
    #$NameSpaceValue = { $this.CimSystemProperties.Namespace }
    if ($CimSession) {
        $QueryParam.CimSession = $CimSession
    }
    $NameSpaceList = Get-CimObject @QueryParam -ErrorAction SilentlyContinue #|
        #Add-Member -MemberType ScriptProperty -Name 'Namespace' -Value $NameSpaceValue -PassThru
    $NameSpaceList
    if ($Recurse.IsPresent) {
        ForEach ($n in $NameSpaceList) {
            $QueryParam.Namespace = Join-Path -Path $NameSpace -ChildPath $n.Name
            $QueryParam.Remove('ClassName')
            Get-CimNameSpace @QueryParam
        }
    }
}
