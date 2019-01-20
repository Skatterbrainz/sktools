﻿Get-SkParams
$SearchValue = Get-SkUrlDecode -EncodedVal $Script:SearchValue

$PageTitle   = "CM Custom Report"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue) installations"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmreport3.ps1"
$queryfile = ""
$query = "SELECT 
	v_R_System.Name0 AS ComputerName, 
	v_GS_INSTALLED_SOFTWARE_CATEGORIZED.ResourceID, 
	v_GS_INSTALLED_SOFTWARE_CATEGORIZED.ProductName0 AS ProductName, 
	v_GS_INSTALLED_SOFTWARE_CATEGORIZED.ProductVersion0 AS Version, 
	v_GS_INSTALLED_SOFTWARE_CATEGORIZED.Publisher0 AS Publisher, 
	v_GS_INSTALLED_SOFTWARE_CATEGORIZED.InstalledLocation0 AS InstallLocation, 
	v_GS_INSTALLED_SOFTWARE_CATEGORIZED.InstallSource0 AS InstallSource, 
	v_GS_INSTALLED_SOFTWARE_CATEGORIZED.InstallDate0 AS InstallDate, 
	case 
		when (v_GS_INSTALLED_SOFTWARE_CATEGORIZED.InstallType0 = 0) then 'Physical'
		when (v_GS_INSTALLED_SOFTWARE_CATEGORIZED.InstallType0 = 1) then 'Virtual' 
		end as InstallType 
FROM v_GS_INSTALLED_SOFTWARE_CATEGORIZED INNER JOIN 
	v_R_System ON v_GS_INSTALLED_SOFTWARE_CATEGORIZED.ResourceID = v_R_System.ResourceID 
ORDER BY v_R_System.Name0"

$params = @{
	Query     = $query 
    PageLink  = $pagelink 
    Columns   = @('ComputerName','ResourceID','ProductName','Version','Publisher','InstallLocation','InstallSource','InstallType','InstallDate') 
    Sorting   = 'FieldName'
	NoUnFilter = $True
}

$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent