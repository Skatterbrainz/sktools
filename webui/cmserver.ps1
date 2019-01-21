Get-SkParams
$Script:RoleCode    = Get-SkPageParam -TagName 'rc' -Default ""
$Script:SearchValue = $Script:CustomName

$PageTitle   = "CM Site System"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    #$itemName = Get-SkCmObjectName -TableName "vSMS_Scripts" -SearchProperty "ScriptGuid" -SearchValue $Script:SearchValue -ReturnProperty "ScriptName"
    $PageTitle += ": $RoleCode = $CustomName"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmserver.ps1"

try {
    switch ($Script:RoleCode) {
        'dp' {
			$SearchField = 'ServerName'
            $params = @{
                QueryFile = "cmdp.sql"
                PageLink  = $pagelink
            }
            $content = Get-SkQueryTableSingle @params
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

Write-SkWebContent