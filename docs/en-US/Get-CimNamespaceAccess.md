---
external help file: CimNamespace-help.xml
Module Name: CimNamespace
online version:
schema: 2.0.0
---

# Get-CimNamespaceAccess

## SYNOPSIS

Returns the security descriptor for the CIM NameSpace

## SYNTAX

### ComputerName (Default)
```
Get-CimNamespaceAccess [-NameSpace] <String> [-ComputerName <String>] [-Credential <PSCredential>]
 [<CommonParameters>]
```

### CimSession
```
Get-CimNamespaceAccess [-NameSpace] <String> -CimSession <Object> [<CommonParameters>]
```

## DESCRIPTION

Returns the security descriptor for the CIM NameSpace

## EXAMPLES

### EXAMPLE 1

```powershell
Get-CimNamespaceAccess -NameSpace root\cimv2
```

Returns DACL of root\cimv2 namespace

## PARAMETERS

### -CimSession

Specifies the CIM session to use for this cmdlet.
Enter a variable that contains the CIM session or a command that creates or gets
the CIM session, such as the `New-CimSession` or `Get-CimSession` cmdlets.
For more information, see [about_CimSession](https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_cimsession)

```yaml
Type: Object
Parameter Sets: CimSession
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ComputerName

Specifies the target computer on which you want to run the CIM operation.
Enter a fully qualified domain name (FQDN), a NetBIOS name, or an IP address.
If you do not specify this parameter, the cmdlet performs the operation on the
local computer.

If you specify this parameter, the cmdlet creates a temporary session
to the specified computer using the WsMan protocol.

If multiple operations are being performed on the same computer,
connect using a CIM session for better performance.

```yaml
Type: String
Parameter Sets: ComputerName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential

Specifies a user account that has permission to perform this action.
The default is the current user. Type a user name, such as "User01", "Domain01\User01",
or User@Contoso.com.
Or, enter a PSCredential object, such as an object that is returned
by the `Get-Credential` cmdlet.
When you type a user name, you are prompted for a password.
Credentials cannot be used when targeting the local computer.

```yaml
Type: PSCredential
Parameter Sets: ComputerName
Aliases:

Required: False
Position: Named
Default value: [System.Management.Automation.PSCredential]::Empty
Accept pipeline input: False
Accept wildcard characters: False
```

### -NameSpace

Specifies the namespace of CIM repository.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

Based on blog article
https://docs.microsoft.com/archive/blogs/wmi/scripting-wmi-namespace-security-part-2-of-3

## RELATED LINKS
