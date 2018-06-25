# Filename of the export
$filename = “RDS-CAL-Report_$(get-date -f yyyy-MM-dd).csv”
# Import RDS PowerShell Module
import-module remotedesktopservices

# Open RDS Location
Set-Location -path rds:

# Remove previous reports (Optional)
remove-item RDS:\LicenseServer\IssuedLicenses\PerUserLicenseReports\* -Recurse

# Create new RDS report
Invoke-WmiMethod -Class Win32_TSLicenseReport -Name GenerateReportEx

# Name is automatically generated
$NewReportName = Get-ChildItem RDS:\LicenseServer\IssuedLicenses\PerUserLicenseReports -name

# Get issued licenses
$IssuedLicenseCount = get-item RDS:\LicenseServer\IssuedLicenses\PerUserLicenseReports\$NewReportName\Win8\IssuedCount
# Count issued licenses
$IssuedLicenseCountValue = $IssuedLicenseCount.CurrentValue

# Get installed licenses
$InstalledLicenseCount = get-item RDS:\LicenseServer\IssuedLicenses\PerUserLicenseReports\$NewReportName\Win8\InstalledCount
# Count installed licenses
$InstalledLicenseCountValue = $InstalledLicenseCount.CurrentValue

# Installed – Issued
$Available = $InstalledLicenseCount.CurrentValue – $IssuedLicenseCount.CurrentValue
# Show percentage available
$AvailablePercent = ($Available /$InstalledLicenseCount.CurrentValue)*100
$AvailablePercent = “{0:N0}” -f $AvailablePercent

# Display info

Write-host “Installed: $InstalledLicenseCountValue”
Write-host “Issued: $IssuedLicenseCountValue”
Write-host “Available: $Available [ $AvailablePercent % ]”

# Add the information into an Array

[System.Collections.ArrayList]$collection = New-Object System.Collections.ArrayList($null)
$obj = @{
Installed = $InstalledLicenseCountValue
Available = $Available
AvailablePercent = $AvailablePercent
Issued = $IssuedLicenseCountValue
Date = get-date
}

# Exit RDS location
set-location C:\Skripts

# Create PSO Object with the data
$collection.Add((New-Object PSObject -Property $obj));

# Export Data into a file
$collection | export-csv $filename -NoTypeInformation -Encoding UTF8

#send mail

#Modify to your SMTP server
$smtpServer = “1.2.3.4”

#Modify to your path where report generated
$file = “C:\Skripts\RDS-CAL-Report_$(get-date -f yyyy-MM-dd).csv”
$att = new-object Net.Mail.Attachment($file)
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$msg.From = “HOSTNAME”

#Modify recipients

$msg.To.Add(“user@email.com”)
#$msg.To.Add(“user2@ms.com”)
#$msg.CC.Add(“user3@ms.com”)
$msg.Subject = “HPM-CS-CB01 User CAL Reporting”
$msg.Body = “Monthly license reporting, refer your question to me”
$msg.Attachments.Add($att)
$smtp.Send($msg)
$att.Dispose()
