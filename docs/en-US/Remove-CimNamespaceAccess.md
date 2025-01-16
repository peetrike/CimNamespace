---
external help file: CimNamespace-help.xml
Module Name: CimNamespace
online version:
schema: 2.0.0
---

# Remove-CimNamespaceAccess

## SYNOPSIS

Remove permissions from specified CIM namespace

## SYNTAX

```
Remove-CimNamespaceAccess [-NameSpace] <String> [-Account] <String> [-Permission <AccessMask>] [-PassThru]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

This function removes permissions from CIM Namespace for specified account.

## EXAMPLES

### Example 1

```powershell
Remove-CimNamespaceAccess -Namespace root/cimv2 -Account 'Remote Management Users'
```

This example removes access entry for Remote Management Users local group
from namespace **root/cimv2**

## PARAMETERS

### -Account

Specifies account name to remove

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

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NameSpace

Specifies namespace to operate on

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

Specifies permission to remove.  When permission is not specified, then all account entries are removed.

```yaml
Type: AccessMask
Parameter Sets: (All)
Aliases:
Accepted values: None, EnableAccount, MethodExecute, FullWrite, PartialWrite, ProviderWrite, RemoteAccess, Subscribe, Publish, ReadSecurity, WriteSecurity

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
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

[Add-CimNamespaceAccess](Add-CimNamespaceAccess.md)

[SetSecurityDescriptor method](https://learn.microsoft.com/windows/win32/wmisdk/setsecuritydescriptor-method-in-class---systemsecurity)
