Get-SkParams

$PageTitle   = "AD Users"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "adusers.ps1"

$tabset = New-SkMenuTabSet -BaseLink 'adusers.ps1?x=begins&f=username&v=' -DefaultID $TabSelected
$content = Get-SkAdObjectTableMultiple -ObjectType 'user' -Columns ('UserName','DisplayName','Title','Department','LastLogon') -SortColumn "UserName" -NoSortHeadings

Write-SkWebContent