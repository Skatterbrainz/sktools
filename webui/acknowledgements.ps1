$PageTitle = "Acknowledgements"

$tabset = ""
$links = @(
	'http://dbatools.io',
	'http://poshserver.net',
	'https://twitter.com/BruceSaaaa',
	'http://www.systemcentercentral.com/forums-archive/topic/remove-a-member-from-an-sccm-collection-with-powershell/',
	'https://developers.google.com/chart/interactive/docs/gallery/piechart'
	'https://github.com/lazywinadmin/PowerShell/blob/master/AD-SITE-Get-ADSiteInventory/Get-ADSiteInventory.ps1',
	'https://richardspowershellblog.wordpress.com/2012/02/08/finding-user-accounts-with-passwords-set-to-never-expire/',
    'http://tech-comments.blogspot.com/2010/10/powershell-adsisearcher-basics.html',
    'https://blogs.msmvps.com/richardsiddaway/category/powershellandactivedirectory',
    'https://docs.microsoft.com/en-us/powershell/module/configurationmanager/?view=sccm-ps',
    'https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/?view=powershell-5.1',
    'https://github.com/paulwetter/DocumentConfigMgrCB/blob/master/DocumentCMCB.ps1',
    'https://lazywinadmin.com/2014/04/powershell-get-list-of-my-domain.html',
    'https://serverfault.com/questions/512228/how-to-check-ad-ds-domain-forest-functional-level-from-domain-joined-workstation',
    'https://stackoverflow.com',
    'https://www.andersrodland.com/ultimate-sccm-querie-collection-list/',
    'https://www.petri.com/active-directory-powershell-with-adsi',
    'https://www.petri.com/managing-active-directory-groups-adsi-powershell'
)
$content = "<table id=table2>"
foreach ($link in $links) {
    $content += "<tr><td><a href=`"$link`" target=`"_new`">$link</a></td></tr>"
}
$content += "</table>"

Write-SkWebContent

