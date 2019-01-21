Get-SkParams

$PageTitle   = "CM Software"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmpackage.ps1"

switch ($Script:TabSelected) {
    'General' {
        $content = Get-SkQueryTableSingle -QueryFile "cmpackage.sql" -PageLink "cmpackage.ps1" -Columns ('PackageID','Name','Version','Manufacturer','PackageType','PkgType','Description','PkgSourcePath','SourceVersion','SourceDate','SourceSite','LastRefreshTime')
        break;
    }
    'Programs' {
        $content = Get-SkQueryTableMultiple -QueryFile "cmpackageprograms.sql" -PageLink $pagelink -Columns ('ProgramName','Comment','Description','CommandLine') -Sorting 'ProgramName' -NoCaption
        break;
    }
    'Advertisements' {
		$content = Get-SkQueryTableMultiple -QueryFile "cmadvertisements.sql" -PageLink $pagelink -Columns ('AdvertisementName','AdvertisementID','PackageName','PackageID','ProgramName','CollectionID','CollectionName') -Sorting 'PackageName' -NoCaption
        break;
    }
}
$tabs = @('General','Programs','Advertisements')
$tabset = New-SkMenuTabSet2 -MenuTabs $tabs -BaseLink "cmpackage.ps1"

Write-SkWebContent
