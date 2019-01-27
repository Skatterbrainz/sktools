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
	$content = ($sitelinks | ConvertTo-Html -Fragment) -replace '<table>', '<table id=table1>'
}
catch {
	$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
}
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
