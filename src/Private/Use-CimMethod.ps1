
function Use-CimMethod {

    [CmdletBinding()]
    param (
            [Parameter(
                Mandatory = $true,
                Position = 0
            )]
            [string]
        $NameSpace,

            [Parameter(
                Mandatory = $true
            )]
            [Alias('Name')]
            [string]
        $MethodName,

            [Parameter(
                Mandatory = $true
            )]
            [Alias('Class')]
            [string]
        $ClassName
    )

    begin {
        $invokeParams = @{}
        if ($Command = Get-Command Invoke-CimMethod -ErrorAction SilentlyContinue) {
            $invokeParams.MethodName = $MethodName
            $invokeParams.ClassName = $ClassName
        } else {
            $Command = Get-Command Invoke-WmiMethod
            $invokeParams.Name = $MethodName
            $invokeParams.Class = $ClassName
        }

        $sessionParams = @{}

        <# switch ($PSCmdlet.ParameterSetName) {
            'CimSession' {
                $invokeParams.CimSession = $CimSession
            }
            Default {
                if ($PSBoundParameters.ContainsKey('Credential')) {
                    $sessionParams.Credential = $Credential
                }
                if ($ComputerName) {
                        $sessionParams.ComputerName = $ComputerName
                }
            }
        } #>
    }

    process {
        $invokeParams.Namespace = $NameSpace
        & $Command @invokeParams @sessionParams
    }
}
