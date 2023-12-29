function Get-CimNamespaceAccess {
    # .EXTERNALHELP CimNamespace-help.xml
    [CmdletBinding(
        DefaultParameterSetName = 'ComputerName'
    )]
    param (
            [Parameter(
                Mandatory = $true,
                Position = 0
            )]
            [string]
        $NameSpace,

        #region Common parameters
            [Parameter(
                Mandatory = $true,
                ParameterSetName = 'CimSession'
            )]
            #[CimSession[]]
        $CimSession,
            [Parameter(
                ParameterSetName = 'ComputerName'
            )]
            [string]
        $ComputerName,
            [Parameter(
                ParameterSetName = 'ComputerName'
            )]
            [Management.Automation.PSCredential]
            [Management.Automation.Credential()]
        $Credential #= [Management.Automation.PSCredential]::Empty
        #endregion
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
                SID         = [Security.Principal.SecurityIdentifier] $ace.Trustee.SidString
                Type        = [Security.AccessControl.AceType] $ace.AceType
                AceFlags    = [Security.AccessControl.AceFlags] $ace.AceFlags
                IsInherited = ($ace.AceFlags -band [Security.AccessControl.AceFlags]::Inherited) -gt 0
                Permission  = [CimNamespace.Dacl.AccessMask] $ace.AccessMask
            }

            New-PSObject -TypeName 'CimNamespace.ACE' -Property $UserProps
        }
    }
}
