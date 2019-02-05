Get-SkParams | Out-Null

$PageTitle   = "Help"
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition

$content += "<table id=table2><tr><td style=`"height:150px;text-align:center`">"
$content += "Be patient. I'm still working on it. :)</td></tr></table>"


$content = @"
<table id=table2>
    <tr>
        <td>
            <h2>You Sure do Need Help!</h2>

            <p>If you clicked on a link to this page, you're in trouble.  But don't worry, this page
            should keep you sufficiently confused and annoyed.</p>
            
            <p>So, what the ____ exactly is this $Global:AppName crap anyway?</p>

            <p>It began with a stupid idea and turned into a dumb project.  Okay, that's not entirely true.
            But... It actually began from the pieces left from a dozen past web app projects involving ASP, 
            PHP, Active Directory, SQL Server, Configuration Manager and so on.  
            The issue has always been "but i don't want to stand up another server to manage
            another web app".  So I found PoSH Server, a micro-web server that runs PowerShell for the 
            content engine.</p>

            <p>That's right! Everything in this site is built from the following:
            <ul>
                <li>PowerShell</li>
                <li>HTML, CSS and some crappy graphics</li>
                <li>Coffee.  Lots and lots of coffee</li>
                <li>More PowerShell.  You can never have enough PowerShell</li>
            </ul>
            That's it.</p>

            <p>Version: $Global:SkToolsVersion</p>
        </td>
    </tr>
    <tr>
        <td>
            <h2>Setup and Configuration</h2>

            <p>Note that this is only going to describe how this works as of now.  This may change in a future
            release, so keep that in mind.</p>

            <p>Once you've downloaded this garbage and extracted it into a folder somewhere, you should 
            find a file in that folder named "skconfig.txt".  Open that in your favorite text editor. 
            Modify the settings to suit your needs.  After saving the changes, restart the PoSH Server instance.</p>

            <h2>Options and Variables</h2>
			
			<table id=table2>
				<tr><th>Key Name</th><th>Description</th></tr>
				<tr><td>_ (underscore prefix) items</td><td>These are comments which are ignored during processing</td></tr>
				<tr><td>SkAPPNAME</td><td>This is the name on the app banner (e.g. SkatterTools)</td></tr>
				<tr><td>SkTheme</td><td>The CSS style theme setting.  Only 2 are provided right now: stdark.css, stlight.css</td></tr>
				<tr><td>SkADEnabled</td><td>Enable AD features (default = TRUE)</td></tr>
				<tr><td>SkADGroupManage</td><td>Enable AD Group membership changes (default = TRUE)</td></tr>
				<tr><td>SkCMEnabled</td><td>Enable ConfigMgr features (default = TRUE)</td></tr>
				<tr><td>SkCmDBHost</td><td>The ConfigMgr SQL Server hostname (FQDN)</td></tr>
				<tr><td>SkCmSMSProvider</td><td>The ConfigMgr site SMS Provider hostname (FQDN)</td></tr>
				<tr><td>SkCmSiteCode</td><td>The ConfigMgr Site Code</td></tr>
				<tr><td>SkCmCollectionManage</td><td>Enable ConfigMgr device and user collection membership changes (default = TRUE)</td></tr>
				<tr><td>SkDebug</td><td>Enable SkatterTools debug features within console pages (default = FALSE)</td></tr>
				<tr><td>SkTabSelectAdUsers</td><td>Default tab selection for AD Users page (default = A)</td></tr>
				<tr><td>SkTabSelectAdGroups</td><td>Default tab selection for AD Groups (default = A)</td></tr>
				<tr><td>SkTabSelectAdComputers</td><td>Default tab selection for AD Computers (default = A)</td></tr>
				<tr><td>SkTabSelectCmFiles</td><td>Default tab selection for ConfigMgr Files (default = A)</td></tr>
				<tr><td>SkTabSelectCmUsers</td><td>Default tab selection for ConfigMgr Users (default = A)</td></tr>
				<tr><td>SkTabSelectCmDevices</td><td>Default tab selection for ConfigMgr Devices (default = A)</td></tr>
				<tr><td>SkTabSelectCmDevColls</td><td>Default tab selection for ConfigMgr Device Collections (default = A)</td></tr>
				<tr><td>SkTabSelectCmUserColls</td><td>Default tab selection for ConfigMgr User Collections (default = A)</td></tr>
				<tr><td>SkCmCollectionCheck</td><td>Restrict ConfigMgr collection changes to direct-rule collections (default = TRUE)</td></tr>
				<tr><td>SkToolsPath</td><td>Reserved for future use</td></tr>
			</table>

            <p>NOTE: Always keep a copy of your skconfig.txt file somewhere, in case you download a new
            update and it whacks your existing copy.  <a href="https://www.merriam-webster.com/dictionary/whack">Whacks</a> 
            is a real word. I looked it up. Don't confuse "wax" with "whacks".  You can "wax on" and "wax off", but if you 
            get caught doing a "whacks off" you might end up in jail.</p>

            <p>If you modify skconfig.txt, you will need to stop and start the PoSH Server process again.</p>

            <h2>System Requirements</h2>
			
			<p>The sktools module requires PowerShell 5.1, and a domain-joined computer host running Windows 7, 8.1 or 10.</p>
			
			<p>Sktools has been tested with Windows Server 2016, Windows 10 Enterprise 1803, Windows 10 Professional 1803, and browsers 
			such as Firefox, Google Chrome, Internet Explorer, Edge, and Brave.</p>
        </td>
    </tr>
	<tr>
		<td>
			<h2>Active Directory</h2>
			
			<p>Active Directory features include browsing, and searching User accounts, Security Groups, Computer Accounts, 
			AD Sites and Site Links, Domain Controllers and FSMO roles, Domain policies, Forest properties and more.</p>
			
			<p>In addition to browse and search, you can add or remove User accounts in Security Groups, inspect local machine
			properties of remote AD Computers, and perform remote tasks against remote Computers such as GPUPDATE, Restart and more.</p>
			
			<p>The AD features in SkatterTools have been tested with environments on Windows Server 2008, 2008 R2, 2012, 2012 R2 and 2016.
			The SkatterTools (sktools) module itself requires a supported runtime host (see Requirements above).</p>

			<p>Note: If SkADEnabled is set to FALSE, the Active Directory features will not be displayed at all.</p>

		</td>
	</tr>
	<tr>
		<td>
			<h2>Configuration Manager</h2>
			
			<p>Similar to the Active Directory features described above, the same is provided for System Center Configuration Manager 
			site hierarchies.</p>
			
			<p>Note: If SkCMEnabled is set to FALSE, the ConfigMgr features will not be displayed at all.</p>
			
		</td>
	</tr>
</table>
"@

Write-SkWebContent