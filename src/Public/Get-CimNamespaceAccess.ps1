function Get-CimNamespaceAccess {
    # .EXTERNALHELP CimNamespace-help.xml
    [CmdletBinding(
        DefaultParameterSetName = 'ComputerName'
    )]
    Param (
            [Parameter(
                Mandatory = $true,
                Position = 0
            )]
            [string]
        $NameSpace,
            [parameter(
                Mandatory = $true,
                ParameterSetName = 'CimSession'
            )]
            #[CimSession[]]
        $CimSession,
            [parameter(
                ParameterSetName = 'ComputerName'
            )]
            [string]
        $ComputerName,
            [parameter(
                ParameterSetName = 'ComputerName'
            )]
            [System.Management.Automation.PSCredential]
            [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty
    )

    begin {
        $invokeParams = @{
            ClassName   = '__SystemSecurity'
            MethodName  = 'GetSecurityDescriptor'
            ErrorAction = [Management.Automation.ActionPreference]::Stop
        }

        $sessionParams = @{}

        switch ($PSCmdlet.ParameterSetName) {
            'CimSession' {
                $sessionParams.CimSession = $CimSession
            }
            Default {
                if ($PSBoundParameters.ContainsKey('Credential')) {
                    $sessionParams.Credential = $Credential
                }
                if ($ComputerName) {
                        $sessionParams.ComputerName = $ComputerName
                }
            }
        }
    }

    process {
        $invokeParams.Namespace = $NameSpace

        $output = Use-CimMethod @invokeParams @sessionParams

        if ($output.ReturnValue -ne 0) {
            throw ('GetSecurityDescriptor failed: {0}' -f $output.ReturnValue)
        }

        foreach ($ace in $output.Descriptor.DACL) {
            $UserProps = @{
                #Domain      = $ace.Trustee.Domain
                #Name        = $ace.Trustee.Name
                AccountName = '{0}\{1}' -f $ace.Trustee.Domain, $ace.Trustee.Name
                SID         = [System.Security.Principal.SecurityIdentifier] $ace.Trustee.SidString
                Type        = [CimNamespace.Dacl.AceType] $ace.AceType
                Inherited   = ($ace.AceFlags -band $script:INHERITED_ACE_FLAG) -gt 0
                Permission  = [CimNamespace.Dacl.AccessMask] $ace.AccessMask
            }

            New-PSObject -TypeName 'CimNamespace.DACL' -Property $UserProps
        }
    }
}
