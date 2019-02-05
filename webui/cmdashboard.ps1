$PageTitle = "ConfigMgr System Summary"
$menulist  = ""
$tabset    = ""
$pagelink  = Split-Path -Leaf $MyInvocation.MyCommand.Definition

$content = "<h2>Site Summary</h2>
<table id=table2>
<tr><th>SiteCode</th><th>SiteName</th><th>Version</th><th>SMS Provider</th><th>InstallPath</th></tr>"
try {
	$query  = "SELECT SiteCode, SiteName, Version, ServerName, InstallDir FROM v_Site"
	$cmsite = @(Invoke-DbaQuery -SqlInstance $SkCmDbHost -Database "CM_$SkCmSiteCode" -Query $query -ErrorAction SilentlyContinue)
	$content += "<tr>"
	$content += "<td style=`"text-align:center`">$($cmsite[0].SiteCode)</td>"
	$content += "<td style=`"text-align:center`">$($cmsite[0].SiteName)</td>"
	$content += "<td style=`"text-align:center`">$($cmsite[0].Version)</td>"
	$content += "<td style=`"text-align:center`">$SkCmSmsProvider</td>"
	$content += "<td style=`"text-align:center`">$($cmsite[0].InstallDir)</td>"
	$content += "</tr>"
}
catch {
	$content += "<tr><td colspan=`"5`">Information is not accessible at this time</td></tr>"
}
$content += "</table>"

$content += "<h2>System Summary</h2>
<table id=table2>
<tr><th>Model</th><th>OSName</th><th>OSBuild</th><th>TotalMemory</th><th>Processors</th></tr>"
try {
	$cs = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $SkCmSmsProvider -ErrorAction SilentlyContinue
	$os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $SkCmSmsProvider -ErrorAction SilentlyContinue
	$tm = [math]::Round((($cs | select -ExpandProperty TotalPhysicalMemory) / 1GB),2)
	$dsa = Get-DbaComputerSystem -ComputerName $SkCmDbHost
	$logprocs = $dsa.NumberLogicalProcessors
	$content += "<tr>"
	$content += "<td>$($cs.Model)</td>"
	$content += "<td>$($os.Caption)</td>"
	$content += "<td style=`"text-align:center`">$($os.BuildNumber)</td>"
	$content += "<td style=`"text-align:center`">$tm GB</td>"
	$content += "<td style=`"text-align:center`">$logprocs</td>"
	$content += "</tr>"
}
catch {
	$content += "<tr><td colspan=`"5`">Information is not accessible at this time</td></tr>"
}
$content += "</table>"

$content += "<h2>Services Health</h2>
<table id=table1>
<tr><th>DisplayName</th><th>Name</th><th>StartMode</th><th>State</th><th>StartName</th></tr>"
try {
	$counter = 0
	$cmsvc = @(Get-WmiObject -Class Win32_Service -ComputerName $SkCmSmsProvider -ErrorAction SilentlyContinue | 
		Where-Object {($_.State -eq 'Stopped') -and ($_.StartMode -eq 'Auto')} | Sort-Object DisplayName)
	$cmsvc | Foreach-Object {
		$content += "<tr>"
		$content += "<td>$($_.DisplayName)</td>"
		$content += "<td>$($_.Name)</td>"
		$content += "<td style=`"text-align:center`">$($_.StartMode)</td>"
		$content += "<td style=`"text-align:center`">$($_.State)</td>"
		$content += "<td>$($_.StartName)</td>"
		$content += "</tr>"
		$counter++
	}
	if ($counter -gt 0) {
		$content += "<tr><td colspan=`"5`" class=`"lastrow`">$counter services are stopped</td></tr>"
	}
	else {
		$content += "<tr><td colspan=`"5`" class=`"lastrow`">No services are currently stopped</td></tr>"
	}
}
catch {
	$content += "<tr><td colspan=`"5`">Services are not accessible at this time</td></tr>"
}
$content += "</table>"

$content += "<h2>Disk Health</h2>
<table id=table1>
<tr><th>DeviceID</th><th>Label</th><th>Type</th><th>FileSystem</th><th>Size</th><th>Free</th><th>Used</th></tr>"
try {
	$counter = 0
	$ld = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $SkCmSmsProvider -ErrorAction SilentlyContinue
	foreach ($d in $ld) {
		$dsize = $d.Size
		$dfree = $d.FreeSpace
		if ($dsize -gt 0) {
			$dused = $dsize - $dfree
			$pct = [math]::Round(($dused / $dsize) * 100,2)
			if ($pct -gt 95) {
				$pctable = "<table id=table3><tr><td style=`"background-color:red`">$pct`%</td></tr></table>"
			}
			elseif ($pct -gt 75) {
				$pctable = "<table id=tablex style=`"width:$pct%`"><tr><td style=`"background-color:yellow`">$pct`%</td></tr></table>"
			}
			elseif ($pct -gt 50) {
				$pctable = "<table id=tablex style=`"width:$pct%`"><tr><td style=`"background-color:orange`">$pct`%</td></tr></table>"
			}
			else {
				$pctable = "<table id=table3><tr><td style=`"width:$pct%;background-color:lightgreen`">&nbsp;</td><td style=`"background-color:none`"> $pct`%</td></tr></table>"
			}
		}
		else {
			$dused = 0
			$pct   = 0
			$dsize = 0
			$dfree = 0
			$pctable = "<table id=table3><tr><td style=`"background-color:none`">&nbsp;</td></tr></table>"
		}
		$content += "<tr>"
		$content += "<td>$($d.DeviceID)</td>"
		$content += "<td>$($d.VolumeName)</td>"
		$content += "<td style=`"text-align:center`">$($d.DriveType)</td>"
		$content += "<td style=`"text-align:center`">$($d.FileSystem)</td>"
		$content += "<td style=`"text-align:right`">$([math]::Round(($dsize / 1GB),2)) GB</td>"
		$content += "<td style=`"text-align:right`">$([math]::Round(($dfree / 1GB),2)) GB</td>"
		$content += "<td style=`"width:200px`">$pctable</td>"
		$content += "</tr>"
		$counter++
	}
}
catch {
	$content += "<tr><td colspan=`"7`">Information is not accessible at this time</td></tr>"
}
$content += "</table>"

$content += "<h2>SQL Server Health</h2>
<table id=table2>
<tr><th>Install Date</th><th>Version</th><th>Update</th><th>MemoryAlloc</th><th>DBFilePaths</th></tr>"
try {
	$sqlinst  = ((Get-DbaServerInstallDate -SqlInstance $SkCmDbHost -ErrorAction SilentlyContinue).SqlInstallDate).Date
	$sqlmem   = Get-DbaMaxMemory -SqlInstance $SkCmDbHost -ErrorAction SilentlyContinue
	$totalmem = $sqlmem.Total
	$allocmem = [math]::Round(($sqlmem.MaxValue / 1GB),2)
	$allocpct = $([math]::Round(($allocmem / $tm),2)) * 100
	$content += "<tr>"
	$content += "<td>$sqlinst</td>"
	$content += "<td></td>"
	$content += "<td></td>"
	$content += "<td>$allocmem ($allocpct `%)</td>"
	$content += "<td></td>"
	$content += "</tr>"
}
catch {
	$content += "<tr><td colspan=`"5`">Information is not accessible at this time</td></tr>"
}
$content += "</table>"

try {
	$cmdevs  = Get-SkCmRowCount -TableName "v_R_System" -ColumnName "Name0"
	$cmusrs  = Get-SkCmRowCount -TableName "v_R_User" -ColumnName "User_Name0"
	$cmgrps  = Get-SkCmRowCount -TableName "v_R_UserGroup" -Column "Name0"
	$cmbgs   = Get-SkCmRowCount -TableName "vSMS_BoundaryGroup" -ColumnName "Name"
	$cmdps   = Get-SkCmRowCount -TableName "v_DistributionPoint" -ColumnName "ServerNALPath"
	$cmapps  = 0
	$cmdcols = 0
	$cmucols = 0
	$cmerr1  = Get-SkCmRowCount -TableName "v_SiteSystemSummarizer" -ColumnName "Status" -Criteria "(Status = 2)"
	$cmclients = Get-SkCmRowCount -TableName "v_R_System" -ColumnName "Name0" -Criteria "Client0 = 1"
	$cmmiss  = Get-SkCmRowCount -TableName "v_R_System" -ColumnName "Name0" -Criteria "Client0 <> 1"
	$cmclver = Get-SkCmRowCount -TableName "v_R_System" -ColumnName "Client_Version0"
	$content += "<table style=`"border:none;width:100%`">
	<tr>
	<td style=`"width:50%;vertical-align:top`">
		<h3>Site Resources</h3>
		<table id=table2>
			<tr><td>Discovered Devices</td><td style=`"text-align:right`">$cmdevs</td></tr>
			<tr><td>Discovered Users</td><td style=`"text-align:right`">$cmusrs</td></tr>
			<tr><td>Discovered Groups</td><td style=`"text-align:right`">$cmgrps</td></tr>
			<tr><td>Boundary Groups</td><td style=`"text-align:right`">$cmbgs</td></tr>
			<tr><td>Distribution Points</td><td style=`"text-align:right`">$cmdps</td></tr>
		</table>
	</td>
	<td style=`"width:50%;vertical-align:top`">
		<h3>Site Status</h3>
		<table id=table2>
			<tr><td>Site Status Errors</td><td style=`"text-align:right`">$cmerr1</td></tr>
			<tr><td>Installed Clients</td><td style=`"text-align:right`">$cmclients</td></tr>
			<tr><td>Client Versions</td><td style=`"text-align:right`">$cmclver</td></tr>
			<tr><td>Missing Clients</td><td style=`"text-align:right`">$cmmiss</td></tr>
			<tr><td></td><td></td></tr>
		</table>
		</td>
	</tr></table>"
}
catch {
	$content += "<table id=table2><tr><td colspan=`"5`">Information is not accessible at this time</td></tr></table>"
}

try {
	$dbcs = Get-DbaDatabase -SqlInstance $SkCmDbHost -Database "CM_$SkCmSiteCode" -ErrorAction SilentlyContinue
	$content += "<h3>SQL Database Information</h3>
	<table id=table2>
	<tr><td>Database</td><td>CM_$SkCmSiteCode</td></tr>
	<tr><td>Instance Name</td><td>$($dbcs.InstanceName)</td></tr>
	<tr><td>Status</td><td>$($dbcs.Status)</td></tr>
	<tr><td>RecoveryModel</td><td>$($dbcs.RecoveryModel)</td></tr>
	<tr><td>Size (MB)</td><td>$($dbcs.SizeMB)</td></tr>
	<tr><td>Compatibility</td><td>$($dbcs.Compatibility)</td></tr>
	<tr><td>Collation</td><td>$($dbcs.Collation)</td></tr>
	<tr><td>Last Full Backup</td><td>$($dbcs.LastFullBackup)</td></tr>
	<tr><td>Last Log Backup</td><td>$($dbcs.LastLogBackup)</td></tr>
	</table>"
}
catch {
	$content += "<table id=table2><tr><td>Information is not accessible at this time</td></tr></table>"
}

try {
	$dbf = Get-DbaDbFile -SqlInstance $SkCmDbHost -Database "CM_$SkCmSiteCode" -ErrorAction SilentlyContinue
	$content += "<h3>SQL Database Files (CM_$SkCmSiteCode)</h3>"
	$counter = 1
	foreach ($df in $dbf) {
		$content += "<h4>Database File $counter</h4>"
		$content += "<table id=table2>"
		$df.psobject.Properties | %{
			$content += "<tr><td class=t2td1>$($_.Name)</td><td class=t2td2>$($_.Value)</td></tr>"
		}
		$content += "</table>"
		$counter++
	}
}
catch {
}

Write-SkWebContent