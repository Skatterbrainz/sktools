Get-SkParams | Out-Null
if ([string]::IsNullOrEmpty($Script:TabSelected)) {
	if (![string]::IsNullOrEmpty($SkTabSelectAdComputers)) {
		$TabSelected = $SkTabSelectAdComputers
		$SearchValue = $TabSelected
	}
}

$PageTitle   = "AD Computers"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition

try {
	$tabset = Write-SkMenuTabSetAlphaNumeric -BaseLink "$pagelink`?x=begins&f=name&v=" -DefaultID $TabSelected
	$params = @{
		ObjectType  = 'computer' 
		FieldName   = $SearchField
		Value       = $SearchValue
		Columns     = ('Name','OS','OSver','OSType','LastLogon') 
		SortColumn  = "Name"
		NoSortHeadings = $True
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