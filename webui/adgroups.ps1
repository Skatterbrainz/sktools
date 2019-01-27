Get-SkParams
if ([string]::IsNullOrEmpty($Script:TabSelected)) {
	if (![string]::IsNullOrEmpty($SkTabSelectAdGroups)) {
		$TabSelected = $SkTabSelectAdGroups
		$SearchValue = $TabSelected
	}
}

$PageTitle   = "AD Groups"
if (![string]::IsNullOrEmpty($SearchValue)) {
    $PageTitle += ": $($SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition

$tabset = Write-SkMenuTabSetAlphaNumeric -BaseLink "$pagelink`?x=begins&f=name&tab=general&v=" -DefaultID $TabSelected
$params = @{
	ObjectType = 'group' 
	FieldName  = $SearchField
	Value      = $SearchValue
	Columns    = ('Name','Description') 
	SortColumn = "Name" 
	NoSortHeadings = $True
}
$content = Get-SkAdObjectTableMultiple @params

Write-SkWebContent