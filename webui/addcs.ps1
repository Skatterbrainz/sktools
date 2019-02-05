Get-SkParams

$PageTitle   = "AD Domain Controllers"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition

function Get-SkAdDomainControllers {
	[CmdletBinding()]
	param()
	try {
		$dcs = @()
		$domain = [System.Directoryservices.Activedirectory.Domain]::GetCurrentDomain() 
		$domain | ForEach-Object {$_.DomainControllers} | ForEach-Object { $dcs += $_.Name }
		$dcs | % {
			$na = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $_ -ErrorAction SilentlyContinue |
				Where-Object {$_.IPEnabled -eq $True}
			$dt = Invoke-Command -ComputerName $_ -ScriptBlock {Get-Date}
			$props = [ordered]@{
				ComputerName = $_ 
				IPAddress    = $na.IPAddress
				MACAddress   = $na.MACAddress
				Gateway      = $na.DefaultIPGateway
				DNSServers   = $na.DNSServerSearchOrder
				DateAndTime  = $dt
			}
			New-Object PSObject -Property $props
		}
	}
	catch {
		$Error[0].Exception.Message
	}
}

try {
	$counter = 0
	$dcs = Get-SkAdDomainControllers
	$content = "<table id=table1>"
	$content += "<tr><th>Name</th><th>IP Address</th><th>MAC</th><th>Gateway</th><th>DNS Servers</th><th>Local Time</th></tr>"
	foreach ($dc in $dcs) {
		$dcn = $($dc.ComputerName -split '\.')[0]
		$xlink = "<a href=`"adcomputer.ps1?f=name&v=$dcn&x=equals`">$($dc.ComputerName)</a>"
		$content += "<tr>
			<td>$xlink</td>
			<td>$($dc.IPAddress -join '<br/>')</td>
			<td>$($dc.MACAddress)</td>
			<td>$($dc.Gateway -join '<br/>')</td>
			<td>$($dc.DNSServers -join '<br/>')</td>
			<td>$($dc.DateAndTime)</td>
			</tr>"
		$counter++
	}
	$content += "<tr><td colspan=`"6`" class=`"lastrow`">$counter names found</td></tr></table>"
}
catch {}
finally {
	Write-SkWebContent
}
