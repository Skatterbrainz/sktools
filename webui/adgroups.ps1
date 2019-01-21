Get-SkParams

$PageTitle   = "AD Groups"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition

$tabset = New-SkMenuTabSet -BaseLink "$pagelink`?x=begins&f=name&tab=general&v=" -DefaultID $TabSelected
$params = @{
	ObjectType = 'group' 
	Columns    = ('Name','Description') 
	SortColumn = "Name" 
	NoSortHeadings = $True
}
$content = Get-SkAdObjectTableMultiple @params

Write-SkWebContent