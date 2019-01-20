Get-SkParams

$PageTitle   = "AD Sites"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = "adsites.ps1"

$tabset  = New-SkMenuTabSet -BaseLink 'adsites.ps1?x=begins&f=SiteName&v=' -DefaultID $TabSelected

try {
    $Forest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
    $sitelist = $Forest.Sites | ForEach-Object {
        $sitename = [string]$_.name
        $subnets  = [string[]]$_.subnets
        $locname  = [string]$_.Location
        $adjsites = [string[]]$_.AdjacentSites
        $props = [ordered]@{
            SiteName = $sitename
            Location = $locname
            Subnets  = $($subnets | %{$_})
            AdjacentSites = $adjsites
        }
        New-Object PSObject -Property $props
    }
    if ($Script:SearchValue -ne "") {
        switch ($Script:SearchType) {
            'like' {
                $sitelist = $sitelist | Where-Object {$_.SiteName -like "*$Script:SearchValue*"}
                break;
            }
            'begins' {
                $sitelist = $sitelist | Where-Object {$_.SiteName -like "$Script:SearchValue*"}
                break;
            }
            'ends' {
                $sitelist = $sitelist | Where-Object {$_.SiteName -like "*$Script:SearchValue"}
                break;
            }
            default {
                $sitelist = $sitelist | Where-Object {$_.SiteName -eq $Script:SearchValue}
                break;
            }
        }
        $IsFiltered = $True
    }
    $content = "<table id=table1>"
    $content += "<tr><th>Name</th><th>Location</th><th>Subnets</th><th>Adjacent Sites</td></tr>"
    $rowcount = 0
    $sitelist | ForEach-Object {
        $content += "<tr>"
        $content += "<td>$($_.SiteName)</td><td>$($_.Location)</td>"
        $content += "<td>$($_.Subnets -join ',')</td>"
        $content += "<td>$($_.AdjacentSites -join ',')</td>"
        $content += "</tr>"
        $rowcount++
    }
    $content += "<tr><td class=`"lastrow`" colspan=`"4`">$rowcount sites found</td></tr>"
    $content += "</table>"
}
catch {
    $content += "<table id=table2><tr><td>$($Error[0].Exception.Message)</td></tr></table>"
}

Write-SkWebContent