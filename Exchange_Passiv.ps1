Passiv Kopie Script:
param (
[String]$CDS="HPM-CS-EXB04",
[String]$CDB="HPMEXCLDB01"
)
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010;
Add-PSSnapin Microsoft.Exchange.Management.Powershell.Support;
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Setup;
cd "C:\Program Files\Microsoft\Exchange Server\V15\bin"
$DBState = (Get-MailboxDatabaseCopyStatus -Server $CDS | ft Name,Status,ContentIndexState | findstr $CDB)
echo $DBState
if ($DBState -like "*Healthy*Healthy*") {Exit(1)} Else {Exit(0)}