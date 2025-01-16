function Use-CimMethod {
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
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
        $ClassName,

            [Collections.IDictionary]
        $Arguments
    )

    $invokeParams = @{
        Namespace = $NameSpace
    }
    if ($Command = Get-Command Invoke-CimMethod -ErrorAction SilentlyContinue) {
        $invokeParams.MethodName = $MethodName
        $invokeParams.ClassName = $ClassName
        if ($Arguments) {
            $invokeParams.Arguments = $Arguments
        }
    } else {
        $Command = Get-Command Invoke-WmiMethod
        $invokeParams.Name = $MethodName
        $invokeParams.Class = $ClassName
        if ($Arguments) {
            $invokeParams.ArgumentList = $Arguments.Values | ForEach-Object { $_.psobject.ImmediateBaseObject }
        }
    }

    & $Command @invokeParams
}
