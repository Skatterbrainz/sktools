$tabset = ""
$PageTitle = "SkatterTools: $($(Get-Date).ToLongDateString())"
$adusers  = $(Get-SkAdUsers).Count
$adgroups = $(Get-SkAdGroups).Count
$adcomps  = $(Get-SkAdComputers).Count
$cmcomps  = Get-SkCmRowCount -TableName "v_R_System" -ColumnName "Name0"
$cmusers  = Get-SkCmRowCount -TableName "v_R_User" -ColumnName "User_Name0"
$cmdevcol = Get-SkCmRowCount -TableName "v_Collection" -ColumnName "Name" -Criteria "CollectionType = 2"
$cmusrcol = Get-SkCmRowCount -TableName "v_Collection" -ColumnName "Name" -Criteria "CollectionType = 1"

$content = "<table id=table2>
<tr>
	<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='adusers.ps1'`">
		<h2 style='text-align:center'>AD Users: $adusers</h2>
		<p>View and manage User Accounts in the current AD domain.</p>
	</td>
	<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='adgroups.ps1'`">
		<h2 style='text-align:center'>AD Groups: $adgroups</h2>
		<p>View and manage Security Groups in the current AD domain.</p>
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
<tr>
	<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='adcomputers.ps1'`">
		<h2 style='text-align:center'>AD Computers: $adcomps</h2>
		<p>View and manage Computers in the current AD domain.</p>
	</td>
	<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='adreps.ps1'`">
		<h2 style='text-align:center'>AD Reports</h2>
		<p>View reports on various aspects of the current AD forest and domain.</p>
	</td>
	<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='cmcollections.ps1?t=2'`">
		<h2 style='text-align:center'>CM Device Collections: $cmdevcol</h2>
		<p>View and manage Device Collections in the Configuration Manager site.</p>
	</td>
	<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='cmcollections.ps1?t=1'`">
		<h2 style='text-align:center'>CM User Collections: $($cmusrcol.Count)</h2>
		<p>View and manage User Collections in the Configuration Manager site.</p>
	</td>
</tr>
<tr>
	<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='#'`">
		<h2 style='text-align:center'>Name: </h2>
		<p>Description.</p>
	</td>
	<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='#'`">
		<h2 style='text-align:center'>Name: </h2>
		<p>Description.</p>
	</td>
	<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='#'`">
		<h2 style='text-align:center'>Name: </h2>
		<p>Description.</p>
	</td>
	<td class=`"dyn1a`" onMouseOver=`"this.className='dyn2a'`" onMouseOut=`"this.className='dyn1a'`" onClick=`"document.location.href='#'`">
		<h2 style='text-align:center'>Name: </h2>
		<p>Description.</p>
	</td>
</tr>
</table>"

Write-SkWebContent