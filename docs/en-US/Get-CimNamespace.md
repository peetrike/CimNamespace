---
external help file: CimNamespace-help.xml
Module Name: CimNamespace
online version:
schema: 2.0.0
---

# Get-CimNamespace

## SYNOPSIS

Returns CIM namespace list

## SYNTAX

```
Get-CimNamespace [[-NameSpace] <String[]>] [-Recurse] [<CommonParameters>]
```

## DESCRIPTION

This function returns subnamespace list of specified CIM namespace

## EXAMPLES

### Example 1

```powershell
Get-CimNamespaceAccess -Namespace 'root'
```

This function returns the namespaces within **root** namespace

## PARAMETERS

### -NameSpace

Specifies namespaces to operate with

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: FullName

Required: False
Position: 0
Default value: ROOT\cimv2
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Recurse

Return contents of specified namespace and child namespaces

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Management.ManagementObject#ROOT\cimv2\__NAMESPACE

Collection of namespaces contained inside specified namespaces.

## NOTES

## RELATED LINKS
