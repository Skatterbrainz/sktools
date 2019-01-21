Get-SkParams
$CollType = Get-SkPageParam -TagName 't' -Default ""

$PageTitle   = "CM Collection"
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "cmcollection.ps1"

if ([string]::IsNullOrEmpty($Script:CustomName)) {
    $collName = Get-SkCmObjectName -TableName "v_Collection" -SearchProperty "CollectionID" -SearchValue $Script:SearchValue -ReturnProperty "Name"
}
else {
    $collName = $Script:CustomName
}
if (![string]::IsNullOrEmpty($collName)) {
    $PageTitle += ": $collName"
}

$mType = ""
$mType = Get-SkCmObjectName -TableName "v_CollectionRuleQuery" -SearchProperty "CollectionID" -SearchValue $Script:SearchValue -ReturnProperty "CollectionID"
if ($mType -ne "") { $RuleGroup = 'QUERY' } else { $RuleGroup = 'DIRECT' }

if ($CollType -eq '2') {
    $Ctype    = "Device"
    $ResType  = 5
}
else {
    $Ctype    = "User"
    $ResType  = 4
}

switch ($Script:TabSelected) {
    'General' {
        $xxx = "Collection Type: $CollType"
        $params = @{
            QueryFile = "cmcollection.sql"
            PageLink  = "cmcollection.ps1"
            Columns   = ('CollectionName','CollectionID','Comment','Members','Type','Variables','LimitedTo')
        }
        $content = Get-SkQueryTableSingle @params
        break;
    }
    'Members' {
        $xxx = "Collection Type: $CollType"
        if ($CollType -eq 2) {
            $qfile   = "cmdevicecollectionmembers.sql"
            $columns = ('ComputerName','ResourceID','ResourceType','Domain','SiteCode','RuleType','CollectionID')
			$sorton  = 'ComputerName'
        }
        else {
            $qfile   = "cmusercollectionmembers.sql"
            $columns = ('UserName','UserFullName','ResourceID','Domain','SiteCode','RuleType','CollectionID')
			$sorton  = 'UserName'
        }
		$params = @{
			QueryFile  = $qfile
			PageLink   = $pagelink
			Columns    = $columns
			Sorting    = $sorton
			NoUnFilter = $True
			NoCaption  = $True
		}
        $content = Get-SkQueryTableMultiple @params
		if ($RuleGroup -ne 'QUERY' -and $SkCmCollectionManage -eq "true") {
			$members  = Get-SkCmCollectionMembers -CollectionID $Script:SearchValue -CollectionType $Ctype -Inverse
			if ($members.count -gt 0) {
				$content += "<form name='form1' id='form1' method='post' action='addmember.ps1'>"
				$content += "<input type='hidden' name='collname' id='collname' value='$CollectionName' />"
				$content += "<input type='hidden' name='collid' id='collid' value='$Script:SearchValue' />"
				$content += "<input type='hidden' name='colltype' id='colltype' value='$colltype' />"
				$content += "<input type='hidden' name='restype' id='restype' value='$restype' />"
				$content += "<input type='hidden' name='targettype' id='targettype' value='collection' />"
				$content += "<table id=table2><tr><td>"
				$content += "<select name='resid' id='resid' size=1 style='width:500px;padding:5px'>"
				$content += "<option value=`"`"></option>"
				foreach ($row in $members) {
					$rid = $row.ResourceID
					$rnn = $row.Name
					$content += "<option value=`"$rid`:$rnn`">$rnn</option>"
				}
				$content += "</select> <input type='submit' name='ok' id='ok' value='Add' class='button1' />"
				$content += " (direct membership collections only)</td></tr></table></form>"
			}
		}
        break;
    }
    'QueryRules' {
        $xxx = "Collection Type: $CollType"
        $content = Get-SkQueryTableMultiple -QueryFile "cmcollectionqueryrules.sql" -PageLink $pagelink -Columns ('RuleName','QueryID','QueryExpression','LimitToCollectionID') -NoUnFilter -NoCaption -Sorting "RuleName"
        break;
    }
	'Deployments' {
		$content = Get-SkQueryTableMultiple -QueryFile "cmadvertisements.sql" -PageLink $pagelink -Columns ('AdvertisementName','AdvertisementID','PackageName','PackageID','ProgramName') -Sorting 'PackageName' -NoCaption
		break;
	}
    'Variables' {
        $content = Get-SkQueryTableMultiple -QueryFile "cmcollectionvariables.sql" -PageLink $pagelink -Columns ('Name','Value','IsMasked')
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

$tabs = @('General','Members','QueryRules','Deployments','Variables','Tools')
$tabset  = New-SkMenuTabSet2 -MenuTabs $tabs -BaseLink "cmcollection.ps1?t=$CollType"
$content += Write-SkDetailView -PageRef "cmcollection.ps1" -Mode $Detailed

Write-SkWebContent
