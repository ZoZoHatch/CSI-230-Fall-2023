# Array of websites containing threat intel
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

# Array for the filenames
$input_paths = @()

# Loop through the URLs for the rules list
foreach ($u in $drop_urls) {

    # Extract the filename
    $temp = $u.split("/")

    # The last element in the array plucked off is the filename
    $file_name = $temp[-1]

    # Populate input_paths array
    $input_paths += ".\$file_name"

    # Check that the file doesn't already exist
    if (!(Test-Path $file_name))  {
    
        # Download the rules list if it doesn't exist
        Invoke-WebRequest -Uri $u -Outfile $file_name

    }#end if()

}# end foreach()


# Extract IP addresses
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Append IP addresses to the temporary IP list
Select-String -Path $input_paths -Pattern $regex_drop | `
ForEach-Object { $_.Matches } | `
ForEach-Object { $_.Value } | `
Sort-Object -Unique | `
OUt-File -FilePath './temp_ips.txt'


# Get the IP address discovered, loop through and replace the beginning of the line with the IPTapbels syntaxt
# After the IP address, add the remaining IPTables sintax and save the results to a file

# iptables -A INPUT -s IP -j DROP
(Get-Content -Path "./temp_ips.txt") | % `
{ $_ -replace "^","iptables -A INPUT -s " -replace "$"," -j DROP"} | `
Out-File -FilePath "iptables.bash"