# Storyline Complete the week 9 assignment

# part 1: Grab the network adapter info using WMI class
    # Get the DHCP server's IP address, default gateway and the DNS server IPs
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Select-Object DHCPserver, IPAddress, DefaultIPGateway, DNSIPAddress


# part 2: Export list of running processes and running services into seperate files
    # Export running processes into a CSV
Get-Process | Select-Object ProcessName, Path, ID | `
Export-Csv -Path "C:\Users\champuser\Desktop\myProcesses.csv" -NoTypeInformation

    # Export running services into a CSV
Get-Service | Where { $_.Status -eq "Running" } | ` 
Export-Csv -Path "C:\Users\champuser\Desktop\myServices.csv" -NoTypeInformation


# part 3: Start or stop Windows Calculator using only Powershell and the Process name for Windows Calculator
    # win32calc

$caclOpen = Get-Process | Where { $_.Name -eq "win32calc" } 

if ( $caclOpen.Name -eq "win32calc" ) 
{
    Get-Process | Where { $_.Name -eq "win32calc" } | Stop-Process
}
else
{
    Start-Process "win32calc"
}
