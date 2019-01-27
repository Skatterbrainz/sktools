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
	FieldName = $SearchField
	Value     = $SearchValue
    Columns   = ('ScriptName','ScriptVersion','ScriptGuid','Author','ScriptType','Feature','ApprovalState','Approval','Approver','Script','ScriptHashAlgorithm','ScriptHash','LastUpdateTime','Comment')
}
$content = Get-SkQueryTableSingle2 @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent