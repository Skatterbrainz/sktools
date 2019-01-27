Get-SkParams

$PageTitle   = "AD Forest"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "adforest.ps1"

$forest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
$rootDom = $forest.RootDomain
$schemaVersion = Get-SkAdForestSchemaVersion

$dlvl = Get-SkAdDomainLevel -Level $rootDom.DomainModeLevel
$flvl = Get-SkAdForestLevel -Level $forest.ForestModeLevel

$im  = $rootDom.InfrastructureRoleOwner
$pdc = $rootDom.PdcRoleOwner
$rid = $rootDom.RidRoleOwner

$pdcName = $pdc.Name
$pdcIP   = $pdc.IPAddress
$pdcOS   = $pdc.OSVersion
$pdcSite = $pdc.SiteName
$pdcGC   = $pdc.IsGlobalCatalog()
$pdcx    = $pdc.GetAllReplicationNeighbors()

$imName  = $im.Name
$imIP    = $im.IPAddress
$imOS    = $im.OSVersion
$imSite  = $im.SiteName
$imGC    = $im.IsGlobalCatalog()
$imx     = $im.GetAllReplicationNeighbors()

$ridName = $rid.Name
$ridIP   = $rid.IPAddress
$ridOS   = $rid.OSVersion
$ridSite = $rid.SiteName
$ridGC   = $rid.IsGlobalCatalog()
$ridx    = $rid.GetAllReplicationNeighbors()

$smdc = $forest.SchemaRoleOwner
$smnm = $forest.NamingRoleOwner

$smdcx = "<a href=`"adcomputer.ps1?f=Name&v=$($($smdc -split '\.')[0])`">$smdc</a>"
$smnmx = "<a href=`"adcomputer.ps1?f=Name&v=$($($smnm -split '\.')[0])`">$smnm</a>"
$ridnx = "<a href=`"adcomputer.ps1?f=Name&v=$($($ridName -split '\.')[0])`">$ridName</a>"
$pdcnx = "<a href=`"adcomputer.ps1?f=Name&v=$($($pdcName -split '\.')[0])`">$pdcName</a>"
$imnx  = "<a href=`"adcomputer.ps1?f=Name&v=$($($imName -split '\.')[0])`">$imName</a>"

$content = "<table id=table2>
<tr><td>Active Directory Forest</td><td>$($forest.Name)</td></tr>
<tr><td>Forest Schema</td><td>$schemaVersion</td></tr>
<tr><td>Forest Mode Level</td><td>$flvl</td></tr>
<tr><td>Root Domain Level</td><td>$dlvl</td></tr>
<tr><td>FSMO - PDC emulator</td><td>$pdcnx ($pdcIP - $pdcOS)</td></tr>
<tr><td>FSMO - Infrastructure master</td><td>$imnx ($imIP - $imOS)</td></tr>
<tr><td>FSMO - RID master</td><td>$ridnx ($ridIP - $ridOS)</td></tr>
<tr><td>FSMO - Schema master</td><td>$smdcx</td></tr>
<tr><td>FSMO - Naming master</td><td>$smnmx</td></tr>
<tr><td>Global Catalogs</td><td><ul>$($forest.GlobalCatalogs | %{"<li>$_</li>"})</ul></td></tr>
<tr><td>Partitions</td><td><ul>$($forest.ApplicationPartitions | %{"<li>$_</li>"})</ul></td></tr>
</table>"

Write-SkWebContent
