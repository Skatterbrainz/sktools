Get-SkParams
$Script:RoleCode    = Get-SkPageParam -TagName 'rc' -Default ""
$Script:SearchValue = $Script:CustomName

$PageTitle   = "CM Site System"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    #$itemName = Get-SkCmObjectName -TableName "vSMS_Scripts" -SearchProperty "ScriptGuid" -SearchValue $Script:SearchValue -ReturnProperty "ScriptName"
    $PageTitle += ": $CustomName"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmserver.ps1"

try {
    switch ($Script:RoleCode) {
        'dp' {
            $params = @{
                QueryFile = "cmdp.sql"
                Columns   = ('DPID','ServerName','Description','NALPath','ShareName','SiteCode','PXE','SCCMPXE','Active','PeerDP',
'PullDP','PullDPInstalled','FileStreaming','BITS','MultiCast','Protected','RemoveWDS','AnonEnabled','TokenAuth',
'SSL','DPType','PreStaging','DPDrive','MinFreeSpace','Type','Action','State','DPFlags','DPCRC','ResponseDelay',
'UDA','BindPolicy','SupportUnknownMachines','IdentityGUID','BindExcept','CertType','Account','Priority','TransferRate',
'ISVString','Flags','MaintenanceMode','RoleCapabilities')
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

Show-SkPage