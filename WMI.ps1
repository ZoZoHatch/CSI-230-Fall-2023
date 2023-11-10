# Storyline: Use the Get-WMI cmdlet

Get-WMiobject -Class Win32_service | select Name, PathName, ProcessId
