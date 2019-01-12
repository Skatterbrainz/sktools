Get-SkParams

$PageTitle   = "CM Installed Software"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmproducts.ps1"
$queryfile = "query.sql"
$params = @{
    Query     = "select distinct 
productname0 as ProductName,
productcode0 as ProductCode,
productversion0 as Version, 
publisher0 as Publisher, 
count(*) as Installs 
from v_GS_INSTALLED_SOFTWARE_CATEGORIZED 
group by productname0, productcode0, productversion0, publisher0"
    PageLink  = $pagelink 
    Columns   = ('ProductName','Version','Publisher','ProductCode','Installs') 
    Sorting   = 'ProductName'
}

$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Show-SkPage

<#
# for individual product page

$query = 'select distinct 
productname0 as ProductName,
productcode0 as ProductCode,
productversion0 as Version, 
publisher0 as Publisher, 
installsource0 as Source, 
uninstallstring0 as Uninstall, 
installdate0 as InstallDate,
normalizedname as NormalName, 
normalizedversion as NormalVersion, 
normalizedpublisher as NormalPublisher, 
FamilyName, 
CategoryName 
from v_GS_INSTALLED_SOFTWARE_CATEGORIZED'
#>