$theme       = $PoshPost.Theme
$cmdbhost    = $PoshPost.SkCmDBHost
$cmsitecode  = $PoshPost.SkCmSiteCode
$cmsmsprov   = $PoshPost.SkCmSMSProvider
$cmenabled   = $PoshPost.SkCmEnabled
$debugenable = $PoshPost.SkDebug

$themefile = "st$theme.css"

try {
    $cfgfile = "$($env:USERPROFILE)\Documents\skconfig.txt"
    $params = [ordered]@{
        _Comment = "SkatterTools configuration file. Created by Set-SkDefaults"
        _LastUpdated         = (Get-Date)
        _UpdatedBy           = $env:USERNAME
        _LocalHost           = $env:COMPUTERNAME
        SkAPPNAME            = "SkatterTools"
        SkTheme              = $Themefile
        SkADEnabled          = "TRUE"
        SkADGroupManage      = "TRUE"
        SkCMEnabled          = $cmenabled
        SkCmDBHost           = $cmdbhost
        SkCmSMSProvider      = $cmsmsprov
        SkCmSiteCode         = $cmsitecode
        SkCmCollectionManage = "TRUE"
		SkDebug              = $debugenable
    }
    $params.Keys | %{ "$($_) = $($params.Item($_))" } | Out-File $cfgfile

    $content = "<table id=table2>
<tr><td>Theme</td><td>$themefile</td></tr>
<tr><td>CM DB Host</td><td>$cmdbhost</td></tr>
<tr><td>CM SMS Provider</td><td>$cmsmsprov</td></tr>
<tr><td>CM Site Code</td><td>$cmsitecode</td></tr>
<tr><td>CM Enabled</td><td>$cmenabled</td></tr>
<tr><td>Debug Enabled</td><td>$debugenable</td></tr>
</table>"
}
catch {
    $content = "<table id=table2><tr><td>Failed!</td></tr></table>"
}

@"
<html>
<head>
<link rel="stylesheet" type="text/css" href="$SkTheme"/>
<title>SkatterTools Settings</title>
</head>

<body>

<h1>Settings</h1>

$content

</body>
</html>
"@