$content = ""
$tabset  = ""
$menulist = ""

$content = @"
<form action="search.ps1" method="get">
    <button type="submit" class="statbutton" formtarget="main" title="Search">Search</button>
</form>
"@

if ($SkAdEnabled -ne 'false') {
    $content += @"
<button class="accordion" title="Active Directory">Active Directory</button>
<div class="panel">
	<ul class="ulmenu">
		<li class="limenu"><a href="addashboard.ps1" target="main" title="Dashboard">Dashboard</a></li>
		<li class="limenu"><a href="adusers.ps1?f=username&tab=$SkTabSelectAdUsers" target="main" title="AD Users">Users</a></li>
		<li class="limenu"><a href="adgroups.ps1?f=name&tab=$SkTabSelectAdGroups" target="main" title="AD Groups">Groups</a></li>
		<li class="limenu"><a href="adcomputers.ps1?f=name&tab=$SkTabSelectAdComputers" target="main" title="AD Computers">Computers - All</a></li>
		<li class="limenu"><a href="adcomputers.ps1?f=OSType&v=Server&x=equals&tab=$SkTabSelectAdComputers" target="main" title="AD Servers">Computers - Servers</a></li>
		<li class="limenu"><a href="adcomputers.ps1?f=OSType&v=Domain Controller&x=equals&tab=$SkTabSelectAdComputers" target="main" title="AD Domain Controllers">Computers - DCs</a></li>
		<li class="limenu"><a href="adcomputers.ps1?f=OSType&v=Workstation&x=equals&tab=$SkTabSelectAdComputers" target="main" title="AD Workstations">Computers - Wkstns</a></li>
		<li class="limenu"><a href="addcs.ps1" target="main" title="Domain Controllers Summary">Domain Controllers</a></li>
		<li class="limenu"><a href="adforest.ps1" target="main" title="AD Forest">Forest</a></li>
        <li class="limenu"><a href="addomain.ps1" target="main" title="AD Domain">Domain</a></li>
		<li class="limenu"><a href="adsites.ps1" target="main" title="AD Sites">Sites</a></li>
		<li class="limenu"><a href="adsitelinks.ps1" target="main" title="AD Site Links">Site Links</a></li>
		<li class="limenu"><a href="adbrowser.ps1" target="main" title="AD OU Explorer">OU Explorer</a></li>
	</ul>
</div>
"@
}

if ($SkCmEnabled -ne 'false') {
    $content += @"
<button class="accordion" title="Configuration Manager Assets">CM Assets</button>
<div class="panel">
	<ul class="ulmenu">
		<li class="limenu"><a href="cmusers.ps1?tab=$SkTabSelectCmUsers" title="Users" target="main">Users</a></li>
		<li class="limenu"><a href="cmdevices.ps1?tab=$SkTabSelectCmDevices" title="Devices" target="main">Devices - All</a></li>
		<li class="limenu"><a href="cmdevices.ps1?f=OSType&v=Server&x=equals" title="Servers" target="main">Devices - Servers</a></li>
		<li class="limenu"><a href="cmdevices.ps1?f=OSType&v=Workstation&x=equals" title="Workstations" target="main">Devices - Wkstns</a></li>
		<li class="limenu"><a href="cmcollections.ps1?t=1" title="User Collections" target="main">User Collections</a></li>
		<li class="limenu"><a href="cmcollections.ps1?t=2" title="Device Collections" target="main">Device Collections</a></li>
	</ul>
</div>

<button class="accordion" title="Configuration Manager Software">CM Software</button>
<div class="panel">
	<ul class="ulmenu">
		<li class="limenu"><a href="cmpackages.ps1" target="main" title="Software Deployments">Software - All</a></li>
		<li class="limenu"><a href="cmpackages.ps1?f=packagetype&v=8&x=equals" target="main" title="Software Applications">Applications</a></li>
		<li class="limenu"><a href="cmpackages.ps1?f=packagetype&v=0&x=equals" target="main" title="Software Packages">Packages</a></li>
		<li class="limenu"><a href="cmpackages.ps1?f=packagetype&v=257&x=equals" target="main" title="Operating System Images">OS Images</a></li>
		<li class="limenu"><a href="cmpackages.ps1?f=packagetype&v=259&x=equals" target="main" title="Operating System Upgrade Packages">OS Upgrades</a></li>
		<li class="limenu"><a href="cmpackages.ps1?f=packagetype&v=258&x=equals" target="main" title="Boot Images">Boot Images</a></li>
		<li class="limenu"><a href="cmpackages.ps1?f=packagetype&v=5&x=equals" target="main" title="Software Updates">Software Updates</a></li>
		<li class="limenu"><a href="cmpackages.ps1?f=packagetype&v=4&x=equals" target="main" title="Task Sequences">Task Sequences</a></li>
		<li class="limenu"><a href="cmscripts.ps1" target="main" title="Scripts">Scripts</a></li>
	</ul>
</div>

<button class="accordion" title="Configuration Manager Inventory">CM Inventory</button>
<div class="panel">
	<ul class="ulmenu">
        <li class="limenu"><a href="cmproducts.ps1" target="main" title="Software Products Inventory">Software Inventory</a></li>
        <li class="limenu"><a href="cmfiles.ps1" target="main" title="Software Files">Software Files</a></li>
		<li class="limenu"><a href="cmhwclasses.ps1" target="main" title="Hardware Inventory Classes">HW Classes</a></li>
        <li class="limenu"><a href="skreports.ps1" target="main" title="Custom Reports">Custom Reports</a></li>
	</ul>
</div>

<button class="accordion" title="Configuration Manager Monitoring">CM Monitoring</button>
<div class="panel">
	<ul class="ulmenu">
		<li class="limenu"><a href="cmdashboard.ps1" target="main" title="Site Dashboard">Dashboard</a></li>
		<li class="limenu"><a href="cmcovstatus.ps1" target="main" title="Coverage Status">Coverage Status</a></li>
		<li class="limenu"><a href="cmsitestatus.ps1" target="main" title="Site Status">Site Status</a></li>
		<li class="limenu"><a href="cmcompstat.ps1" target="main" title="Component Status">Site Components</a></li>
		<li class="limenu"><a href="cmqueries.ps1" target="main" title="Queries">Queries</a></li>
        <li class="limenu"><a href="http://$SkCmSmsProvider/reports/browse/ConfigMgr_$SkCmSiteCode" target="_new" title="Reports">Reports</a></li>
		<li class="limenu"><a href="cmdepsummary.ps1" target="main" title="Deployments">Deployments</a></li>
		<li class="limenu"><a href="dbstats.ps1" target="main" title="ConfigMgr SQL Status">SQL Status</a></li>
        <li class="limenu"><a href="dbrecovery.ps1" target="main" title="SQL Server Recovery Models">DB Recovery</a></li>
	</ul>
</div>

<button class="accordion" title="Configuration Manager Site">CM Site</button>
<div class="panel">
	<ul class="ulmenu">
		<li class="limenu"><a href="cmdiscs.ps1" target="main" title="Discovery Methods">Discovery Methods</a></li>
        <li class="limenu"><a href="cmforestdisc.ps1" target="main" title="AD Forest Discovery and Publishing">AD Forest</a></li>
		<li class="limenu"><a href="cmbgroups.ps1" target="main" title="Boundary Groups">Boundary Groups</a></li>
		<li class="limenu"><a href="cmservers.ps1?rc=dp" target="main" title="Distribution Points">Distribution Points</a></li>
        <li class="limenu"><a href="cmsumtasks.ps1" target="main" title="Summary Tasks">Summary Tasks</a></li>
        <li class="limenu"><a href="cmcerts.ps1" target="main" title="Certificates">Certificates</a></li>
		<li class="limenu"><a href="cmtasks.ps1" target="main" title="Maintenance Tasks">Maintenance Tasks</a></li>
		<li class="limenu"><a href="cmroles.ps1" target="main" title="Security Roles">Roles</a></li>
		<li class="limenu"><a href="cmadmins.ps1" target="main" title="Security Admins">Admins</a></li>
	</ul>
</div>

"@
}

$content += @"
<button class="accordion" title="Resources">Resources</button>
<div class="panel">
	<ul class="ulmenu">
		<li class="limenu"><a href="https://docs.microsoft.com/en-us/sccm/" target="_new" title="ConfigMgr Docs">ConfigMgr Docs</a></li>
		<li class="limenu"><a href="https://dbatools.io" target="_new" title="dbatools project">DBATools</a></li>
		<li class="limenu"><a href="downloads.ps1" target="main" title="Downloads">Downloads</a></li>
		<li class="limenu"><a href="learning.ps1" target="main" title="Learning">Learning</a></li>
        <li class="limenu"><a href="acknowledgements.ps1" target="main" title="Acknowledgements">Acknowledgements</a></li>
	</ul>
</div>

<button class="accordion" title="Support">Support</button>
<div class="panel">
	<ul class="ulmenu">
        <li class="limenu"><a href="settings.ps1" target="main" title="Settings">Settings</a></li>
		<li class="limenu"><a href="help.ps1" target="main" title="SkatterTools Help">SkatterTools Help</a></li>
		<li class="limenu"><a href="https://github.com/Skatterbrainz/sktools" target="_new" title="GitHub Repo">Project Site</a></li>
		<li class="limenu"><a href="https://www.powershellgallery.com/packages/sktools" target="_new" title="PS Gallery">PowerShell Gallery</a></li>
		<li class="limenu"><a href="about.ps1" target="main" title="About">About</a></li>
    </ul>
</div>
"@

@"
<!DOCTYPE html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="$SkTheme" />
	<script src="accordion.js"></script>
</head>
<body style="margin: 0;">

$content

<script>
SetMenu();
</script>

</body>
</html>
"@