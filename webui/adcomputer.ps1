Get-SkParams

$PageTitle   = "AD Computer"
if (![string]::IsNullOrEmpty($Script:SearchValue)) {
    $PageTitle += ": $($Script:SearchValue)"
}
$content  = ""
$menulist = ""
$tabset   = ""
$pagelink = Split-Path -Leaf $MyInvocation.MyCommand.Definition

$plist = @('General','BIOS','Computer','Disks','Events - Application','Events - System','Local Groups','Local Users','Network','Operating System','Processor','Software','Startup','Updates','User Profiles','Tools')
$menulist = New-SkMenuList -PropertyList $plist -TargetLink "adcomputer.ps1?v=$Script:SearchValue" -Default $Script:TabSelected
$tabset   = $menulist

switch ($Script:TabSelected) {
    'General' {
        try {
            $cdata = Get-SkAdComputers -ComputerName $Script:SearchValue
            #$cdata = Get-ADsComputer -Name $Script:SearchValue
            $content = "<table id=table2>"
            $content += "<tr><td class=`"t2td1`">Name</td><td class=`"t2td2`">$($cdata.Name)</td></tr>"
            $content += "<tr><td class=`"t2td1`">DNS Name</td><td class=`"t2td2`">$($cdata.DnsName)</td></tr>"
            $content += "<tr><td class=`"t2td1`">LDAP Path</td><td class=`"t2td2`">$($cdata.DN)</td></tr>"
            $content += "<tr><td class=`"t2td1`">OS</td><td class=`"t2td2`">$($cdata.OS)</td></tr>"
            $content += "<tr><td class=`"t2td1`">Date Created</td><td class=`"t2td2`">$($cdata.Created)</td></tr>"
            $content += "<tr><td class=`"t2td1`">Last Login</td><td class=`"t2td2`">$($cdata.LastLogon)</td></tr>"
            if ($cdata.SPNlist.Count -gt 0) {
                $spnlist = $cdata.SPNlist -join "</br>"
                $content += "<tr><td class=`"t2td1`">SPNs</td>"
                $content += "<td class=`"t2td2`">$spnlist</td></tr>"
            }
            $content += "</table>"
        }
        catch {
            $content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
    'Computer' {
        try {
            $content = Get-SkWmiPropTableSingle -ComputerName $Script:SearchValue -WmiClass "Win32_ComputerSystem"
        }
        catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
    'Disks' {
        try {
            $content = Get-SkWmiPropTableMultiple -ComputerName $Script:SearchValue -WmiClass "Win32_LogicalDisk" -Columns ('DeviceID','DriveType','VolumeName','Size','FreeSpace') -SortField "DeviceID"
        }
        catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
    'BIOS' {
        try {
            $content = Get-SkWmiPropTableSingle -ComputerName $Script:SearchValue -WmiClass "Win32_BIOS"
        }
        catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
    'Events - Application' {
        $limit = 50
        $hrs = 24
        $afterdate = (Get-Date).AddHours(-$hrs)
        $logname = 'Application'
        try {
            $sysevents = Get-EventLog -LogName $logname -ComputerName $Script:SearchValue -Newest $limit -EntryType Error -ErrorAction Stop
            $sysevents = $sysevents | Where-Object {$_.TimeGenerated -gt $afterdate}
            $content = "<table id=table2>"
            $content += "<tr><th>Index</th><th>Time</th><th>Type</th><th>Category</th><th>Source</th><th>Message</th></tr>"
            if ($sysevents.Count -gt 0) {
                foreach ($event in $sysevents) {
                    $content += "<tr>"
                    $content += "<td>$($event.Index)</td>"
                    $content += "<td>$($event.TimeGenerated)</td>"
                    $content += "<td>$($event.EntryType)</td>"
                    $content += "<td>$($event.Category)</td>"
                    $content += "<td>$($event.Source)</td>"
                    $content += "<td>$($event.Message)</td>"
                    $content += "</tr>"
                }
                $content += "<tr><td colspan=`"6`" class=`"lastrow`">$($sysevents.Count) events</td></tr>"
            }
            else {
                $content += "<tr><td colspan=`"6`"> No $logname error events were found in the last $hrs hours</td></tr>"
            }
            $content += "</table>"
        }
        catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
    'Events - System' {
        $limit = 50
        $hrs = 24
        $afterdate = (Get-Date).AddHours(-$hrs)
        $logname = 'System'
        try {
            $sysevents = Get-EventLog -LogName $logname -ComputerName $Script:SearchValue -Newest $limit -EntryType Error -ErrorAction Stop
            $sysevents = $sysevents | Where-Object {$_.TimeGenerated -gt $afterdate}
            $content = "<table id=table2>"
            $content += "<tr><th>Index</th><th>Time</th><th>Type</th><th>Category</th><th>Source</th><th>Message</th></tr>"
            if ($sysevents.Count -gt 0) {
                foreach ($event in $sysevents) {
                    $content += "<tr>"
                    $content += "<td>$($event.Index)</td>"
                    $content += "<td>$($event.TimeGenerated)</td>"
                    $content += "<td>$($event.EntryType)</td>"
                    $content += "<td>$($event.Category)</td>"
                    $content += "<td>$($event.Source)</td>"
                    $content += "<td>$($event.Message)</td>"
                    $content += "</tr>"
                }
                $content += "<tr><td colspan=`"6`" class=`"lastrow`">$($sysevents.Count) events</td></tr>"
            }
            else {
                $content += "<tr><td colspan=`"6`"> No $logname error events were found in the last $hrs hours</td></tr>"
            }
            $content += "</table>"
        }
        catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
    'Network' {
        try {
            $content = Get-SkWmiPropTableMultiple -ComputerName $Script:SearchValue -WmiClass "Win32_NetworkAdapterConfiguration" -Columns ('Index','Description','IPEnabled','DHCPEnabled','IPAddress','DefaultIPGateway','DNSDomain','ServiceName') -SortField 'Index'
        }
        catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
    'Operating System' {
        try {
            $content = Get-SkWmiPropTableSingle -ComputerName $Script:SearchValue -WmiClass "Win32_OperatingSystem"
            #$content = Get-SkWmiPropTableSingle -ComputerName $Script:SearchValue -WmiClass "Win32_OperatingSystem" -Columns ("Caption","Build","Version") -SortField 'Caption'
        }
        catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
    'Processor' {
        try {
            $content = Get-SkWmiPropTableMultiple -ComputerName $Script:SearchValue -WmiClass "Win32_Processor" -Columns ('DeviceID','Caption','Manufacturer','MaxClockSpeed') -SortField 'Caption'
        }
        catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
    'Software' {
        try {
            $content = Get-SkWmiPropTableMultiple -ComputerName $Script:SearchValue -WmiClass "Win32_Product" -Columns ('Name','Vendor','Version','PackageCode') -SortField 'Name'
        }
        catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
	'Updates' {
        try {
            $content = Get-SkWmiPropTableMultiple -ComputerName $Script:SearchValue -WmiClass "Win32_QuickFixEngineering" -Columns ('HotFixID','Description','FixComments','Caption','InstallDate','InstalledBy') -SortField 'HotFixID'
        }
        catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
		break;
	}
    'Local Groups' {
        try {
            $content = (Get-WmiObject -Class "Win32_Group" -ComputerName $SearchValue -Filter "Domain = '$SearchValue'" | Select Name,Description,SID | Sort-Object Name | ConvertTo-Html -Fragment) -replace '<table>','<table id=table1>'
        }
        catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
	'Local Users' {
		try {
			$users = @(Get-WmiObject -Class "Win32_UserAccount" -ComputerName $SearchValue -Filter "Domain = '$SearchValue'" -ErrorAction SilentlyContinue)
			$content = "<table id=table1>"
			$content += "<tr><td>Name</td><td>Description</td><td>SID</td><td>Type</td></tr>"
			foreach ($user in $users) {
				$content += "<tr>"
				$content += "<td>$($user.Name)</td>"
				$content += "<td>$($user.Description)</td>"
				$content += "<td>$($user.SID)</td>"
				$content += "<td>$($user.AccountType)</td>"
				$content += "</tr>"
			}
			$content += "</table>"
		}
		catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
		}
		break;
	}
    'Startup' {
        try {
            $content = Get-SkWmiPropTableMultiple -ComputerName $SearchValue -WmiClass "Win32_StartupCommand" -Columns ('Name','Description','Command','Location') -SortField 'Name'
        }
        catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
    'User Profiles' {
        try {
            $content = Get-SkWmiPropTableMultiple -ComputerName $SearchValue -WmiClass "Win32_UserProfile" -Columns ('LocalPath','LastUseTime','Special','RoamingConfigured') -SortField 'LocalPath'
        }
        catch {
			$content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
    'Ping' {
        try {
            $tconn = Test-NetConnection -ComputerName $SearchValue -InformationLevel Detailed
            $content = "<table id=table2>"
            $content += "<tr><td>Ping Succeeded</td><td>$($tconn.PingSucceeded)</td></tr>"
            $content += "<tr><td>RemoteAddress</td><td>$($tconn.RemoteAddress)</td></tr>"
            $content += "<tr><td>NameResolutionResults</td><td>$($tconn.NameResolutionResults)</td></tr>"
            $content += "<tr><td>InterfaceAlias</td><td>$($tconn.InterfaceAlias)</td></tr>"
            #$content += "<tr><td>SourceAddress</td><td>$($tconn.SourceAddress)</td></tr>"
            #$content += "<tr><td>NetRoute (NextHop)</td><td>$($tconn.'NetRoute (NextHop)')</td></tr>"
            #$content += "<tr><td>PingReplyDetails (RTT)</td><td>$($tconn.'PingReplyDetails (RTT)')</td></tr>"
            $content += "</table>"
        }
        catch {
            $content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
        break;
    }
    'Tools' {
		$content = Write-SkRemoteTools -ComputerName $SearchValue -CallSource 'ad'
        <#
		$content = "<table id=table2><tr><td><ul>"
        $content += "<li><a href=`"adtool.ps1?t=gpupdate&c=$SearchValue`">Invoke Group Policy Update (GPUPDATE)</a></li>"
        $content += "<li><a href=`"adtool.ps1?t=ccmrepair&c=$SearchValue`">CCM Client Repair (CCMRepair)</a></li>"
        $content += "<li><a href=`"adtool.ps1?t=restart&c=$SearchValue`">Restart Computer (Restart)</a></li>"
        $content += "</ul></td></tr></table>"
        #>
		break;
    }
} # switch


Write-SkWebContent