Get-SkParams

$PageTitle   = "CM Devices"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition
$qfile    = "cmdevices.sql"

$params = @{
	QueryFile = $qfile 
	PageLink  = $pagelink 
	Columns   = ('Name','ResourceID','Manufacturer','Model','OSName','OSBuild','OSType','ADSiteName') 
	Sorting   = "Name"
}
$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed
$tabset = Write-SkMenuTabSetAlphaNumeric -BaseLink "$pagelink`?x=begins&f=name&v=" -DefaultID $Script:TabSelected

Write-SkWebContent