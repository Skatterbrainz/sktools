Get-SkParams

$PageTitle   = "CM Script"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $scriptName = Get-SkCmObjectName -TableName "vSMS_Scripts" -SearchProperty "ScriptGuid" -SearchValue $Script:SearchValue -ReturnProperty "ScriptName"
    $PageTitle += ": $scriptName"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition
$queryfile = "cmscript.sql"

$params = @{
    QueryFile = $queryfile
    PageLink  = $pagelink
    Columns   = ('ScriptName','ScriptVersion','ScriptGuid','Author','ScriptType','Feature','ApprovalState','Approval','Approver','Script','ScriptHashAlgorithm','ScriptHash','LastUpdateTime','Comment')
}
$content = Get-SkQueryTableSingle @params
$content += Write-SkDetailView -PageRef "cmscript.ps1" -Mode $Detailed

Show-SkPage