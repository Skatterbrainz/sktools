Get-SkParams

$PageTitle   = "CM Software Files"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "cmfiles.ps1"
$queryfile = ""
$params = @{
    Query     = "select distinct [FileName],[FileDescription], [FileVersion], [FileSize], Count(*) as [Copies] from dbo.v_GS_SoftwareFile group by [FileName], [FileVersion], [FileDescription], [FileSize]"
    PageLink  = $pagelink 
    Columns   = ('FileName','FileVersion','FileSize','Copies') 
    Sorting   = 'FileName'
}
#$fnx = "<a href=`"cmfile.ps1?n=$fn&v=$fv&s=$fs`" title=`"Find Computers with this Instance`">$fn</a>"
$content = Get-SkQueryTableMultiple @params
$content += Write-SkDetailView -PageRef $pagelink -Mode $Detailed

Show-SkPage