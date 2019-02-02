Get-SkParams
<#
if ([string]::IsNullOrEmpty($Script:TabSelected)) {
	if (![string]::IsNullOrEmpty($SkTabSelectAdUsers)) {
		$TabSelected = $SkTabSelectAdUsers
		$SearchValue = $TabSelected
	}
}
#>
$PageTitle   = "AD Users"
if (![string]::IsNullOrEmpty($SearchValue)) {
    $PageTitle += ": $($SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "adusers.ps1"

$tabset = Write-SkMenuTabSetAlphaNumeric -BaseLink "$pagelink`?x=begins`&f=username`&v=" -DefaultID $TabSelected
$params = @{
	ObjectType = 'user' 
	FieldName  = $SearchField
	Value      = $SearchValue
	Columns    = ('UserName','DisplayName','Title','Department','LastLogon') 
	SortColumn = "UserName" 
	NoSortHeadings = $True
	Diagnostics = $False
}
$content = Get-SkAdObjectTableMultiple @params

Write-SkWebContent