Get-SkParams

$PageTitle   = "CM Devices"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition
$tabset = New-SkMenuTabSet -BaseLink "cmdevices.ps1`?x=begins&f=name&v=" -DefaultID $Script:TabSelected
$qfile = "cmdevices.sql"

$params = @{
	QueryFile = $qfile 
	PageLink  = $pagelink 
	Columns   = ('Name','ResourceID','Manufacturer','Model','OSName','OSBuild','ADSiteName') 
	Sorting   = "Name"
}
$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent