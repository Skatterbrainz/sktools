﻿Get-SkParams

$PageTitle   = "CM Software Files"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmfiles.ps1"
$queryfile = ""
$params = @{
    QueryFile = "cmfilescount.sql"
    PageLink  = $pagelink 
    Columns   = ('FileName','FileVersion','FileID','FileSize','Copies') 
    Sorting   = 'FileName'
}
$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent