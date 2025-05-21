# Define email details
$from = ""
$to = ""
$cc = @("","")
$smtpServer = "smtp.office365.com"
$smtpPort = 587

# Retrieve the variables from the Automation account
$VM_IP_Address = Get-AutomationVariable -Name "VM_IP_Address"
$API_Service_Manager_Name = Get-AutomationVariable -Name "API_Service_Manager_Name"
$username = Get-AutomationVariable -Name "username"
$password = Get-AutomationVariable -Name "password"

# Create email subject and body with both VM IP address and API Service Manager
$subject = "Your DMAP SaaS Application - Access Details"
$body = @"
<div style='font-family: Arial, sans-serif; color: #333333;'>
    <p>Dear Valued Customer,</p>

    <p>Thank you for choosing DMAP. We are pleased to inform you that your DMAP application instance has been successfully provisioned and is now ready for use.</p>

    <h3>Access Information:</h3>
    <ul>
        <li><strong>Instance URL:</strong> <a href='https://$API_Service_Manager_Name.azure-api.net/DMAP'>https://$API_Service_Manager_Name.azure-api.net/DMAP</a></li>
        <li><strong>VM IP Address:</strong> $VM_IP_Address</li>
    </ul>

    <p>Please save these details for future reference. You can begin using your DMAP application immediately.</p>

    <p>If you experience any issues or require technical assistance, please don't hesitate to contact our support team.</p>

    <p>Best regards,<br>
    DMAP Support Team<br>
    NewtGlobal Corp</p>

    <hr>
    <p style='font-size: 12px; color: #666666;'>
        This is an automated message. Please do not reply to this email.
    </p>
</div>
"@

# Set up the email and send it
try {
    # Initialize the mail message
    $message = New-Object System.Net.Mail.MailMessage
    $message.From = $from
    $message.To.Add($to)
    
    # Add CC recipients
    foreach ($ccRecipient in $cc) {
        $message.CC.Add($ccRecipient)
    }

    # Set email details
    $message.Subject = $subject
    $message.Body = $body
    $message.IsBodyHtml = $true

    # Configure SMTP client
    $smtpClient = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
    $smtpClient.EnableSsl = $true
    $smtpClient.Credentials = New-Object System.Net.NetworkCredential($username, $password)

    # Send the email
    $smtpClient.Send($message)
    Write-Output "Email sent successfully."
} catch {
    Write-Output "Failed to send email: $_"
}
