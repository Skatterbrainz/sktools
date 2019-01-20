Get-SkParams | Out-Null

if ($Script:CollectionType -eq '2') {
    $Ctype = "Device"
    $qfname = "cmdevicecollections.sql"
}
else {
    $Ctype = "User"
    $qfname = "cmusercollections.sql"
}

$PageTitle   = "CM $CType Collections"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition

$content = Get-SkQueryTableMultiple -QueryFile $qfname -PageLink "cmcollections.ps1" -NoCaption
$tabset  = New-SkMenuTabSet -BaseLink "cmcollections.ps1?t=$CollectionType&f=collectionname&x=begins&v=" -DefaultID $TabSelected
$content += Write-SkDetailView -PageRef "cmcollections.ps1" -Mode $Detailed

Write-SkWebContent