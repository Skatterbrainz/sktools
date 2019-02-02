$PageTitle = "Active Directory"
$content   = ""
$menulist  = ""
$tabset    = ""
$pagelink  = Split-Path -Leaf $MyInvocation.MyCommand.Definition

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
	$chart1 = Write-SkPieChart2 -Title "Accounts Ratio" -DataTable $dataset1 -ChartID 1 -ChartWidth 450 -ChartHeight 250
	$content = "<table id=table2>
		<tr style=`"vertical-align:top`">
			<td>
				<h3>Computers</h3>
				<table id=table2>
					<tr><td><a href=`"adcomputers.ps1?f=name&tab=All`">Active Directory Computers</a></td><td style=`"text-align:right`">$adcompnum</td></tr>
					<tr><td><a href=`"adusers.ps1?f=username&tab=All`">Active Directory Users</a></td><td style=`"text-align:right`">$adusernum</td></tr>
					<tr><td>Ratio (Users to Devices)</td><td style=`"text-align:right`">$adratio</td></tr>
				</table>
			</td>
			<td>
				$chart1
			</td>
		</tr>
		</table>"
	
}
catch {
	$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
}

Write-SkWebContent