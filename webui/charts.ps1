Get-SkParams
$SearchValue = "Operating Systems"

$PageTitle   = "Charts"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $Script:SearchValue"
}
$content   = ""
$menulist  = ""
$tabset    = ""

function Write-SkPieChart {
	param (
		[parameter(Mandatory=$False)]
		[string] $Query = "",
		[parameter(Mandatory=$False)]
		[string] $QueryFile = "",
		[parameter(Mandatory=$True)]
		[string] $Title,
		[parameter(Mandatory=$False)]
		[int] $ChartWidth  = 600,
		[parameter(Mandatory=$False)]
		[int] $ChartHeight = 450
	)
	try {
		if ($QueryFile -ne "") {
			if (Test-Path $QueryFile) {
				$qfile = $QueryFile
			}
			else {
				if (Test-Path (Join-Path -Path $PSScriptRoot -ChildPath "reports\$QueryFile")) {
					$qfile = (Join-Path -Path $PSScriptRoot -ChildPath "reports\$QueryFile")
					$dataset = @(Invoke-DbaQuery -SqlInstance $SkCmDbHost -Database "CM_$SkCmSiteCode" -File $qfile)
				}
				else {
					throw "$QueryFile not found"
				}
			}
		}
		elseif ($Query -ne "") {
			$dataset = @(Invoke-DbaQuery -SqlInstance $SkCmDbHost -Database "CM_$SkCmSiteCode" -Query $query)
		}
		else {
			throw "Query and QueryFile parameters cannot both be null"
		}
		$columnNames = $dataset[0].Table.Columns.ColumnName
		$cdata = '[' + $(($columnNames | %{ "'$_'" }) -join ',') + '],'
		$rowcount = $dataset.count
		$index = 0
		foreach ($row in $dataset) {
			$cdata += "`n  ['$($row.item(0))', $($row.item(1))]"
			if ($index -lt $rowcount) { $cdata += "," }
			$index++
		}
		$output = "<div id=`"piechart`"></div>
		<script type=`"text/javascript`" src=`"https://www.gstatic.com/charts/loader.js`"></script>
		<script type=`"text/javascript`">
		google.charts.load('current', {'packages':['corechart']});
		google.charts.setOnLoadCallback(drawChart);
		
		function drawChart() {
			var data = google.visualization.arrayToDataTable([
				$cdata
			]);
			var options = {
				'title':'$PageTitle', 
				'width':$ChartWidth, 
				'height':$ChartHeight,
				'pieHole': .5,
				'sliceVisibilityThreshold': .2,
				'is3D': true
			};
			var chart = new google.visualization.PieChart(document.getElementById('piechart'));
			chart.draw(data, options);
		}
		</script>"
		# end of try block
	}
	catch {
		$output = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
	}
	finally {
		Write-Output $output
	}
}

function Write-SkBarChart {
	param (
		[parameter(Mandatory=$False)]
		[string] $Query = "",
		[parameter(Mandatory=$False)]
		[string] $QueryFile = "",
		[parameter(Mandatory=$True)]
		[string] $Title,
		[parameter(Mandatory=$False)]
		[int] $ChartWidth  = 600,
		[parameter(Mandatory=$False)]
		[int] $ChartHeight = 450
	)
	try {
		if ($QueryFile -ne "") {
			if (Test-Path $QueryFile) {
				$qfile = $QueryFile
			}
			else {
				if (Test-Path (Join-Path -Path $PSScriptRoot -ChildPath "reports\$QueryFile")) {
					$qfile = (Join-Path -Path $PSScriptRoot -ChildPath "reports\$QueryFile")
					$dataset = @(Invoke-DbaQuery -SqlInstance $SkCmDbHost -Database "CM_$SkCmSiteCode" -File $qfile)
				}
				else {
					throw "$QueryFile not found"
				}
			}
		}
		elseif ($Query -ne "") {
			$dataset = @(Invoke-DbaQuery -SqlInstance $SkCmDbHost -Database "CM_$SkCmSiteCode" -Query $query)
		}
		else {
			throw "Query and QueryFile parameters cannot both be null"
		}
		$columnNames = $dataset[0].Table.Columns.ColumnName
		$cdata = '[' + $(($columnNames | %{ "'$_'" }) -join ',') + '],'
		$rowcount = $dataset.count
		$index = 0
		foreach ($row in $dataset) {
			$cdata += "`n  ['$($row.item(0))', $($row.item(1))]"
			if ($index -lt $rowcount) { $cdata += "," }
			$index++
		}
		$output = "<div id=`"barchart`"></div>
		<script type=`"text/javascript`" src=`"https://www.gstatic.com/charts/loader.js`"></script>
		<script type=`"text/javascript`">
		google.charts.load('current', {'packages':['corechart']});
		google.charts.setOnLoadCallback(drawChart);
		
		function drawChart() {
			var data = google.visualization.arrayToDataTable([
				$cdata
			]);
			var options = {
				'title':'$PageTitle', 
				'width':$ChartWidth, 
				'height':$ChartHeight,
				'is3D': true
			};
			var chart = new google.visualization.BarChart(document.getElementById('barchart'));
			chart.draw(data, options);
		}
		</script>"
		# end of try block
	}
	catch {
		$output = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
	}
	finally {
		Write-Output $output
	}
}

#$query = "SELECT DISTINCT Caption0 AS Name, COUNT(*) AS Clients FROM v_GS_OPERATING_SYSTEM GROUP BY Caption0 ORDER BY Caption0"
#$content = Write-SkPieChart -Query $query -Title $SearchValue
$content = Write-SkPieChart -QueryFile "Software - Windows Update Client Versions.sql" -Title "Windows Update Clients"
$content += Write-SkBarChart -QueryFile "Software - Windows Update Client Versions.sql" -Title "Windows Update Clients"
Write-SkWebContent