$p = Split-Path $PSScriptRoot
$m = Get-Module sktools | select -ExpandProperty path

if ($SkTheme -eq 'stdark.css') { 
    $themeset = "<option value=`"dark`" selected>Dark</option> <option value=`"light`">Light</option>" 
}
else { 
    $themeset = "<option value=`"dark`">Dark</option> <option value=`"light`" selected>Light</option>"
}

$content = "<table id=table2>
<tr>
    <td class=`"t2td1`">
        Style / Theme
    </td>
    <td class=`"t2td2`">
        <select name=`"theme`" id=`"theme`" size=`"1`" style=`"padding:5px;width:100px`">
            <option value=`"`"></option>
            $themeset
        </select>
    </td>
</tr>
<tr>
    <td class=`"t2td1`">
        CM SQL Host
    </td>
    <td class=`"t2td2`">
        <input type=`"text`" name=`"SkCmDBHost`" id=`"SkCmDBHost`" value=`"$SkCmDBHost`" style=`"padding:5px;width:200px;`" />
    </td>
</tr>
<tr>
    <td class=`"t2td1`">
        CM SMS Provider
    </td>
    <td class=`"t2td2`">
        <input type=`"text`" name=`"SkCmSMSProvider`" id=`"SkCmSMSProvider`" value=`"$SkCmSMSProvider`" style=`"padding:5px;width:200px;`" />
    </td>
</tr>
<tr>
    <td class=`"t2td1`">
        CM Site Code
    </td>
    <td class=`"t2td2`">
        <input type=`"text`" name=`"SkCmSiteCode`" id=`"SkCmSiteCode`" value=`"$SkCmSiteCode`" style=`"padding:5px;width:200px;`" />
    </td>
</tr>
<tr>
    <td class=`"t2td1`">
        CM Enabled
    </td>
    <td class=`"t2td2`">
        <select name=`"SkCmEnabled`" id=`"SkCmEnabled`" size=`"1`" style=`"padding:5px;width:100px;`">
            <option value=`"TRUE`">Yes</option>
            <option value=`"FALSE`">No</option>
        </select>
    </td>
</tr>
<tr>
    <td class=`"t2td1`">
        Debugging Enabled
    </td>
    <td class=`"t2td2`">
        <select name=`"SkDebug`" id=`"SkDebug`" size=`"1`" style=`"padding:5px;width:100px;`">
			<option value=`"FALSE`">No</option>
            <option value=`"TRUE`">Yes</option>
        </select>
    </td>
</tr>
</table>"

@"
<html>
<head>
<link rel="stylesheet" type="text/css" href="$SkTheme"/>
<title>SkatterTools Settings</title>
</head>

<body>

<h1>Settings</h1>

<form name="form1" id="form1" method="post" action="savesettings.ps1">
$content
<input type="submit" name="ok" id="ok" value="Save" class="button1" />
</form>

</body>
</html>
"@