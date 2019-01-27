Get-SkParams
$Script:SearchField = "FileName"
$Script:SearchType  = "begins"

if ([string]::IsNullOrEmpty($Script:TabSelected)) {
	if (![string]::IsNullOrEmpty($SkTabSelectCmFiles)) {
		$TabSelected = $SkTabSelectCmFiles
		$Script:SearchValue = $TabSelected
	}
}
$PageTitle   = "CM Software Files"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmfiles.ps1"
$queryfile = "cmfilescount.sql"

$params = @{
    QueryFile = $queryfile
    PageLink  = $pagelink 
    Columns   = ('FileName','FileVersion','FileID','FileSize','Copies') 
    Sorting   = 'FileName'
}
$content = Get-SkQueryTableMultiple @params
$tabset  = Write-SkMenuTabSetAlphaNumeric -BaseLink "$pagelink`?x=begins&f=FileName&v=" -DefaultID $TabSelected
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed
Write-SkWebContent