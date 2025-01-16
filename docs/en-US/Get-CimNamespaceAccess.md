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

```
Get-CimNamespaceAccess [-NameSpace] <String> [<CommonParameters>]
```

## DESCRIPTION

Returns the security descriptor for the CIM NameSpace

## EXAMPLES

### EXAMPLE 1

```powershell
Get-CimNamespaceAccess -NameSpace root\cimv2
```

Returns DACL of **root/cimv2** namespace

## PARAMETERS

### -NameSpace

Specifies the CIM namespace.

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

### None

## OUTPUTS

### CimNamespace.ACE

Access Control List of specified namespace

## NOTES

## RELATED LINKS

[GetSecurityDescriptor method](https://learn.microsoft.com/windows/win32/wmisdk/getsecuritydescriptor-method-in-class---systemsecurity-)
