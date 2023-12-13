# Storyline: Log in to a remote SSH server and run commands remotely

cls

# Connect to SSH server
New-SSHSession -ComputerName '192.168.4.22' -Credential (Get-Credential sys320)

while ($true) {

    # Prompt for a command to run
    $cmd = Read-Host -Prompt "Please enter a command"

    # Run command on remote SSH server
    (Invoke-SSHCommand -index 0 $cmd).Output

} # end while

# Close connection to SSH server
Remove-SSHSession -SessionId 0

