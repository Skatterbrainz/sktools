$DataGroup = Get-SkPageParam -TagName 'x' -Default ""

$tabset = ""
$PageTitle = "$($(Get-Date).ToLongDateString())"

$cmcomps  = Get-SkCmRowCount -TableName "v_R_System" -ColumnName "Name0"
$cmusers  = Get-SkCmRowCount -TableName "v_R_User" -ColumnName "User_Name0"
$cmdevcol = Get-SkCmRowCount -TableName "v_Collection" -ColumnName "Name" -Criteria "CollectionType = 2"
$cmusrcol = Get-SkCmRowCount -TableName "v_Collection" -ColumnName "Name" -Criteria "CollectionType = 1"

function Get-SkCmStatCounterTable {
    param (
        $QueryFile
    )
    $output = ""
	try {
		$result = @(Invoke-DbaQuery -SqlInstance $SkCmDbHost -Database "CM_$SkCmSiteCode" -File (Join-Path $PSScriptRoot -ChildPath "queries\$QueryFile") -ErrorAction SilentlyContinue)
		$sum = 0
		$result.Counters | %{ $sum += $_ }
		$output = "<table id=table2>"
		$result | select statname,counters | % {
			$countx = $_.Counters
			$pct = ([math]::Round($countx / $sum,2) * 100)
			$output += "<tr><td style=`"width:50%;background-color:$($_.statname)`">$pct`%</td><td>$($_.Counters)</td></tr>"
		}
		$output += "</table>"
	}
	catch {
		$output = "<table id=table2><tr><td>(Unavailable)</td></tr></table>"
	}
    Write-Output $output
}

$cm1 = Get-SkCmStatCounterTable -QueryFile "dashboard1.sql"
$cm2 = Get-SkCmStatCounterTable -QueryFile "dashboard2.sql"

switch ($DataGroup) {
	'ad' {
		$adusers  = Get-SkAdUsers
		$adgroups = Get-SkAdGroups
		$adcomps  = Get-SkAdComputers
		$wkst = @($adcomps | Where-Object {$_.OSType -eq 'Workstation'})
		$srv  = @($adcomps | Where-Object {$_.OSType -eq 'Server'})
		$dcs  = @($adcomps | Where-Object {$_.OSType -eq 'Domain Controller'})

		$content = "<table id=table2>
		<tr style=`"vertical-align:top`">
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='adusers.ps1'`">
				<h2 style='text-align:center'>AD Users: $adusers</h2>
				<p>View and manage User Accounts in the current AD domain.</p>
			</td>
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='adgroups.ps1'`">
				<h2 style='text-align:center'>AD Groups: $adgroups</h2>
				<p>View and manage Security Groups in the current AD domain.</p>
			</td>
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='adcomputers.ps1'`">
				<h2 style='text-align:center'>AD Computers: $($adcomps.Count)</h2>
				<p>View and manage Computers in the current AD domain.</p>
			</td>
		</tr>
		<tr style=`"vertical-align:top`">
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='adcomputers.ps1?f=OSType&v=Workstation&x=equals&tab=All'`">
				<h2 style='text-align:center'>AD Workstations: $($wkst.Count)</h2>
				<p>View and manage Workstation Computers in the current AD domain.</p>
			</td>
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='adcomputers.ps1?f=OSType&v=Server&x=equals&tab=All'`">
				<h2 style='text-align:center'>AD Servers: $($srv.Count)</h2>
				<p>View and manage Server Computers in the current AD domain.</p>
			</td>
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='adcomputers.ps1?f=OSType&v=Domain Controller&x=equals&tab=All'`">
				<h2 style='text-align:center'>AD Domain Controllers: $($dcs.Count)</h2>
				<p>View and manage Domain Controller Computers in the current AD domain.</p>
			</td>
		</tr>
		</table>"
		break;
	}
	'cm' {
		$content = "<table id=table2>
		<tr style=`"vertical-align:top`">
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='cmsitestatus.ps1'`">
				<h2 style='text-align:center'>CM Site Status</h2>
				$cm1
			</td>
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='cmcompstat.ps1'`">
				<h2 style='text-align:center'>CM Components</h2>
				$cm2
			</td>
		</tr>
		<tr style=`"vertical-align:top`">
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='cmcollections.ps1?t=2'`">
				<h2 style='text-align:center'>CM Device Collections: $cmdevcol</h2>
				<p>View and manage Device Collections in the Configuration Manager site.</p>
			</td>
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='cmcollections.ps1?t=1'`">
				<h2 style='text-align:center'>CM User Collections: $($cmusrcol.Count)</h2>
				<p>View and manage User Collections in the Configuration Manager site.</p>
			</td>
		</tr>
		<tr style=`"vertical-align:top`">
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='#'`">
				<h2 style='text-align:center'>Name: </h2>
				<p>Description.</p>
			</td>
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='#'`">
				<h2 style='text-align:center'>Name: </h2>
				<p>Description.</p>
			</td>
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='cmdevices.ps1'`">
				<h2 style='text-align:center'>ConfigMgr Devices: $cmcomps</h2>
				<p>View and manage Computer Devices in the Configuration Manager site.</p>
			</td>
			<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='cmusers.ps1'`">
				<h2 style='text-align:center'>ConfigMgr Users: $cmusers</h2>
				<p>View and manage User resources in the Configuration Manager site.</p>
			</td>
		</tr>
		</table>"
		break;
	}
}

Write-SkWebContent