$DeviceName = Get-SkPageParam -Tagname 'c' -Default ""
$ToolName   = Get-SkPageParam -Tagname 't' -Default ""

$ReturnLink = "<a href=`"adcomputer.ps1?v=$DeviceName&tab=Tools`">Return</a>"

$result = ""

switch ($ToolName) {
    'gpupdate' {
		$cmd = 'GPUPDATE.exe /FORCE'
		break;
	}
	'ccmrepair' {
		$cmd = 'c:\windows\ccm\ccmrepair.exe'
		break;
	}
	'restart' {
		$cmd = ""
		try {
			Restart-Computer -ComputerName $DeviceName -Force -ErrorAction SilentlyContinue
			$output = 'Success'
		}
		catch {
			$output = "Failed: $($Error[0].Exception.Message)"
		}
		break;
	}
}

if ($cmd -ne "") {
	try {
		$output = Invoke-Command -ComputerName $DeviceName -ScriptBlock { $cmd } -ErrorAction SilentlyContinue
	}
	catch {
		$output = "Failed: $($Error[0].Exception.Message)"
	}
}
$result = "Result = $output"
$content = "<table id=table2><tr><td>$result<br/><br/>$ReturnLink</td></tr></table>"

Write-SkWebContent
