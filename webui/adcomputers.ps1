﻿Get-SkParams | Out-Null

$PageTitle   = "AD Computers"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition

$tabset = New-SKMenuTabSet -BaseLink 'adcomputers.ps1?x=begins&f=name&v=' -DefaultID $TabSelected
$content = Get-SkAdObjectTableMultiple -ObjectType 'computer' -Columns ('Name','OS','OSver','LastLogon') -NoSortHeadings -SortColumn "Name"

Show-SkPage