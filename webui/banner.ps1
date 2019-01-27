$img = ""
$imx = Join-Path -Path $PSScriptRoot -ChildPath "graphics\$Global:SkAppName`.png"
if (Test-Path $imx) {
    $img = "<img src=`"graphics/$Global:SkAppName`.png`" style=`"height:80px;vertical-align:middle`" border=`"0`" />"
}
@"
<html>
<head>
<link rel="stylesheet" type="text/css" href="$SkTheme"/>
</head>
<body class="bannerbody">
<span onClick="window.top.location.href='./'" style=`"vertical-align:absmiddle`" title=`"$Global:SkAppName`">$img $($Global:SkAppName)</span>
</body>
</html>
"@