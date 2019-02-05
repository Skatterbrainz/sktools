Get-SkParams

$PageTitle   = "AD Environment Summary"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = "addashboard.ps1"
$queryfile = "query.sql"

function Write-SkPieChart2 {
	param (
		[parameter(Mandatory=$True)]
		[string] $Title,
		[parameter(Mandatory=$False)]
		[int] $ChartWidth  = 400,
		[parameter(Mandatory=$False)]
		[int] $ChartHeight = 250,
		[hashtable] $DataTable,
		[int] $ChartID = 1
	)
	try {
		$columnNames = $DataTable.Keys
		$cdata = '[' + $(($columnNames | %{ "'$_'" }) -join ',') + '],'
		$rowcount = $DataTable.Keys.Count
		$index = 0
		$DataTable.Keys | %{
			$cdata += "`n   ['$_', $($DataTable.item($_))]"
			if ($index -lt $rowcount) { $cdata += "," }
			$index++
		}
		if ($SkTheme -eq 'stdark.css') {
			$bgcolor     = '#343e4f'
			$colors      = "['red','blue','green']"
			$titleStyle  = "{color: 'white'}"
			$legendStyle = "{color: 'white'}"
		}
		else {
			$bgcolor     = '#fff'
			$colors      = "['red','blue','green']"
			$titleStyle  = "{color: 'black'}"
			$legendStyle = "{color: 'white'}"
		}
		$output = "<div id=`"piechart$ChartID`"></div>
		<script type=`"text/javascript`" src=`"https://www.gstatic.com/charts/loader.js`"></script>
		<script type=`"text/javascript`">
		google.charts.load('current', {'packages':['corechart']});
		google.charts.setOnLoadCallback(drawChart);
		
		function drawChart() {
			var data = google.visualization.arrayToDataTable([
				$cdata
			]);
			var options = {
				'title':'$Title', 
				'width':$ChartWidth, 
				'height':$ChartHeight,
				'backgroundColor': '$bgcolor',
				'titleTextStyle': $titleStyle,
				'legend': {textStyle: $legendStyle},
				'colors': $colors,
				'pieHole': .5,
				'is3D': false,
				'sliceVisibilityThreshold': .2
			};
			var chart = new google.visualization.PieChart(document.getElementById('piechart$ChartID'));
			chart.draw(data, options);
		}
		</script>"
	}
	catch {
		$output = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
	}
	finally {
		Write-Output $output
	}
}

try {
	
	$adusers   = Get-SkAdUsers
	$adgroups  = Get-SkAdGroups
	$adcomps   = Get-SkAdComputers
	$adusernum = $adusers.Count
	$adcompnum = $adcomps.Count
	$dataset1 = [ordered]@{
		ADComputers = $adcompnum
		ADUsers     = $adusernum
	}
	$rat = [math]::Round($adusernum / $adcompnum, 1)
	$adratio = "$rat `: 1"
	$chart1 = Write-SkPieChart2 -Title "Accounts Ratio" -DataTable $dataset1 -ChartID 1 -ChartWidth 400 -ChartHeight 300
	$content = "<table id=table2>
		<tr style=`"vertical-align:top;width:50%`">
			<td>
				<h3>Computers and Users</h3>
				<table id=table2>
					<tr><td><a href=`"adcomputers.ps1?f=name&tab=All`">Active Directory Computers</a></td><td style=`"text-align:right`">$adcompnum</td></tr>
					<tr><td><a href=`"adusers.ps1?f=username&tab=All`">Active Directory Users</a></td><td style=`"text-align:right`">$adusernum</td></tr>
					<tr><td>Ratio (Users to Devices)</td><td style=`"text-align:right`">$adratio</td></tr>
				</table>
			</td>
			<td style=`"width:50%`">
				$chart1
			</td>
		</tr>
		</table>"
	
}
catch {
	$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
}

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
	$content += "<table style=`"width:100%;border:none`"><tr>"
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
