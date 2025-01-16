# CimNamespace

## about_CimNamespace

# SHORT DESCRIPTION

Commands managing CIM namespaces

# LONG DESCRIPTION

This module allows to manage CIM namespace access control.

# EXAMPLES

The following example lists ACL of the **root/cimv2** namespace

```powershell
Get-CimNamespaceAccess -NameSpace root/cimv2
```

The following example adds remote execute permission to **root/cimv2** namespace
to _Remote Management Users_ local group.

```powershell
Add-CimNamespaceAccess -NameSpace root/cimv2 -Account 'Remote MAnagement Users' -Permission RemoteAccess
```

# NOTES

Based on blog article
https://learn.microsoft.com/archive/blogs/wmi/scripting-wmi-namespace-security-part-2-of-3

# SEE ALSO

[Securing WMI Namespaces](https://learn.microsoft.com/windows/win32/wmisdk/securing-wmi-namespaces)

# KEYWORDS

- CIM
- WMI
- Security
- Access
