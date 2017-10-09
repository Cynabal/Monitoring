$dataset = New-Object System.Data.DataSet
$serverlist='HPM-CS-SQL04'
foreach($Server in $serverlist) {
$connectionString = "Provider=sqloledb;Data Source=$Server;Initial Catalog=Master;Integrated Security=SSPI;"
$sqlcommand="
IF SERVERPROPERTY ('IsHadrEnabled') = 1
BEGIN
SELECT
AGC.name
, RCS.replica_server_name
, ARS.role_desc
, AGL.dns_name
FROM
sys.availability_groups_cluster AS AGC
INNER JOIN sys.dm_hadr_availability_replica_cluster_states AS RCS
ON
RCS.group_id = AGC.group_id
INNER JOIN sys.dm_hadr_availability_replica_states AS ARS
ON
ARS.replica_id = RCS.replica_id
INNER JOIN sys.availability_group_listeners AS AGL
ON
AGL.group_id = ARS.group_id
WHERE
ARS.role_desc = 'PRIMARY'
END
"
$connection = New-Object System.Data.OleDb.OleDbConnection $connectionString
$command = New-Object System.Data.OleDb.OleDbCommand $sqlCommand,$connection
$connection.Open()
$adapter = New-Object System.Data.OleDb.OleDbDataAdapter $command
[void] $adapter.Fill($dataSet)
$connection.Close()
}
$PrimaryNode = ($dataSet.Tables | FT -AutoSize)
$PNode = (echo $PrimaryNode | findstr HPM-CS-SQL0 | findstr -B DB01)
echo $PNode
if ($PNode -like '*DB01*HPM-CS-SQL04*PRIMARY*HPM-CS-DB01*') {Exit(1)} Else {Exit(0)}