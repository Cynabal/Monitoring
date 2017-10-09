Import-Module -Name SQLASCMDLETS
Import-Module -Name SQLPS 3>$null
$Status = (Test-SqlAvailabilityGroup -Path "SQLSERVER:\Sql\HPM-CS-SQL04\Default\AvailabilityGroups\DB01" | FL HealthState | Out-String).Trim()
Echo $Status
if ($Status -like '*HealthState : Healthy*') {Exit(1)} Else {Exit(0)} 