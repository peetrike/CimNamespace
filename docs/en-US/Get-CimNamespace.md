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
Get-CimNamespace [[-NameSpace] <String>] [-Recurse] [<CommonParameters>]
```

## DESCRIPTION

This function returns Access Control List of specified CIM namespace

## EXAMPLES

### Example 1

```powershell
Get-CimNamespaceAccess -Namespace 'root/cimv2'
```

This function returns the namespaces within **root/cimv2** namespace

## PARAMETERS

### -NameSpace

The namespace to operate with

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: ROOT
Accept pipeline input: False
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

## NOTES

## RELATED LINKS
