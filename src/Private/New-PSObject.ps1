function New-PSObject {
    [CmdletBinding()]
    param (
            [string]
        $TypeName,
            [parameter(
                Mandatory = $true,
                Position = 0
            )]
            [Collections.IDictionary]
        $Property
    )

    if ($PSVersionTable.PSVersion.Major -gt 2) {
        if ($TypeName) { $Property.PSTypeName = $TypeName }
        [pscustomobject] $Property
    } else {
        $object = New-Object -TypeName PSObject -Property $Property
        if ($TypeName) { $object.psobject.TypeNames.Insert(0, $TypeName) }
        $object
    }
}
