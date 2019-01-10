Get-SkParams

$PageTitle   = "CM Boundary Group: $CustomName"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmbgroup.ps1"

switch ($TabSelected) {
    'General' {
        $xxx += ";queryfile: cmboundarygroup.sql"
        $content = Get-SkQueryTableSingle -QueryFile "cmboundarygroup.sql" -PageLink "cmbgroup.ps1" -Columns ('BGName','DefaultSiteCode','GroupID','GroupGUID','Description','Flags','CreatedBy','CreatedOn','ModifiedBy','ModifiedOn','MemberCount','SiteSystemCount','Shared') -NoCaption
        break;
    }
    'Boundaries' {
        $xxx += ";queryfile: cmboundaries.sql"
        $content = Get-SkQueryTableMultiple -QueryFile "cmboundaries.sql" -PageLink "cmbgroup.ps1" -Columns ('DisplayName','BoundaryID','BValue','BoundaryType','BoundaryFlags','CreatedBy','CreatedOn','ModifiedBy','ModifiedOn','GroupID','BGName') -NoUnFilter -NoCaption
        break;
    }
}

$tabs   = @('General','Boundaries','Systems')
$tabset = New-SkMenuTabSet2 -MenuTabs $tabs -BaseLink "cmbgroup.ps1"
$content += Write-SkDetailView -PageRef "cmbgroup.ps1" -Mode $Detailed

Show-SkPage
