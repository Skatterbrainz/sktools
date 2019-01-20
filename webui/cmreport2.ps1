Get-SkParams
#$SearchValue = Get-SkUrlDecode -EncodedVal $Script:SearchValue

$PageTitle   = "CM Custom Report"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue) copies"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmreport2.ps1"
$queryfile = "cmfiles.sql"

$params = @{
	QueryFile = $queryfile
    PageLink  = $pagelink 
    Columns   = @('ComputerName','FileName','FileDescription','FileVersion','FilePath','FileModifiedDate','FileSize','ModifiedDate','CreationDate','ProductId') 
    Sorting   = 'ComputerName'
	NoUnFilter = $True
}

$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
