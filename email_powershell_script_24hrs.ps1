$from = "ramkumars@newtglobalcorp.com"
$to = "kirans@newtglobalcorp.com"
$cc = @("sandeepr@newtglobalcorp.com","jayakarthid@newtglobalcorp.com")
$smtpServer = "smtp.office365.com"
$smtpPort = 587
$username = Get-AutomationVariable -Name "username"
$password = Get-AutomationVariable -Name "password"

# Create email subject and body
$subject = "Important: Your DMAP SaaS Trial Period - 24 Hours Remaining"
$body = @"
<html>
<body style="font-family: Arial, sans-serif; color: #333333;">
    <p>Dear Valued Customer,</p>
    
    <p>We hope you're having a great experience with DMAP SaaS solution. This is a courtesy reminder that your trial period will expire in 24 hours.</p>
    
    <p>To ensure uninterrupted access to our services, we recommend taking action on your subscription:</p>
    
    <ul>
        <li>Review your trial experience</li>
        <li>Explore our subscription plans</li>
        <li>Contact our sales team for personalized assistance</li>
    </ul>
    
    <p>If you have any questions or need support in transitioning to a full subscription, please don't hesitate to reach out to our dedicated support team.</p>
    
    <p>Thank you for choosing DMAP SaaS for your business needs.</p>
    
    <p>Best regards,<br>
    The DMAP Team<br>
    NewtGlobal Corp</p>
    
    <p style="font-size: 12px; color: #666666;">
    Note: If you've already upgraded your subscription, please disregard this message.
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
