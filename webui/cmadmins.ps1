Get-SkParams

$PageTitle   = "CM Security Admins"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmadmins.ps1"
$queryfile = "cmadmins.sql"
$params = @{
    QueryFile = $queryfile 
    PageLink  = $pagelink 
    Columns   = @('RoleName','UserName','DisplayName','DistinguishedName','AdminID','RoleID','AdminSID','IsGroup','AccountType') 
    Sorting   = 'UserName'
}

$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Write-SkWebContent
