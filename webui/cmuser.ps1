$Script:SearchField = Get-SkPageParam -TagName 'f' -Default "UserName"
$Script:SearchValue = Get-SkPageParam -TagName 'v' -Default ""
$Script:SearchType  = Get-SkPageParam -TagName 'x' -Default 'equals'
$Script:SortField   = Get-SkPageParam -TagName 's' -Default ""
$Script:SortOrder   = Get-SkPageParam -TagName 'so' -Default 'Asc'
$Script:TabSelected = Get-SkPageParam -TagName 'tab' -Default 'General'
$Script:Detailed    = Get-SkPageParam -TagName 'zz' -Default ""
$Script:CustomName  = Get-SkPageParam -TagName 'n' -Default ""
$Script:PageTitle   = "CM User: $CustomName"
$Script:PageCaption = "CM User: $CustomName"

$content = ""
$tabset  = ""

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

if ($SkNotesEnable -eq 'true') {
    $tabs = @('General','Computers','Notes')
}
else {
    $tabs = @('General','Computers')
}

$tabset = New-New-SkMenuTabSet2 -MenuTabs $tabs -BaseLink "cmuser.ps1"
$content += Write-SkDetailView -PageRef "cmuser.ps1" -Mode $Detailed

@"
<html>
<head>
<link rel="stylesheet" type="text/css" href="$STTheme"/>
</head>

<body>

<h1>$PageCaption</h1>

$tabset
$content

</body>
</html>
"@