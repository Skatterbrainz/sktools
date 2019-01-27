Get-SkParams

$PageTitle   = "CM Software"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmpackage.ps1"
$pkgtype  = Get-SkCmObjectName -TableName "v_Package" -SearchProperty "PackageID" -SearchValue $SearchValue -ReturnProperty "PackageType"

switch ($Script:TabSelected) {
    'General' {
        $params = @{
			QueryFile = "cmpackage.sql" 
			PageLink  = $pagelink 
			Columns   = ('PackageID','Name','Version','Manufacturer','PackageType','PkgType','Description','PkgSourcePath','SourceVersion','SourceDate','SourceSite','LastRefreshTime')
			FieldName = $SearchField
			Value     = $SearchValue
		}
		$content = Get-SkQueryTableSingle2 @params
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
	'Components' {
		$content = Get-SkQueryTableMultiple -QueryFile "cmbootimagecomponents.sql" -PageLink $pagelink -Columns ('Component','Architecture','ComponentID','MsiComponentID','Size','Required','Manageable') -Sorting "Component" -NoCaption
		break;
	}
}
if ($pkgtype -eq 258) {
	$tabs = @('General','Programs','Advertisements','Components')
}
else {
	$tabs = @('General','Programs','Advertisements')
}
$tabset = Write-SkMenuTabSetNameList -MenuTabs $tabs -BaseLink "cmpackage.ps1"

Write-SkWebContent
