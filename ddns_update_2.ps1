Function Get-DDWRTExternalIP {
    $Page = Invoke-WebRequest -UseBasicParsing -Uri "http://192.168.1.1/Status_Internet.live.asp" -Credential (Import-Clixml $ScriptPath"\DDWRTCreds.xml")
    
    $WANregex='(?<Address>{wan_ipaddr::(\b(([01]?\d?\d|2[0-4]\d|25[0-5])\.){3}([01]?\d?\d|2[0-4]\d|25[0-5])\b)})'
    $IPregex='(?<Address>(\b(([01]?\d?\d|2[0-4]\d|25[0-5])\.){3}([01]?\d?\d|2[0-4]\d|25[0-5])\b))'

    If ($Page.Content -match $WANregex) {$WANAddress = $Matches.Address}
    Else {Return $false}

    If ($WANAddress -match $IPregex) {Return $Matches.Address}
    Else {Return $false}
}

# Get the invocation path of the current file.
$ScriptPath = Split-Path $Script:MyInvocation.MyCommand.Path

# Set the expected IP Address. Obtain this from a DNS query or set it statically.
$EI = [System.Net.Dns]::GetHostAddresses("lewisroberts.com") | Select-Object -ExpandProperty IPAddressToString

# Obtain the IP Address of the Internet connection.
$IP = Get-DDWRTExternalIP

# If the IP isn't what you expected...
If ($IP -ne $EI) {

    # Login to Azure
    $Creds = Import-Clixml -Path $ScriptPath"\AzureRMCreds.xml"
    Login-AzureRmAccount -Credential $Creds
    
    # Update the apex record
    $RecordSet = New-AzureRmDnsRecordSet -Name "@" -RecordType A -ZoneName "lewisroberts.com" -ResourceGroupName "DNS" -Ttl 60 -Overwrite -Force
    Add-AzureRmDnsRecordConfig -RecordSet $RecordSet -Ipv4Address $IP
    Set-AzureRmDnsRecordSet -RecordSet $RecordSet

}
Else {
    Write-Output "Dynamic address ($IP) and DNS address ($EI) match."
}
