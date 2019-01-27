$PageTitle = "About"

$tabset = ""
$content = "<table id=table2>
	<tr><td colspan=2 style=`"background-color:#000`"><strong>General Settings</strong></td></tr>
	<tr><td style='width:200px'>Version</td><td>$SkToolsVersion</td></tr>
    <tr><td>CM Tools Enabled</td><td>$SkCMEnabled</td></tr>
    <tr><td>AD Tools Enabled</td><td>$SkADenabled</td></tr>
    <tr><td>ConfigMgr DB Host</td><td>$SkCmDBHost</td></tr>
    <tr><td>ConfigMgr Site</td><td>$SkCmSiteCode</td></tr>
	<tr><td>Current User</td><td>$PoshUserName</td></tr>
    <tr><td>Install Path</td><td>$HomeDirectory</td></tr>
    <tr><td>SMS Provider</td><td>$SkCmSMSProvider</td></tr>
    <tr><td>CM Collection Manage</td><td>$SkCmCollectionManage</td></tr>
    <tr><td>AD Group Manage</td><td>$SkADGroupManage</td></tr>
    <tr><td>CustomConfig</td><td>$CustomConfig</td></tr>
    <tr><td>Web Theme</td><td>$SkTheme</td></tr>
    <tr><td>App Path</td><td>$Global:SkWebPath</td></tr>
    <tr><td>Query Files</td><td>$Global:SkQueryPath</td></tr>
    <tr><td>Report Files</td><td>$Global:SkReportsPath</td></tr>
	<tr><td colspan=2 style=`"background-color:#000`"><strong>Built with PoSHServer by Yusuf Ozturk</strong></td></tr>
	<tr><td>GNU License</td><td><a href=`"license.txt`">License.txt</a></td></tr>
	<tr><td>ReadMe Text</td><td><a href=`"readme.txt`">ReadMe.txt</a></td></tr>
	<tr><td>Donate Information</td><td><a href=`"donate.txt`">Donate.txt</a></td></tr>
	<tr><td colspan=2 style=`"background-color:#000`"><strong>UI Settings</strong></td></tr>
	<tr><td>SkTabSelectAdUsers</td><td>$SkTabSelectAdUsers</td></tr>
	<tr><td>SkTabSelectAdGroups</td><td>$SkTabSelectAdGroups</td></tr>
	<tr><td>SkTabSelectAdComputers</td><td>$SkTabSelectAdComputers</td></tr>
	<tr><td>SkTabSelectCmFiles</td><td>$SkTabSelectCmFiles</td></tr>
	<tr><td>SkTabSelectCmUsers</td><td>$SkTabSelectCmUsers</td></tr>
	<tr><td>SkTabSelectCmDevices</td><td>$SkTabSelectCmDevices</td></tr>
	<tr><td>SkTabSelectCmDevColls</td><td>$SkTabSelectCmDevColls</td></tr>
	<tr><td>SkTabSelectCmUserColls</td><td>$SkTabSelectCmUserColls</td></tr>
	<tr><td>SkCmCollectionCheck</td><td>$SkCmCollectionCheck</td></tr>
	<tr><td>SkToolsPath</td><td>$SkToolsPath</td></tr>
</table>"

Write-SkWebContent
