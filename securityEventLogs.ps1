# Storyline: Review the Security Event Log

# List all the Available Windows Event Logs
Get-EventLog -List 

# prompt the user to selevt the log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"

# prompt the user for a string to search for in the log
$searchPhrase = Read-Host -Prompt "Please enter a phrase to filter the logs by"

# Print the results of the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike $searchPhrase } | Export-Csv -NoTypeInformation `
-Path "C:\Users\champuser\Desktop\securityLogs.csv"
