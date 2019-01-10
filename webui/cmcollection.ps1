Get-SkParams

$PageTitle   = "CM Collection"
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmcollection.ps1"

if ([string]::IsNullOrEmpty($Script:CustomName)) {
    #$collName = Get-SkCmCollectionName -CollectionID $Script:SearchValue
    $collName = Get-SkCmObjectName -TableName "v_Collection" -SearchProperty "CollectionID" -SearchValue $Script:SearchValue -ReturnProperty "Name"
}
else {
    $collName = $Script:CustomName
}

if (![string]::IsNullOrEmpty($collName)) {
    $PageTitle += ": $collName"
}

if ($CollectionType -eq '2') {
    $Ctype    = "Device"
    $ResType  = 5
    $CollType = 2
}
else {
    $Ctype    = "User"
    $ResType  = 4
    $CollType = 1
}


switch ($Script:TabSelected) {
    'General' {
        $xxx = "Collection Type: $CollType"
        $params = @{
            QueryFile = "cmcollection.sql"
            PageLink  = "cmcollection.ps1"
            Columns   = ('CollectionName','CollectionID','Comment','Members','Type','Variables','LimitedTo')
        }
        #$content = Get-SkQueryTableSingle @params
        $content = Get-SkQueryTableSingle -QueryFile "cmcollection.sql" -PageLink = $pagelink -Columns ('CollectionName','CollectionID','Comment','Members','Type','Variables','LimitedTo')
        break;
    }
    'Members' {
        $xxx = "Collection Type: $CollType"
        if ($CollType -eq 2) {
            $qfile = "cmdevicecollectionmembers.sql"
            $columns = ('ComputerName','ResourceID','ResourceType','Domain','SiteCode','RuleType','CollectionID')
        }
        else {
            $qfile = "cmusercollectionmembers.sql"
            $columns = ('UserName','UserFullName','ResourceID','Domain','SiteCode','RuleType','CollectionID')
        }
        $content = Get-SkQueryTableMultiple -QueryFile $qfile -PageLink "cmcollection.ps1" -Columns $columns -NoUnFilter -NoCaption
        break;
    }
    'QueryRules' {
        $xxx = "Collection Type: $CollType"
        $content = Get-SkQueryTableMultiple -QueryFile "cmcollectionqueryrules.sql" -PageLink "cmcollection.ps1" -Columns ('RuleName','QueryID','QueryExpression','LimitToCollectionID') -NoUnFilter -NoCaption -Sorting "RuleName"
        break;
    }
    'Variables' {
        $content = Get-SkQueryTableMultiple -QueryFile "cmcollectionvariables.sql" -PageLink "cmcollection.ps1" -Columns ('Name','Value','IsMasked')
        break;
    }
    'Tools' {
        $content = "<table id=table1>"
        $content += "<tr><td style=`"height:150px;text-align:center`">Still in Development. Check back soon.</td></tr>"
        $content += "</table>"
        break;
    }
    'Notes' {
        $content = "<table id=table1>"
        $content += "<tr><td style=`"height:150px;text-align:center`">Still in Development. Check back soon.</td></tr>"
        $content += "</table>"
        break;
    }
} # switch

$tabs = @('General','Members','QueryRules','Variables','Tools')
$tabset  = New-SkMenuTabSet2 -MenuTabs $tabs -BaseLink "cmcollection.ps1"
$content += Write-SkDetailView -PageRef "cmcollection.ps1" -Mode $Detailed

Show-SkPage
