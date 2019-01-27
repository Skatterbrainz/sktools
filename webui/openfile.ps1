$PageTitle = "File Viewer"
$FilePath = Get-SkPageParam -TagName 'path' -Default ""
$tabset  = ""
$content = ""

function Get-SkLogData {
	param ($FilePath)
	try {
		Get-Content -Path $FilePath -ErrorAction Stop |
			Foreach-Object {
				# parse one log row (entry) at a time
				$parts = $_ -split '><'
				if ($parts.Count -gt 1) {
					$len = $parts[0].ToString().Length
					$msg = $($parts[0].ToString().Substring(7, $len-13))
					$dat = $parts[1] -split ' '
					$rowdate = $($dat[1] -split '=')[1] -replace '\"',''
					$rowtime = $($dat[0] -split '=')[1] -replace '\"',''
					$rowcomp = $($dat[2] -split '=')[1] -replace '\"',''
				}
				else {
					$rowdate = $null
					$rowtime = $null
					$rowcomp = $null
					$msg = $parts.Trim()
				}
				$props = [ordered]@{
					Date      = $rowdate
					Time      = $rowtime
					Component = $rowcomp
					Message   = $msg
				}
				New-Object PSObject -Property $props
			}
	}
	catch {
		return "Shit blew up"
	}
}

if ([string]::IsNullOrEmpty($FilePath)) {
	$content = "<table id=table2><tr><td>Error: File Path was not provided</td></tr></table>"
}
else {
	try {
		if (Test-Path $FilePath) {
			$fdata = Get-SkLogData -FilePath $FilePath
			$content = "<table>"
			$fdata | % {
				$content += "<tr>"
				$_ | %{ $content += "<td>$_</td>"}
				$content += "</tr>"
			}
			$content += "</table>"
		}
		else {
			$content = "<table id=table2><tr><td>Error: $FilePath could not be accessed</td></tr></table>"
		}
	}
	catch {
		$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
	}
}

@"
<html>
<head>
<style type="text/css">
td {
	font-family: verdana;
	font-size: 9pt;
}
</style>
</head>
<body>
$content
</body>
</html>
"@
