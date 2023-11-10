# Storyline: using the Get-Process and Get-Service

# Get-Process returns the same info that's in taskmanager
Get-Process | Select-Object ProcessName, Path, ID | `
Export-Csv -Path "C:\Users\champuser\Desktop\myProcess.csv" -NoTypeInformation
    # select-object filters to show name, file path and ID of each process in the order specified

# Get-Service returns all the available services on the system
Get-Service | Where { $_.Status -eq "Running" }
    # gets all the available services that are currently running



