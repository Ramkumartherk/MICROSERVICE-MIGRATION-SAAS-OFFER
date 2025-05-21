$from = ""
$to = ""
$cc = @("","")
$smtpServer = "smtp.office365.com"
$smtpPort = 587
$username = Get-AutomationVariable -Name "username"
$password = Get-AutomationVariable -Name "password"

# Create email subject and body
$subject = "Important: Your DMAP SaaS Offer Trial Expiration Notice"
$body = @"
<html>
<body style="font-family: Arial, sans-serif; color: #333333;">
    <p>Dear Valued Customer,</p>
    
    <p>This is an important notification regarding your DMAP SaaS offer trial subscription.</p>
    
    <p><strong>Please be advised that your trial period will expire in the next 30 minutes.</strong></p>
    
    <p>To ensure uninterrupted access to our services, we recommend taking one of the following actions:</p>
    <ul>
        <li>Upgrade to a full subscription</li>
        <li>Contact our sales team to discuss available options</li>
        <li>Back up any important data before the trial expires</li>
    </ul>
    
    <p>If you have any questions or need assistance, please don't hesitate to contact our support team.</p>
    
    <p>Best regards,<br>
    DMAP Team<br>
    NewtGlobal Corp</p>
    
    <p style="font-size: 12px; color: #666666;">
    This is an automated message. Please do not reply directly to this email.
    </p>
</body>
</html>
"@

# Send email
try {
    $message = New-Object System.Net.Mail.MailMessage
    $message.From = $from
    $message.To.Add($to)
    $message.CC.Add($cc)
    $message.Subject = $subject
    $message.Body = $body
    $message.IsBodyHtml = $true

    

    # Configure SMTP client
    $smtpClient = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
    $smtpClient.EnableSsl = $true
    $smtpClient.Credentials = New-Object System.Net.NetworkCredential($username, $password)

    # Send email
    $smtpClient.Send($message)
    "Email sent successfully."
} catch {
    "Failed to send email: $_"
}
