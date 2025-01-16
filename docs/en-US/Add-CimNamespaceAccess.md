---
external help file: CimNamespace-help.xml
Module Name: CimNamespace
online version:
schema: 2.0.0
---

# Add-CimNamespaceAccess

## SYNOPSIS

Add ACE to the current security descriptor of a CIM namespace.

## SYNTAX

```
Add-CimNamespaceAccess [-NameSpace] <String> [-Account] <String> [-Permission] <AccessMask> [-Inherit] [-Deny]
 [-PassThru] [<CommonParameters>]
```

## DESCRIPTION

This function adds Access Control Entry (ACE) to the current security descriptor
of a CIM namespace.

## EXAMPLES

### Example 1

```powershell
Add-CimNamespaceAccess.ps1 -account 'contoso\AD - Remote WMI Access' -Permission EnableAccount
```

This example adds remote executing perimssion to specified domain group

## PARAMETERS

### -Account

Specifies account name to add permissions to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Deny

Add Deny permissions

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Inherit

Enable inheritance for specified permissions

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NameSpace

Specify namespace to change permissions on

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

### -PassThru

Returns resultant ACL to pipeline.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Permission

Specifies permissions to add.

```yaml
Type: AccessMask
Parameter Sets: (All)
Aliases:
Accepted values: None, EnableAccount, MethodExecute, FullWrite, PartialWrite, ProviderWrite, RemoteAccess, Subscribe, Publish, ReadSecurity, WriteSecurity

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

### CimNamespace.ACE

Current ACL when _-PassThru_ parameter is used.

## NOTES

## RELATED LINKS

[Remove-CimNamespaceAccess](Remove-CimNamespaceAccess.md)

[SetSecurityDescriptor method](https://learn.microsoft.com/windows/win32/wmisdk/setsecuritydescriptor-method-in-class---systemsecurity)
