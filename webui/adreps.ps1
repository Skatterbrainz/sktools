Get-SkParams

$PageTitle   = "AD Custom Reports"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "page.ps1"
$queryfile = "query.sql"

try {
	$laststep = "getting raw data"
	$users  = Get-SkAdUsers
	$comps  = Get-SkAdComputers -SearchType All
	$noexp  = Get-SkAdUserPwdNoExpiration
	$exps   = Get-SkAdUserPwdExpirations | Where-Object {$_.Expires -lt 14} | Where-Object {$_.UserName -ne 'krbtgt'}
	$dusers = Get-SkAdUserDisabled

	$laststep = "filtering data"
	$uDates = $users | Select -ExpandProperty LastLogon
	$mDates = $comps | Select -ExpandProperty LastLogon

	$dayslist = @(30, 60, 90, 180, 365)

	$laststep = "compiling table 1 of 2"
	$content = "<table style=`"width:100%;border:none`"><tr>"
	$content += "<td style=`"width:50%; vertical-align:top`">"

		$content += "<h2>User Accounts</h2>"

		$content += "<table id=table1>"
		$content += "<tr><th>Users</th><th>Days since last login</th></tr>"
		foreach ($dx in $dayslist) {
			$content += "<tr>"
			$num = ($uDates | Foreach-Object {(New-TimeSpan -Start $_ -End $(Get-Date)).Days} | ?{$_ -gt $dx}).Count
			$content += "<td style=`"width:100px;text-align:right`">$num</td>"
			$content += "<td><a href=`"adrep.ps1?a=user&d=$dx`">$dx days</a></td>"
			$content += "</tr>"
		}
		$content += "<tr><td style=`"width:100px;text-align:right`">"
		$content += "$($dusers.Count)</td><td><a href=`"adusersdisabled.ps1?p=1`">Disabled user accounts</a></td></tr>"
		$content += "<tr><td style=`"width:100px;text-align:right`">"
		$content += "$($noexp.Count)</td><td><a href=`"aduserpwdexp.ps1?p=0`">Password never expires</a></td></tr>"
		$content += "<tr><td style=`"width:100px;text-align:right`">"
		$content += "$($exps.Count)</td><td><a href=`"aduserpwdexp.ps1?p=1`">Password expires within 14 days</a></td></tr>"
		$content += "</table>"

	$content += "</td><td style=`"width:50%;vertical-align:top`">"
	$laststep = "compiling table 2 of 2"

		$content += "<h2>Computer Accounts</h2>"

		$content += "<table id=table1>"
		$content += "<tr><th>Computers</th><th>Days since last login</th></tr>"
		foreach ($dx in $dayslist) {
			$content += "<tr>"
			$num = ($mDates | Foreach-Object {(New-TimeSpan -Start $_ -End $(Get-Date)).Days} | Where-Object {$_ -gt $dx}).Count
			$content += "<td style=`"width:100px;text-align:right`">$num</td>"
			$content += "<td><a href=`"adrep.ps1?a=computer&d=$dx`">$dx days</a></td>"
			$content += "</tr>"
		}
		$content += "</table>"

	$content += "</td></tr></table>"
}
catch {
	$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)<br/>Last step: $laststep</td></tr></table>"
}

Write-SkWebContent
