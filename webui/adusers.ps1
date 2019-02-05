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

try {
	$params = @{
		ObjectType     = 'user' 
		FieldName      = $SearchField
		Value          = $SearchValue
		Columns        = ('UserName','DisplayName','Title','Department','LastLogon') 
		SortColumn     = "UserName" 
		NoSortHeadings = $True
		Diagnostics    = $False
	}
	$content = Get-SkAdObjectTableMultiple @params
}
catch {
	$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
}
finally {
	$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed
	Write-SkWebContent
}