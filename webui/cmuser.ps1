Get-SkParams

$PageTitle   = "CM User"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition

switch ($Script:TabSelected) {
    'General' {
        $xxx = "queryfile: cmuser.sql"
        $content = Get-SkQueryTableSingle -QueryFile "cmuser.sql" -PageLink "cmuser.ps1" -Columns ('UserName','FullName','UserDomain','ResourceID','Department','Title','Email','UPN','UserDN','SID','Mgr')
        break;
    }
    'Computers' {
        $xxx = "queryfile: cmuserdevices.sql"
        $content = Get-SkQueryTableMultiple -QueryFile "cmuserdevices.sql" -PageLink "cmuser.ps1" -Columns ('ComputerName','ProfilePath','TimeStamp','ResourceID','ADSite') -NoUnFilter
        break;
    }
} # switch

$tabs = @('General','Computers')
$tabset  = New-SkMenuTabSet2 -MenuTabs $tabs -BaseLink "cmuser.ps1"
$content += Write-SkDetailView -PageRef "cmuser.ps1" -Mode $Detailed

Write-SkWebContent