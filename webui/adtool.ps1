$DeviceName = Get-SkPageParam -TagName 'c' -Default ""
$ToolName   = Get-SkPageParam -TagName 't' -Default ""
$CallSource = Get-SkPageParam -TagName 'cs' -Default ""
if ($CallSource -eq 'ad') {
	$ReturnLink = "<a href=`"adcomputer.ps1?f=name&v=$DeviceName&n=$DeviceName&tab=Tools`">Return</a>"
}
else {
	$ReturnLink = "<a href=`"cmdevice.ps1?f=name&v=$DeviceName&n=$DeviceName&tab=Tools`">Return</a>"
}

$result = ""

try {
	switch ($ToolName) {
		'gpupdate' {
			$cmd = 'c:\windows\system32\gpupdate.exe /FORCE'
			$output = Invoke-Command -ComputerName $DeviceName -ScriptBlock { $cmd } -ErrorAction SilentlyContinue
			break;
		}
		'gpresult' {
			$cmd = 'c:\windows\system32\gpresult.exe /H c:\windows\temp\'+$DeviceName+'_gpresult.html'
			$output = Invoke-Command -ComputerName $DeviceName -ScriptBlock { $cmd } -ErrorAction SilentlyContinue
			break;
		}
		'ccmrepair' {
			$cmd = 'c:\windows\ccm\ccmrepair.exe'
			$output = Invoke-Command -ComputerName $DeviceName -ScriptBlock { $cmd } -ErrorAction SilentlyContinue
			break;
		}
		'restart' {
			$cmd = ""
			Restart-Computer -ComputerName $DeviceName -Force -ErrorAction SilentlyContinue
			$output = 'Success'
			break;
		}
		'shutdown' {
			$cmd = ""
			Stop-Computer -ComputerName $DeviceName -Force -ErrorAction SilentlyContinue
			$output = 'Success'
			break;
		}
		'cancelshutdown' {
			$output = Invoke-Command -ComputerName $DeviceName -ScriptBlock { 'c:\windows\system32\shutdown.exe /a' } -ErrorAction SilentlyContinue
			break;
		}
	}

	if ($cmd -ne "") {
		$output = Invoke-Command -ComputerName $DeviceName -ScriptBlock { $cmd } -ErrorAction SilentlyContinue
	}
}
catch {
	$output = "Failed: $($Error[0].Exception.Message)"
}
finally {
	$content = "<table id=table2><tr><td>Command: $cmd<br/>Result: $result<br/><br/>$ReturnLink</td></tr></table>"
	Write-SkWebContent
}
