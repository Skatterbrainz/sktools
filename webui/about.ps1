$PageTitle = "About"

$tabset = ""
$content = "<table id=table2>
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
	<tr><td colspan=2>Built with PoSHServer by Yusuf Ozturk</td></tr>
	<tr><td>GNU License</td><td><a href=`"license.txt`">License.txt</a></td></tr>
	<tr><td>ReadMe Text</td><td><a href=`"readme.txt`">ReadMe.txt</a></td></tr>
	<tr><td>Donate Information</td><td><a href=`"donate.txt`">Donate.txt</a></td></tr>
</table>"

Show-SkPage
