Get-SkParams

$PageTitle   = "AD Site Links"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "adsitelinks.ps1"
$queryfile = ""

$tabset  = Write-SkMenuTabSetAlphaNumeric -BaseLink "$pagelink`?x=begins&f=Name&v=" -DefaultID $TabSelected

try {
	$sitelinks = Get-SkADSiteLinks | Select Name,SiteLinks,Subnets,SiteLinksCost,ReplicationInterval,Servers
	if (![string]::IsNullOrEmpty($Script:SearchValue)) {
		$IsFiltered = $True
		switch ($SearchType) {
			{($_ -eq 'contains') -or ($_ -eq 'like')} {
				$sitelinks = $sitelinks | Where-Object {$_."$Script:SearchField" -like "*$Script:SearchValue*"}
				$cap = 'contains'
				break;
			}
			'begins' {
				$sitelinks = $sitelinks | Where-Object {$_."$Script:SearchField" -like "$Script:SearchValue*"}
				$cap = 'begins with'
				break;
			}
			'ends' {
				$sitelinks = $sitelinks | Where-Object {$_."$Script:SearchField" -like "*$Script:SearchValue"}
				$cap = 'ends with'
				break;
			}
			'notlike' {
				$sitelinks = $sitelinks | Where-Object {$_."$Script:SearchField" -notlike "*$Script:SearchValue"}
				$cap = 'ends with'
				break;
			}
			default {
				$sitelinks = $sitelinks | Where-Object {$_."$Script:SearchField" -eq $Script:SearchValue}
				$cap = '='
				break;
			}
		}
	}
	$content = "<table id=table1>"
	$content += "<tr><th>Link</th><th>SiteName</th><th>Subnets</th><th>Cost</th><th>Interval</th><th>Servers</th></tr>"
	$sitelinks | %{
		$sn = $($_.Servers).ToString().Trim()
		$snx = ($sn -split '\.')[0]
		$snx = "<a href=`"adcomputer.ps1?f=name&v=$snx&x=equals&tab=general`" title=`"Details for $sn`">$sn</a>"
		$content += "<tr>"
		$content += "<td>$($_.SiteLinks)</td>"
		$content += "<td>$($_.Name)</td>"
		$content += "<td>$($_.Subnets)</td>"
		$content += "<td>$($_.SiteLinksCost)</td>"
		$content += "<td>$($_.ReplicationInterval)</td>"
		$content += "<td>$snx</td>"
		$content += "</tr>"
	}
	$content += "<tr><td colspan=`"6`" class=`"lastrow`">$($sitelinks.Count) items found</td></tr>"
	$content += "</table>"
}
catch {
	$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
}
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
