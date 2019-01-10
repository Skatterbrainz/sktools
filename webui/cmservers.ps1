$Script:SearchField = Get-SkPageParam -TagName 'f' -Default ""
$Script:SearchValue = Get-SkPageParam -TagName 'v' -Default ""
$Script:SearchType  = Get-SkPageParam -TagName 'x' -Default "like"
$Script:SortField   = Get-SkPageParam -TagName 's' -Default "Name"
$Script:SortOrder   = Get-SkPageParam -TagName 'so' -Default "asc"
$Script:TabSelected = Get-SkPageParam -TagName 'tab' -Default 'all'
$Script:Detailed    = Get-SkPageParam -TagName 'zz' -Default ""
$Script:CustomName  = Get-SkPageParam -TagName 'n' -Default ""
$Script:RoleCode    = Get-SkPageParam -TagName 'rc' -Default ""
$Script:IsFiltered  = $False
$Script:PageTitle   = "CM Site Systems"
$Script:PageCaption = "CM Site Systems"
$content     = ""
$tabset      = ""
$outree      = $null
$query       = $null
$xxx         = ""

try {
    switch ($Script:RoleCode) {
        'dp' {
            $content = Get-SkQueryTableMultiple -QueryFile "cmdps.sql" -PageLink "cmservers.ps1" -Columns ('DPID','DPName','Description','SMSSiteCode','IsPXE','DPType','Type')
            $Script:PageCaption += ": Distribution Points"
            break;
        }
        default {
            $content = "<table id=table2><tr><td>Not implemented</td></tr></table>"
            break;
        }
    }
}
catch {
    $content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
}

#$tabset = New-MenuTabSet -BaseLink 'cmbgroups.ps1?x=begins&f=bgname&v=' -DefaultID $Script:TabSelected
$content += Write-SkDetailView -PageRef "cmservers.ps1" -Mode $Detailed

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