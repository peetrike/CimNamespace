function Get-CimNamespace {
    # .EXTERNALHELP CimNamespace-help.xml
    [CmdletBinding()]
    [outputtype('System.Management.ManagementObject#ROOT\cimv2\__NAMESPACE')]
    param (
            [Parameter(
                ValueFromPipelineByPropertyName = $true
            )]
            [Alias('FullName')]
            [string[]]
        $NameSpace = 'root/cimv2',
            [switch]
        $Recurse
    )

    begin {
        $cimProps = @{
            ClassName   = '__NAMESPACE'
            ErrorAction = [Management.Automation.ActionPreference]::SilentlyContinue
        }
    }

    process {
        $nameSpaceList = $null
        foreach ($n in $NameSpace) {
            $cimProps.Namespace = $n

            Get-CimObject @cimProps |
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
    }
}
