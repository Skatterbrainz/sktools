Get-SkParams
if ([string]::IsNullOrEmpty($Script:TabSelected)) {
	if (![string]::IsNullOrEmpty($SkTabSelectCmUsers)) {
		$TabSelected = $SkTabSelectCmUsers
		$Script:SearchValue = $TabSelected
	}
}

$PageTitle   = "CM Users"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmusers.ps1"
$qfile    = "cmusers.sql"
$params = @{
	QueryFile = $qfile
	PageLink  = $pagelink
	Columns   = ('UserName','ResourceID','AADUserID','Domain','UPN','Department','Title')
	Sorting   = 'UserName'
}
$content  = Get-SkQueryTableMultiple @params
$tabset   = Write-SkMenuTabSetAlphaNumeric -BaseLink "$pagelink`?f=UserName&x=begins&v=" -DefaultID $Script:TabSelected
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

$content += "<p>Tab: $TabSelected</p>"

Write-SkWebContent
