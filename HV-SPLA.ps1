ECHO ----------------
ECHO CLOUD
ECHO ----------------
$hosts = "HPM-CS-HV01", "HPM-CS-HV02", "HPM-CS-HV03"
ForEach($item in $hosts)
{get-vm -ComputerName $item | where {$_.state -eq 'running'} | sort Uptime | select Name,Uptime,@{N="MemoryMB";E={$_.MemoryAssigned/1MB}},Status | findstr HPM-CS-}
ECHO ----------------
ECHO HH-Cremon
ECHO ----------------
$hosts = "HPM-CS-009HV01"
ForEach($item in $hosts)
{get-vm -ComputerName $item | where {$_.state -eq 'running'} | sort Uptime | select Name,Uptime,@{N="MemoryMB";E={$_.MemoryAssigned/1MB}},Status | findstr HPM-CS-}
ECHO ----------------
ECHO Nartenstrasse
ECHO ----------------
$hosts = "HPM-CS-076HV01", "HPM-CS-HV02", "HPM-CS-HV03"
ForEach($item in $hosts)
{get-vm -ComputerName $item | where {$_.state -eq 'running'} | sort Uptime | select Name,Uptime,@{N="MemoryMB";E={$_.MemoryAssigned/1MB}},Status | findstr HPM-CS-}
ECHO ----------------
ECHO MOBA
ECHO ----------------
$hosts = "HPM-CS-154HV01", "HPM-CS-154HV02"
ForEach($item in $hosts)
{get-vm -ComputerName $item | where {$_.state -eq 'running'} | sort Uptime | select Name,Uptime,@{N="MemoryMB";E={$_.MemoryAssigned/1MB}},Status | findstr HPM-CS-}
ECHO ----------------
ECHO Feroment
ECHO ----------------
$hosts = "HPM-CS-186HV01", "HPM-CS-186HV02"
ForEach($item in $hosts)
{get-vm -ComputerName $item | where {$_.state -eq 'running'} | sort Uptime | select Name,Uptime,@{N="MemoryMB";E={$_.MemoryAssigned/1MB}},Status | findstr HPM-CS-}
