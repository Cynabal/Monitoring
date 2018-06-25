Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;
ECHO Useraccounts
ECHO ------------
(Get-Recipient -RecipientTypeDetails usermailbox -ResultSize Unlimited).count
write-host "`n"
ECHO Shared-Postfächer
ECHO -----------------
(Get-Recipient -RecipientTypeDetails sharedmailbox -ResultSize Unlimited).count
write-host "`n"
ECHO Raumpostfächer
ECHO --------------
(Get-Recipient -RecipientTypeDetails roommailbox -ResultSize Unlimited).count
write-host "`n"
ECHO DB-Aufteilung
ECHO -------------
Get-Mailbox -resultsize unlimited | Group-Object -Property:Database | Select-Object Name,Count | Sort-Object Name | Format-Table -Auto
