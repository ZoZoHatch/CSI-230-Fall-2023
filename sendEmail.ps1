
# Storyline: send an email

# Body of the email
$msg = "Hello there <3"

# echo to the screen
Write-Host -BackgroundColor Cyan -ForegroundColor Magenta $msg

# Subject
$sbj = "Greetings"

# From Address
$fromEmail = "lorenzo.zimmerer@mymail.champlain.edu"

# To Address
$toEmail = "deployer@csi-web"

# Sending the Email
Send-MailMessage -From $fromEmail -To $toEmail -Subject $sbj -Body $msg -SmtpServer 192.168.6.21
