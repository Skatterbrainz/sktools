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
		$SearchField = "username"
		$params = @{
			QueryFile = "cmuser.sql"
			FieldName = "UserName"
			Value     = $SearchValue
			PageLink  = $pagelink 
			Columns   = ('UserName','FullName','UserDomain','ResourceID','Department','Title','Email','UPN','UserDN','SID','Mgr')
		}
        $content = Get-SkQueryTableSingle2 @params
        break;
    }
    'Computers' {
        $params = @{
			QueryFile  = "cmuserdevices.sql"
			PageLink   = $pagelink 
			Columns    = ('ComputerName','ProfilePath','TimeStamp','ResourceID','ADSite') 
			NoUnFilter = $True
		}
		$xxx = "queryfile: cmuserdevices.sql"
        $content = Get-SkQueryTableMultiple @params
        break;
    }
	'Collections' {
        try {
			$SearchField = 'UserName'
            $params = @{
                QueryFile  = "cmusercolls.sql"
                PageLink   = $pagelink
                Columns    = ('CollectionID','CollectionName')
				Sorting    = 'CollectionName'
				NoUnFilter = $True
				NoCaption  = $True
            }
            $content = Get-SkQueryTableMultiple @params
            $resid = Get-SkCmObjectName -TableName "v_R_User" -SearchProperty "User_Name0" -SearchValue $Script:SearchValue -ReturnProperty "ResourceID"

            if ($SkCmCollectionManage -eq 'TRUE') {
                $dcolls  = Get-SkCmUserCollectionMemberships -UserName $Script:SearchValue -Inverse
                if ($dcolls.count -gt 0) {
                    $content += "<form name='form1' id='form1' method='post' action='addmember.ps1'>
                    <input type='hidden' name='resname' id='resname' value='$CustomName' />
                    <input type='hidden' name='resid' id='resid' value='$resid' />
                    <input type='hidden' name='restype' id='restype' value='4' />
                    <table id=table2><tr><td>
                    <select name='collid' id='collid' size=1 style='width:500px;padding:5px'>
                    <option value=`"`"></option>"
                    foreach ($row in $dcolls) {
                        $cid = $row.CollectionID
                        $cnn = $row.Name
                        $content += "<option value=`"$cid`:$cnn`">$cnn</option>"
                    }
                    $content += "</select> <input type='submit' name='ok' id='ok' value='Add' class='button1' />
                    (direct membership collections only)</td></tr></table></form>"
                }
            }
        }
        catch {
            $content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
		break;
	}
} # switch

$tabs    = @('General','Computers','Collections')
$tabset  = Write-SkMenuTabSetNameList -MenuTabs $tabs -BaseLink $pagelink
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent