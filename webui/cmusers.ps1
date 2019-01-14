Get-SkParams

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
	Columns   = ('ResourceID','UserName','AADUserID','Domain','UPN','Department','Title')
	Sorting   = 'UserName'
}
$content  = Get-SkQueryTableMultiple @params
$tabset   = New-SkMenuTabSet -BaseLink 'cmusers.ps1?x=begins&f=UserName&v=' -DefaultID $TabSelected
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
