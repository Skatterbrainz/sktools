function Import-SkConfig {
	[CmdletBinding()]
	param (
		[parameter(Mandatory=$True)]
		[ValidateNotNullOrEmpty()]
		[string] $Path
    )
    $configFile = "$($env:USERPROFILE)\Documents\skconfig.txt"
	if (!(Test-Path $configFile)) {
		Write-Warning "$configFile was not found. Shit just got real."
		break
	}
	Write-Verbose "loading $configfile"
	$cdata = Get-Content $configFile | 
		Where-Object{$_ -notlike '_*'}
			foreach ($line in $cdata) {
				$varset = $line -split '='
				if ($varset.Count -gt 1) {
                    $vname = $($varset[0]).Trim()
                    $vdata = $($varset[1]).Trim()
					if (!(Get-Variable -Name $vname -ErrorAction SilentlyContinue)) {
						Set-Variable -Name $vname -Value $vdata -Scope Global -Force | Out-Null
					}
				}
            }
    $Global:SkPath = Split-Path $(Get-Module sktools).Path
    $Global:SkQueryPath = Join-Path $Global:SkPath -ChildPath "queries"
    $Global:SkReportsPath = Join-Path $Global:SkPath -ChildPath "reports"
    $Global:SkWebPath = Join-Path $Global:SkPath -ChildPath "webui"
}

#---------------------------------------------------------------------
# DATABASE FUNCTIONS

function Get-SkQueryTableSingle {
    param (
        [parameter(Mandatory=$True)]
			[ValidateNotNullOrEmpty()]
			[string] $QueryFile,
        [parameter(Mandatory=$True)]
			[ValidateNotNullOrEmpty()]
			[string] $PageLink,
        [parameter(Mandatory=$False)]
			[string[]] $Columns = ""
    )
    $output = $null
    $result = $null
    $Script:xxx = "$SearchField = $SearchValue"
    try {
        #$qpath  = $(Join-Path -Path $Global:SkQueryPath -ChildPath "queries")
        $qfile  = $(Join-Path -Path $Global:SkQueryPath -ChildPath "$QueryFile")
        $result = @(Invoke-DbaQuery -SqlInstance $SkCmDbHost -Database "CM_$SkCmSiteCode" -File $qfile)
        if ([string]::IsNullOrEmpty($SearchField) -and ![string]::IsNullOrEmpty($SearchValue)) {
            $SearchField = $($result[0].Table.Columns.ColumnName)[0]
            $Script:xxx = "Searchfield remapped to $SearchField"
            $result = $result | Where-Object {$_."$SearchField" -eq $SearchValue}
        }
        else {
            $result = $result | Where-Object {$_."$SearchField" -eq $SearchValue}
        }
        if (![string]::IsNullOrEmpty($Columns)) {
            $result   = $result | Select $Columns
            $colcount = $Columns.Count
        }
        else {
            $columns  = $result[0].Table.Columns.ColumnName
            $result   = $result | Select $Columns
            $colcount = $columns.Count
        }
        $output   = "<table id=table2>"
        foreach ($rs in $result) {
            for ($i = 0; $i -lt $rs.psobject.Properties.Name.Count; $i++) {
                $fn  = $rs.psobject.Properties.Name[$i]
                $fv  = $rs.psobject.Properties.Value[$i]
                $fvx = Get-SKDbValueLink -ColumnName $fn -Value $fv
                $output += "<tr><td style=`"width:200px;background-color:#435168`">$fn</td><td>$fvx</td></tr>"
            }
        }
        $output += "</table>"
    }
    catch {
        $output = "<table id=table2><tr><td>No matching items found<br/>queryfile: $qfile</td></tr></table>"
    }
    finally {
        Write-Output $output
    }
}

function Get-SkQueryTableMultiple {
    param (
        [parameter(Mandatory=$True)]
            [ValidateNotNullOrEmpty()]
            [string] $QueryFile,
        [parameter(Mandatory=$True)]
            [ValidateNotNullOrEmpty()]
            [string] $PageLink,
        [parameter(Mandatory=$False)]
            [string[]] $Columns = "",
        [parameter(Mandatory=$False)]
            [string] $Sorting = "",
        [parameter(Mandatory=$False)]
            [ValidateSet('asc','desc')]
            [string] $SortType = 'asc',
        [parameter(Mandatory=$False)]
            [switch] $ColumnSorting,
        [parameter(Mandatory=$False)]
            [switch] $NoUnFilter,
        [parameter(Mandatory=$False)]
            [switch] $NoCaption
    )
    $output = $null
    $result = $null
    $colcount = 0
    try {
        if (!(Test-Path $QueryFile)) {
            #$qpath  = $(Join-Path -Path $PSScriptRoot -ChildPath "queries")
            $qfile  = $(Join-Path -Path $Global:SkQueryPath -ChildPath "$QueryFile")
        }
        else {
            $qfile = $QueryFile
        }
        $result = @(Invoke-DbaQuery -SqlInstance $SkCmDbHost -Database "CM_$SkCmSiteCode" -File $qfile)
        if (![string]::IsNullOrEmpty($Script:SearchField)) {
            switch ($Script:SearchType) {
                'like' {
                    $result = $result | Where-Object {$_."$Script:SearchField" -like "*$Script:SearchValue*"}
                    break;
                }
                'begins' {
                    $result = $result | Where-Object {$_."$Script:SearchField" -like "$Script:SearchValue*"}
                    break;
                }
                'ends' {
                    $result = $result | Where-Object {$_."$Script:SearchField" -like "*$Script:SearchValue"}
                    break;
                }
                default {
                    $result = $result | Where-Object {$_."$Script:SearchField" -eq $Script:SearchValue}
                }
            }
            if (!$NoUnFilter -or !$NoCaption) {
                $Script:PageCaption += " ($Caption)"
            }
            $Script:IsFiltered = $True
        }
        if ($Sorting -ne "") {
            if ($SortType -eq 'desc') {
                $result = $result | Sort-Object $Sorting -Descending
            }
            else {
                $result = $result | Sort-Object $Sorting
            }
        }
        if (![string]::IsNullOrEmpty($Columns)) {
            $result = $result | Select $Columns
            $colcount = $Columns.Count
        }
        else {
            $columns = $result[0].Table.Columns.ColumnName
            $result = $result | Select $Columns
            $colcount = $columns.Count
        }
        $output = "<table id=table1><tr>"
        if ($colcount -gt 0 -and $ColumnSorting) {
            $output += New-SkTableColumnSortRow -ColumnNames $Columns -BaseLink "$PageLink`?f=$($Script:SearchField)&v=$($Script:SearchValue)&x=$($Script:SearchType)" -SortDirection $Script:SortOrder
        }
        else {
            $columns | Foreach-Object { $output += "<th>$_</th>" }
        }
        $output += "</tr>"
        $rowcount = 0
        foreach ($rs in $result) {
            $output += "<tr>"
            for ($i = 0; $i -lt $rs.psobject.Properties.Name.Count; $i++) {
                $fn = $rs.psobject.Properties.Name[$i]
                $fv = $rs.psobject.Properties.Value[$i]
                $align = ""
                $fvx   = Get-SKDbValueLink -ColumnName $fn -Value $fv
                $align = Get-SKDbCellTextAlign -ColumnName $fn
                if ($align -ne "") {
                    $output += "<td style=`"text-align`: $align`">$fvx</td>"
                }
                else {
                    $output += "<td>$fvx</td>"
                }
            } # for
            $output += "</tr>"
            $rowcount++
        } # foreach
        if ($rowcount -eq 0) {
            $output += "<tr><td colspan=$colcount>No results were returned</td></tr>"
        }
        $output += "<tr><td colspan=$colcount class=lastrow>$rowcount items"
        if ((!$NoUnFilter) -and ($Script:IsFiltered -eq $True)) {
            $output += " - <a href=`"$PageLink`" title=`"Show All`">Show All</a>"
        }
        $output += "</td></tr></table>"
    }
    catch {
        $output = "<table id=table2><tr><td>No matching items found"
        $output += "<br/>queryfile: $qfile"
        $output += "<br/>SearchField: $Script:SearchField"
        $output += "<br/>SearchValue: $Script:SearchValue"
        $output += "<br/>SearchType: $Script:SearchType"
        $output += "<br/>SortField: $Script:SortField"
        $output += "</td></tr></table>"
    }
    finally {
        Write-Output $output
    }
}

function Get-SKDbValueLink {
    param (
        [parameter(Mandatory=$True)]
			[ValidateNotNullOrEmpty()]
			[string] $ColumnName,
        [parameter(Mandatory=$False)]
			[string] $Value = ""
    )
    $output = ""
    if (![string]::IsNullOrEmpty($Value)) {
        switch ($ColumnName) {
            {($_ -eq 'Name') -or ($_ -eq 'ComputerName')} {
                $output = "<a href=`"cmdevice.ps1?f=$ColumnName&v=$Value&x=equals&n=$Value`" title=`"Details for $Value`">$Value</a>"
                $cnx = $Value
                break;
            }
            'ProfilePath' {
                if (![string]::IsNullOrEmpty($cnx)) {
                    $output = "<a href=`"file://$cnx/$($Value.Replace('C:','c$'))`" target=`"_new`">$Value</a>"
                }
                else {
                    $output = $Value
                }
                break;
            }
            'ADComputerName' {
                $output = "<a href=`"adcomputer.ps1?f=name&v=$Value&n=$Value&x=equals`" title=`"Details for $Value`">$Value</a>"
                break;
            }
            {($_ -eq 'OSName') -or ($_ -eq 'OperatingSystem')} {
                $output = "<a href=`"cmdevices.ps1?f=$ColumnName&v=$Value&x=equals&n=$Value`" title=`"Filter on $Value`">$Value</a>"
                break;
            }
            'OSBuild' {
                $output = "<a href=`"cmdevices.ps1?f=OSBuild&v=$Value&x=equals`" title=`"Computers running $Value`">$Value</a>"
                break;
            }
            {($_ -eq 'ADSiteName') -or ($_ -eq 'ADSite')} {
                $output = "<a href=`"cmdevices.ps1?f=$ColumnName&v=$Value&x=equals&n=$Value`" title=`"Filter on $Value`">$Value</a>"
                break;
            }
            'CollectionID' {
                $output = "<a href=`"cmcollection.ps1?f=collectionid&v=$Value&t=$Script:CollectionType&n=`" title=`"Details`">$Value</a>"
                break;
            }
            'CollectionName' {
                $output = "<a href=`"cmcollection.ps1?f=collectionname&v=$Value&t=$Script:CollectionType&n=$Value`" title=`"Details`">$Value</a>"
                break;
            }
            'LimitedTo' {
                $output = "<a href=`"cmcollection.ps1?f=$ColumnName&v=$Value&t=$CollectionType`" title=`"Details`">$Value</a>"
                break;
            }
            {($_ -eq 'UserName') -or ($_ -eq 'UserName0')} {
                $output = "<a href=`"cmuser.ps1?f=UserName&v=$Value&n=$Value`" title=`"Details`">$Value</a>"
                break;
            }
            'Department' {
                if (![string]::IsNullOrEmpty($Value)) {
                    $output = "<a href=`"cmusers.ps1?f=Department&v=$Value&x=equals`" title=`"Filter`">$Value</a>"
                }
                break;
            }
            'Title' {
                if (![string]::IsNullOrEmpty($Value)) {
                    $output = "<a href=`"cmusers.ps1?f=Title&v=$Value&x=equals`" title=`"Filter`">$Value</a>"
                }
                break;
            }
            'Manufacturer' {
                $output = "<a href=`"cmdevices.ps1?f=$ColumnName&v=$Value&x=equals&n=$Value`" title=`"Filter on $Value`">$Value</a>"
                break;
            }
            'Model' {
                $output = "<a href=`"cmdevices.ps1?f=$ColumnName&v=$Value&x=equals&n=$Value`" title=`"Filter on $Value`">$Value</a>"
                break;
            }
            {($_ -eq 'PackageID') -or ($_ -eq 'PkgId')} {
                $output = "<a href=`"cmpackage.ps1?f=packageid&v=$Value&x=equals`" title=`"Details`">$Value</a>"
                break;
            }
            'PackageType' {
                $output = "<a href=`"cmpackages2.ps1?f=packagetype&v=$Value&x=equals`" title=`"Filter on $Value`">$Value</a>"
                break;
            }
            'PkgSourcePath' {
                $output = "<a href=`"file://$Value`" target=`"_new`" title=`"Open Folder`">$Value</a>"
                break;
            }
            'ItemType' {
                $output = "<a href=`"cmdisc.ps1?f=itemtype&v=$Value&x=equals&n=$Value`" title=`"Details`">$Value</a>"
                break;
            }
            'BGName' {
                $output = "<a href=`"cmbgroup.ps1?f=bgname&v=$Value&x=equals&n=$Value`" title=`"Details`">$Value</a>"
                break;
            }
            {($_ -eq 'SiteStatus') -or ($_ -eq 'Status')} {
                $output = "<table style=`"width:100%;border:0;`"><tr><td style=`"background:$Value`"> </td></tr></table>"
                break;
            }
            'State' {
                $output = Get-SKDbCellTextColor -ColumnName $ColumnName -Value $Value 
                break;
            }
            'SiteSystem' {
                $output = ($Value -split '\\')[2]
                break;
            }
            'DPName' {
                $output = "<a href=`"cmserver.ps1?rc=dp&n=$Value`" title=`"Details for $Value`">$Value</a>"
                break;
            }
            'ComponentName' {
                $output = "<a href=`"cmcompstats.ps1?f=component&v=$Value&x=equals`">$Value</a>"
                break;
            }
            'QueryID' {
                $output = "<a href=`"cmquery.ps1?f=querykey&v=$Value&x=equals&n=$Value`" title=`"Details`">$Value</a>"
                break;
            }
            {($_ -eq 'SQL') -or ($_ -eq 'WQL')} {
                $output = $($Value -replace ' from', '<br/>from') -replace ' where','<br/>where'
                break;
            }
            {($_ -eq 'Error') -or ($_ -eq 'Errors')} {
                if ($Value -gt 0) {
                    $output = "<span style=`"color:red`">$Value</span>"
                }
                else {
                    $output = $Value
                }
                break;
            }
            'Approver' {
                ($Value -split '\\') | ForEach-Object {$unn = $_}
                $output = "<a href=`"aduser.ps1?f=username&v=$unn&x=equals`" title=`"User Account`">$Value</a>"
                break;
            }
            'Author' {
                ($Value -split '\\') | ForEach-Object {$aun = $_}
                $output = "<a href=`"cmscripts.ps1?f=author&v=$aun&x=contains`" title=`"Other scripts by $aun`">$Value</a>"
                break;
            }
            'DaysOfWeek' {
                $vlist = @{1 = 'Su'; 2 = 'M'; 4 = 'Tu'; 8 = 'W'; 16 = 'Th'; 32 = 'F'; 64 = 'Sa'}
                $output = ($vlist.Keys | where {$_ -band $Value} | sort-object | foreach {$vlist.Item($_)}) -join ', '
                break;
            }
            'DeleteOlderThan' {
                $output = "$Value days"
                break;
            }
            {($_ -eq 'DiskSize') -or ($_ -eq 'FreeSpace') -or ($_ -eq 'Used')} {
                $output = "$([math]::Round($Value / 1KB, 2)) GB"
                break;
            }
            'PCT' {
                $output = "$Value`%"
                break;
            }
            default {
                $output = $Value
                break;
            }
        } # switch
    }
    Write-Output $output
}

function Get-SKDbCellTextAlign {
    param (
        [parameter(Mandatory=$True)]
			[ValidateNotNullOrEmpty()]
			[string] $ColumnName
    )
    $output = ""
    $centerlist = ('LimitedTo','Members','Variables','Type','PackageID','LastContacted','MessageID','MessageType','Severity',
        'SiteCode','SiteSystem','TimeReported','Enabled','BeginTime','LatestBeginTime','BackupLocation','DeleteOlderThan',
        'PackageType','PkgType','SiteStatus','Status','State','Info','Warning','Error')
    $rightlist = ('DiskSize','FreeSpace','Used','PCT','Installs','Clients','QTY')
    if ($centerlist -contains $ColumnName) {
        $output = 'center'
    }
    elseif ($rightlist -contains $ColumnName) {
        $output = 'right'
    }
    Write-Output $output
}

function Get-SKDbCellTextColor {
    param (
        [parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $ColumnName,
        [parameter(Mandatory=$False)]
        $Value
    )
    $output = $Value
    $redlist = ('State=Stopped')
    if ($redlist -contains "$ColumnName`=$Value") {
        $output = "<span style=`"color:red`">$Value</span>"
    }
    Write-Output $output
}

function Get-SkCmCollectionName {
    param (
        [parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $CollectionID
    )
    $output = ""
    try {
        $output = (Invoke-DbaQuery -SqlInstance $SkCmDbHost -Database "CM_$SkCmSiteCode" -Query "select name from v_collection where collectionid = '$CollectionID'").Name
    }
    catch {}
    finally {
        Write-Output $output
    }
}

#---------------------------------------------------------------------
# ACTIVE DIRECTORY FUNCTIONS

function Get-SkAdUsers {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$False, HelpMessage="Optional user name")]
        [string] $UserName = ""
    )
    $pageSize = 1000
    if ([string]::IsNullOrEmpty($UserName)) {
        $as = [adsisearcher]"(objectCategory=User)"
    }
    else {
        $as = [adsisearcher]"(&(objectCategory=User)(sAMAccountName=$UserName))"
    }
    [void]$as.PropertiesToLoad.Add('cn')
    [void]$as.PropertiesToLoad.Add('sAMAccountName')
    [void]$as.PropertiesToLoad.Add('lastlogonTimeStamp')
    [void]$as.PropertiesToLoad.Add('whenCreated')
    [void]$as.PropertiesToLoad.Add('department')
    [void]$as.PropertiesToLoad.Add('title')
    [void]$as.PropertiesToLoad.Add('mail')
    [void]$as.PropertiesToLoad.Add('manager')
    [void]$as.PropertiesToLoad.Add('employeeID')
    [void]$as.PropertiesToLoad.Add('displayName')
    [void]$as.PropertiesToLoad.Add('distinguishedName')
    [void]$as.PropertiesToLoad.Add('memberof')
    $as.PageSize = $pageSize
    $results = $as.FindAll()
    foreach ($item in $results) {
        $cn = ($item.properties.item('cn') | Out-String).Trim()
        [datetime]$created = ($item.Properties.item('whenCreated') | Out-String).Trim()
        $llogon = ([datetime]::FromFiletime(($item.properties.item('lastlogonTimeStamp') | Out-String).Trim())) 
        $ouPath = ($item.Properties.item('distinguishedName') | Out-String).Trim() -replace $("CN=$cn,", "")
        $props  = [ordered]@{
            Name        = $cn
            UserName    = ($item.Properties.item('sAMAccountName') | Out-String).Trim()
            DisplayName = ($item.Properties.item('displayName') | Out-String).Trim()
            Title       = ($item.Properties.item('title') | Out-String).Trim()
            Department  = ($item.Properties.item('department') | Out-String).Trim()
            DN          = ($item.Properties.item('distinguishedName') | Out-String).Trim()
            EmployeeID  = ($item.Properties.item('employeeid') | Out-String).Trim()
            Email       = ($item.Properties.item('mail') | Out-String).Trim()
            Manager     = ($item.Properties.item('manager') | Out-String).Trim()
            Groups      = $item.Properties.item('memberof')
            OUPath      = $ouPath
            Created     = $created
            LastLogon   = $llogon
        }
        New-Object psObject -Property $props
    }
}

function Get-SkAdComputers {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$False, HelpMessage="Name of computer to query")]
        [string] $ComputerName = "",
        [parameter(Mandatory=$False, HelpMessage="Search type")]
        [ValidateSet('All','Disabled','Workstations','Servers')]
        [string] $SearchType = 'All'
    )
    $pageSize = 200
    if (![string]::IsNullOrEmpty($ComputerName)) {
        $as = [adsisearcher]"(&(objectCategory=Computer)(name=$ComputerName))"
    }
    else {
        switch ($SearchType) {
            'Disabled' {
                $as = [adsisearcher]"(&(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=2))"
                break
            }
            'Workstations' {
                $as = [adsisearcher]"(&(objectCategory=computer)(!operatingSystem=*server*))"
                break
            }
            'Servers' {
                $as = [adsisearcher]"(&(objectCategory=computer)(operatingSystem=*server*))"
                break
            }
            default {
                $as = [adsisearcher]"(objectCategory=computer)"
                break
            }
        }
    }
    [void]$as.PropertiesToLoad.Add('cn')
    [void]$as.PropertiesToLoad.Add('lastlogonTimeStamp')
    [void]$as.PropertiesToLoad.Add('whenCreated')
    [void]$as.PropertiesToLoad.Add('dnsHostName')
    [void]$as.PropertiesToLoad.Add('operatingSystem')
    [void]$as.PropertiesToLoad.Add('operatingSystemVersion')
    [void]$as.PropertiesToLoad.Add('distinguishedName')
    [void]$as.PropertiesToLoad.Add('servicePrincipalName')
    $as.PageSize = $pageSize
    $results = $as.FindAll()
    foreach ($item in $results) {
        $cn = ($item.properties.item('cn') | Out-String).Trim()
        [datetime]$created = ($item.Properties.item('whenCreated') | Out-String).Trim()
        $llogon = ([datetime]::FromFiletime(($item.properties.item('lastlogonTimeStamp') | Out-String).Trim())) 
        $ouPath = ($item.Properties.item('distinguishedName') | Out-String).Trim() -replace $("CN=$cn,", "")
        $props  = [ordered]@{
            Name       = $cn
            DnsName    = ($item.Properties.item('dnsHostName') | Out-String).Trim()
            OS         = ($item.Properties.item('operatingSystem') | Out-String).Trim()
            OSVer      = ($item.Properties.item('operatingSystemVersion') | Out-String).Trim()
            DN         = ($item.Properties.item('distinguishedName') | Out-String).Trim()
            OU         = $ouPath
            SPNlist    = ($item.Properties.item('servicePrincipalName'))
            Created    = $created
            LastLogon  = $llogon
        }
        New-Object psObject -Property $props
    }
}

function Get-SkAdGroups {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$False)]
        [string] $GroupName = ""
    )
    $pageSize = 200
    if ([string]::IsNullOrEmpty($GroupName)) {
        $as = [adsisearcher]"(objectCategory=Group)"
    }
    else {
        $as = [adsisearcher]"(&(objectCategory=Group)(name=$GroupName)"
    }
    $as.PropertiesToLoad.Add('name') | Out-Null
    $as.PropertiesToLoad.Add('description') | Out-Null
    $as.PropertiesToLoad.Add('whenCreated') | Out-Null
    $as.PropertiesToLoad.Add('whenChanged') | Out-Null
    $as.PropertiesToLoad.Add('distinguishedName') | Out-Null
    $as.PageSize = $pageSize
    $results = $as.FindAll()
    foreach ($item in $results) {
        $cn = ($item.properties.item('name') | Out-String).Trim()
        $ouPath = ($item.Properties.item('distinguishedName') | Out-String).Trim() -replace $("CN=$cn,", "")
        [datetime]$created = ($item.Properties.item('whenCreated') | Out-String).Trim()
        [datetime]$changed = ($item.Properties.item('whenChanged') | Out-String).Trim()
        $desc = ($item.Properties.item('description') | Out-String).Trim()
        $props  = [ordered]@{
            Name        = $cn
            DN          = ($item.Properties.item('distinguishedName') | Out-String).Trim()
            OU          = $ouPath
            Description = $desc
            Created     = $created
            Changed     = $changed
        }
        New-Object psObject -Property $props
    }
}

function Get-SkAdGroupMembers {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $GroupName
    )
    $group = Get-SkAdGroups | Where-Object {$_.name -eq $GroupName}
    if ($group) {
        Write-Verbose "group information found"
        $dn = $group.DN
        $gx = [adsi]"LDAP://$dn"
        $gx.member | Foreach-Object {
            $searcher = [adsisearcher]"(distinguishedname=$_)"
            $user = $searcher.FindOne().Properties
            $uname   = $($user.samaccountname | out-string).Trim()
            $created = [datetime]$($user.whencreated | Out-string).Trim() -f 'mm/DD/yyyy hh:mm'
            $udn     = $($user.distinguishedname | Out-string).Trim()
            if (($user.objectclass -join ',').Trim() -like "*group*") {
                $utype = 'Group'
            }
            else {
                $utype = 'User'
            }
            $utitle  = $($user.title | Out-String).Trim()
            $props = [ordered]@{
                UserName = $uname
                Created  = $created
                Type     = $utype
                DN       = $udn
                Title    = $utitle
            }
            New-Object PSObject -Property $props
        }
    }
    else {
        Write-Verbose "group was not found"
    }
}

function Get-SkAdUserGroups {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $UserName
    )
    try {
        $user = Get-SkAdUsers | Where-Object {$_.UserName -eq "$UserName"}
        $groups = $user.Groups
        $groups | ForEach-Object {
            $Searcher = [adsisearcher]"(distinguishedname=$_)"
            $group  = $searcher.FindOne().Properties
            $gprops = [ordered]@{
                Name = [string]$group.name
                DN   = [string]$group.distinguishedname
            }
            New-Object PSObject -Property $gprops
        }
    }
    catch {}
}

function Get-SkAdUserPwdExpirations {
    param ()
    try {
        $noexp = Get-SkAdUserPwdNoExpiration | Select -ExpandProperty UserName
        $domainname = $env:USERDOMAIN
        [adsi]$domain = "WinNT://$domainname"
        $mpwa = $($domain.MaxPasswordAge) / 86400
        $as = [adsisearcher]"(objectCategory=User)"
        [void]$as.PropertiesToLoad.Add('cn')
        [void]$as.PropertiesToLoad.Add('sAMAccountName')
        [void]$as.PropertiesToLoad.Add('lastlogonTimeStamp')
        [void]$as.PropertiesToLoad.Add('pwdLastSet')
        $as.PageSize = 1000
        $results = $as.FindAll()
        foreach ($item in $results) {
            $pwdset = ([datetime]::FromFiletime(($item.properties.item('pwdLastSet') | Out-String).Trim()))
            $pwdage = (New-TimeSpan -Start $pwdset -End (Get-Date)).Days
            $uname = $($item.properties.item('samaccountname') | Out-String).Trim()
            if ($uname -in $noexp) {
                $exp = 'Never'
            }
            else {
                $exp = $mpwa - $pwdage
            }
            $props = [ordered]@{
                UserName   = $uname
                LastPwdSet = $pwdset
                PwdAge     = $pwdage
                MaxPwAge   = $mpwa
                Expires    = $exp
            }
            New-Object PSObject -Property $props
        }
    }
    catch {}
}

function Get-SkAdUserPwdNoExpiration {
    param ()
    # https://richardspowershellblog.wordpress.com/2012/02/08/finding-user-accounts-with-passwords-set-to-never-expire/
    $root = [ADSI]""
    $search = [adsisearcher]$root
    [void]$search.PropertiesToLoad.Add('sAMAccountName')
    [void]$search.PropertiesToLoad.Add('distinguishedname')
    [void]$search.PropertiesToLoad.Add('name')
    $search.Filter = "(&(objectclass=user)(objectcategory=user)(useraccountcontrol:1.2.840.113556.1.4.803:=65536))"
    $search.SizeLimit = 3000
    $results = $search.FindAll()
    foreach ($result in $results){
        $result.Properties |
        Select @{N="Name"; E={$_.name}},@{N="UserName"; E={$_.samaccountname}},@{N="DistinguishedName"; E={$_.distinguishedname}}
    }
}

function Get-SkAdUserDisabled {
    param()
    # https://blogs.msmvps.com/richardsiddaway/2012/02/04/find-user-accounts-that-are-disabled/
    $root = [ADSI]""            
    $search = [adsisearcher]$root            
    $search.Filter = "(&(objectclass=user)(objectcategory=user)(useraccountcontrol:1.2.840.113556.1.4.803:=2))"            
    $search.SizeLimit = 3000            
    $results = $search.FindAll()            
    foreach ($result in $results){            
        $result.Properties |             
        select @{N="Name"; E={$_.name}}, @{N="DistinguishedName"; E={$_.distinguishedname}}            
    }
}

function Get-SkAdOuTree {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$False)]
        [string] $Path = ""
    )
    try {
        $info = ([adsisearcher]"objectclass=organizationalunit")
        $info.PropertiesToLoad.AddRange("CanonicalName")
        $output = $info.findall().properties.canonicalname
        if (![string]::IsNullOrEmpty($Path)) {
            $output = $output | ?{$_ -like "$Path*"}
            if ($output.count -gt 1) {
                $output = $output[1..($output.length-1)]
            }
        }
        foreach ($ou in $output) {
            $oulist = $ou -split '/'
            $props = [ordered]@{
                FullPath  = $ou 
                ChildPath = $oulist[1..$($oulist.length -1)]
                Name      = $oulist[$($oulist.length -1)]
            }
            New-Object PSObject -Property $props
        }
        #return $output
    }
    catch {
        throw $Error[0].Exception.Message
    }
}

function Get-SkAdOuObjects {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $ou,
        [parameter(Mandatory=$False)]
        [string] $ObjectType = ""
    )
    $root = [ADSI]"LDAP://$ou"
    $search = [adsisearcher]$root
    if ($ObjectType -ne "") {
        $search.Filter = "(&(objectclass=$ObjectType)(objectcategory=$ObjectType))"
    }
    $search.SizeLimit = 3000
    $results = $search.FindAll()
    foreach ($result in $results) {
        $props = $result.Properties
        foreach ($p in $props) {
            $itemName = ($p.name | Out-String).Trim()
            $objName  = ($p.samaccountname | Out-String).Trim()
            $itemPath = ($p.distinguishedname | Out-String).Trim()
            $itemPth  = $itemPath -replace "CN=$itemName,", ''
            $itemType = (($p.objectcategory -split ',')[0]) -replace 'CN=', ''
            $output = [ordered]@{
                Name = $itemName
                ObjName = $objName
                DN   = $itemPath
                Path = $itemPth
                Type = $itemType
            }
            New-Object PSObject -Property $output
        }
    }
}

function Get-SkValueLinkAD {
    param (
        [parameter(Mandatory=$True)]
			[ValidateNotNullOrEmpty()]
			[string] $PropertyName,
        [parameter(Mandatory=$False)]
			[string] $Value = ""
    )
    $output = ""
    if (![string]::IsNullOrEmpty($Value)) {
        switch ($PropertyName) {
            'ComputerName' {
                $output = "<a href=`"adcomputer.ps1?f=name&v=$Value&x=equals`" title=`"Details for $Value`">$Value</a>"
                break;
            }
            'UserName' {
                $output = "<a href=`"aduser.ps1?f=username&v=$Value&x=equals`" title=`"Details for $Value`">$Value</a>"
                break;
            }
            'Title' {
                $output = "<a href=`"adusers.ps1?f=title&v=$Value&x=equals`" title=`"Filter on $Value`">$Value</a>"
                break;
            }
            'Department' {
                $output = "<a href=`"adusers.ps1?f=department&v=$Value&x=equals`" title=`"Filter on $Value`">$Value</a>"
                break;
            }
            'LastLogon' {
                $output = "$Value `($($(New-TimeSpan -Start $Value -End (Get-Date)).Days)` days)"
                break;
            }
            'Email' {
                $output = "<a href=`"mailto://$Value`" title=`"Email $Value`">$Value</a>"
                break;
            }
            'OS' {
                $output = "<a href=`"adcomputers.ps1?f=OS&v=$Value&x=equals`" title=`"Filter on $Value`">$Value</a>"
                break;
            }
            'OSVer' {
                $output = "$Value - $(Get-SkOsBuildName -BuildData $Value)"
                break;
            }
            default {
                $output = $Value
                break;
            }
        } # switch
    }
    Write-Output $output
}

function Get-SkAdObjectTableMultiple {
    param (
        [parameter(Mandatory=$True)]
            [ValidateSet('computer','user','group')]
            [string] $ObjectType,
        [parameter(Mandatory=$False)]
            [string[]] $Columns,
        [parameter(Mandatory=$False)]
            [string] $SortColumn = "",
        [parameter(Mandatory=$False)]
            [switch] $NoSortHeadings
    )
    $output = ""
    switch ($ObjectType) {
        'computer' {
            if (![string]::IsNullOrEmpty($SortColumn)) { 
                $computers = Get-ADsComputers | Sort-Object $SortColumn
            }
            else {
                $computers = Get-ADsComputers
            }
            if (![string]::IsNullOrEmpty($Script:SearchValue)) {
                $IsFiltered = $True
                switch ($SearchType) {
                    {($_ -eq 'contains') -or ($_ -eq 'like')} {
                        $computers = $computers | Where-Object {$_."$Script:SearchField" -like "*$Script:SearchValue*"}
                        $cap = 'contains'
                        break;
                    }
                    'begins' {
                        $computers = $computers | Where-Object {$_."$Script:SearchField" -like "$Script:SearchValue*"}
                        $cap = 'begins with'
                        break;
                    }
                    'ends' {
                        $computers = $computers | Where-Object {$_."$Script:SearchField" -like "*$Script:SearchValue"}
                        $cap = 'ends with'
                        break;
                    }
                    default {
                        $computers = $computers | Where-Object {$_."$Script:SearchField" -eq $Script:SearchValue}
                        $cap = '='
                        break;
                    }
                }
            }
            if ($Columns.Count -gt 0) {
                $colcount = $Columns.Count
            }
            else {
                $columns = $computers[0].psobject.Properties.name
                $colcount = $columns.Count
            }
            $output = '<table id=table1><tr>'
            if (!$NoSortHeadings) {
                $output += New-SkTableColumnSortRow -ColumnNames $columns -BaseLink "$pagelink`?f=$($Script:SearchField)&v=$($Script:SearchValue)&x=$($Script:SortType)"
            }
            else {
                $output += $columns | ForEach-Object {"<th>$_</th>"}
            }
            $output += '</tr>'
            $rowcount = 0
            foreach ($comp in $computers) {
                $output += '<tr>'
                foreach ($col in $columns) {
                    $fn = $col
                    $fv = $($comp."$col")
                    if ($fn -eq 'Name') { $fn = 'ComputerName' }
                    $fvx = Get-SkValueLinkAD -PropertyName $fn -Value $fv
                    $output += '<td>'+$fvx+'</td>'
                }
                $output += '</tr>'
                $rowcount++
            } # foreach
            $output += '<tr>'
            $output += "<td colspan=`"$colCount`" class=`"lastrow`">$rowcount computers found"
            if ($IsFiltered -eq $True) {
                $output += " - <a href=`"$pagelink`" title=`"Show All`">Show All</a>"
            }
            $output += '</td></tr></table>'    
            break;
        }
        'user' {
            if (![string]::IsNullOrEmpty($SortColumn)) { 
                $users = Get-ADsUsers | Sort-Object $SortColumn | Select Name,UserName,DisplayName,Title,Department,DN,OUPath,Created,LastLogon
            }
            else {
                $users = Get-ADsUsers | Select Name,UserName,DisplayName,Title,Department,DN,OUPath,Created,LastLogon
            }
            if (![string]::IsNullOrEmpty($Script:SearchValue)) {
                $IsFiltered = $True
                switch ($SearchType) {
                    {($_ -eq 'contains') -or ($_ -eq 'like')} {
                        $users = $users | Where-Object {$_."$Script:SearchField" -like "*$Script:SearchValue*"}
                        $cap = 'contains'
                        break;
                    }
                    'begins' {
                        $users = $users | Where-Object {$_."$Script:SearchField" -like "$Script:SearchValue*"}
                        $cap = 'begins with'
                        break;
                    }
                    'ends' {
                        $users = $users | Where-Object {$_."$Script:SearchField" -like "*$Script:SearchValue"}
                        $cap = 'ends with'
                        break;
                    }
                    default {
                        $users = $users | Where-Object {$_."$Script:SearchField" -eq $Script:SearchValue}
                        $cap = '='
                        break;
                    }
                }
            }
            if ($Columns.Count -gt 0) {
                $colcount = $Columns.Count
            }
            else {
                $columns = $users[0].psobject.Properties.name
                $colcount = $columns.Count
            }
            $output = '<table id=table1><tr>'
            if (!$NoSortHeadings) {
                $output += New-SkTableColumnSortRow -ColumnNames $columns -BaseLink "$pagelink`?f=$($Script:SearchField)&v=$($Script:SearchValue)&x=$($Script:SortType)"
            }
            else {
                $output += $columns | ForEach-Object {"<th>$_</th>"}
            }
            $output += '</tr>'
            $rowcount = 0
            foreach ($user in $users) {
                $output += '<tr>'
                foreach ($col in $columns) {
                    $fn = $col
                    $fv = $($user."$col")
                    if ($fn -eq 'Name') { $fn = 'UserName' }
                    $fvx = Get-SkValueLinkAD -PropertyName $fn -Value $fv
                    $output += "<td>$fvx</td>"
                }
                $output += '</tr>'
                $rowcount++
            } # foreach
            $output += '<tr>'
            $output += '<td colspan='+$($columns.Count)+' class=lastrow>'+$rowcount+' users found'
            if ($IsFiltered -eq $True) {
                $output += " - <a href=`"$pagelink`" title=`"Show All`">Show All</a>"
            }
            $output += '</td></tr></table>'    
            break;
        }
        'group' {
            if (![string]::IsNullOrEmpty($SortColumn)) {
                $groups = Get-ADsGroups | Sort-Object $SortColumn | Select Name,Description
            }
            else {
                $groups = Get-ADsGroups | Select Name,Description
            }
            if (![string]::IsNullOrEmpty($Script:SearchValue)) {
                $IsFiltered = $True
                switch ($SearchType) {
                    {($_ -eq 'contains') -or ($_ -eq 'like')} {
                        $groups = $groups | Where-Object {$_."$Script:SearchField" -like "*$Script:SearchValue*"}
                        $cap = 'contains'
                        break;
                    }
                    'begins' {
                        $groups = $groups | Where-Object {$_."$Script:SearchField" -like "$Script:SearchValue*"}
                        $cap = 'begins with'
                        break;
                    }
                    'ends' {
                        $groups = $groups | Where-Object {$_."$Script:SearchField" -like "*$Script:SearchValue"}
                        $cap = 'ends with'
                        break;
                    }
                    default {
                        $groups = $groups | Where-Object {$_."$Script:SearchField" -eq $Script:SearchValue}
                        $cap = '='
                        break;
                    }
                }
            }
            if ($Columns.Count -gt 0) {
                $colcount = $Columns.Count
            }
            else {
                $columns = $groups[0].psobject.Properties.name
                $colcount = $columns.Count
            }
            $output = '<table id=table1><tr>'
            if (!$NoSortHeadings) {
                $output += New-SkTableColumnSortRow -ColumnNames $columns -BaseLink "$pagelink`?f=$($Script:SearchField)&v=$($Script:SearchValue)&x=$($Script:SortType)"
            }
            else {
                $output += $columns | ForEach-Object {"<th>$_</th>"}
            }
            $output += '</tr>'
            $rowcount = 0
            foreach ($group in $groups) {
                $output += '<tr>'
                foreach ($col in $columns) {
                    $fn  = $col
                    $fv  = $($group."$col")
                    $fvx = Get-SkValueLinkAD -PropertyName $fn -Value $fv
                    $output += "<td>$fvx</td>"
                }
                $output += '</tr>'
                $rowcount++
            } # foreach
            $output += '<tr>'
            $output += '<td colspan='+$($columns.Count)+' class=lastrow>'+$rowcount+' groups found'
            if ($IsFiltered -eq $True) {
                $output += " - <a href=`"$pagelink`" title=`"Show All`">Show All</a>"
            }
            $output += '</td></tr></table>'    
            break;
        }
    }
    Write-Output $output
}

#---------------------------------------------------------------------
# CONFIGMGR FUNCTIONS

function Get-SkCmDeviceCollectionMemberships {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True)]
			[ValidateNotNullOrEmpty()]
			[string] $ComputerName,
        [parameter(Mandatory=$False)]
			[switch] $Inverse
    )
    #Write-Verbose "Get-SkCmDeviceCollectionMemberships"
    $output = $null
    try {
        if (!$Inverse) {
            $query = "SELECT DISTINCT 
	            v_FullCollectionMembership.CollectionID, 
	            v_Collection.Name as [CollectionName] 
            FROM v_FullCollectionMembership INNER JOIN v_Collection ON 
	            v_FullCollectionMembership.CollectionID = v_Collection.CollectionID 
            WHERE v_FullCollectionMembership.Name = '$ComputerName'"
        }
        else {
            $query = "SELECT DISTINCT 
	            v_Collection.CollectionID, v_Collection.Name, v_Collection.CollectionType 
            FROM v_Collection 
            WHERE 
                (CollectionID NOT IN 
                    (SELECT DISTINCT CollectionID from v_CollectionRuleQuery) )
                AND
                    (v_Collection.CollectionType = 2)
	            AND 
	            (v_Collection.CollectionID NOT IN (
		            SELECT DISTINCT CollectionID 
		            FROM v_FullCollectionMembership 
		            WHERE Name = '$ComputerName' 
	            ))
            ORDER BY v_Collection.Name"
        }
        #Write-Verbose $query
        $output = @(Invoke-DbaQuery -SqlInstance $SkCmDbHost -Database "CM_$SkCmSiteCode" -Query $query -ErrorAction SilentlyContinue)
    }
    catch {}
    finally {
        Write-Output $output -NoEnumerate
    }
}

function Get-SkCmPackageTypeName {
    param (
        [parameter(Mandatory=$True)]
        [int] $PkgType
    )
    switch ($PkgType) {
          0 { return 'Software Distribution Package'; break; }
          3 { return 'Driver Package'; break; }
          4 { return 'Task Sequence Package'; break; }
          5 { return 'Software Update Package'; break; }
          6 { return 'Device Settings Package'; break; }
          7 { return 'Virtual Package'; break; }
          8 { return 'Application'; break; }
        257 { return 'OS Image Package'; break; }
        258 { return 'Boot Image Package'; break; }
        259 { return 'OS Upgrade Package'; break; }
        260 { return 'VHD Package'; break; }
    }
}

#---------------------------------------------------------------------
# LAYOUT FUNCTIONS

function Get-SkParams {
    param()
    $Script:SearchField = Get-SkPageParam -TagName 'f' -Default ""
    $Script:SearchValue = Get-SkPageParam -TagName 'v' -Default ""
    $Script:SearchType  = Get-SkPageParam -TagName 'x' -Default "equals"
    $Script:SortField   = Get-SkPageParam -TagName 's' -Default ""
    $Script:SortOrder   = Get-SkPageParam -TagName 'so' -Default 'asc'
    $Script:TabSelected = Get-SkPageParam -TagName 'tab' -Default ""
    $Script:CollectionType = Get-SkPageParam -TagName 't' -Default ""
    $Script:Detailed    = Get-SkPageParam -TagName 'zz' -Default ""
    $Script:CustomName  = Get-SkPageParam -TagName 'n' -Default ""
}

function New-SkMenuTabSet {
    param (
        [parameter(Mandatory=$True)]
			[ValidateNotNullOrEmpty()]
			[string] $BaseLink,
        [parameter(Mandatory=$False)]
			[string] $DefaultID = ""
    )
    $output = "<table id=table3><tr>"
    if ($DefaultID -eq 'all') {
        $output += "<td class=`"dyn2`" title='All'>All</td>"
    }
    else {
        $xlink = $($BaseLink -split '\?')[0]
        $output += "<td class=`"dyn1`" onMouseOver=`"this.className='dyn2'`" onMouseOut=`"this.className='dyn1'`" title=`"Show All`" onClick=`"document.location.href='$xlink'`">All</td>"
    }
    for ($i=65; $i -lt $(65+26); $i++) {
        $c = [char]$i
        $xlink = $BaseLink + $c
        if ($DefaultID -eq $c) {
            $output += "<td class=`"dyn2`">$c</td>"
        }
        else {
            $output += "<td class=`"dyn1`" onMouseOver=`"this.className='dyn2'`" onMouseOut=`"this.className='dyn1'`" title=`"Filter on $c`" onClick=`"document.location.href='$xlink'`">$c</td>"
        }
    }
    for ($i=0; $i -lt 10; $i++) {
        $xlink = $BaseLink + $i
        if ($DefaultID -eq $c) {
            $output += "<td class=`"dyn2`">$i</td>"
        }
        else {
            $output += "<td class=`"dyn1`" onMouseOver=`"this.className='dyn2'`" onMouseOut=`"this.className='dyn1'`" title=`"Filter on $i`" onClick=`"document.location.href='$xlink'`">$i</td>"
        }
    }
    $output += "</tr></table>"
    return $output
}

function New-SkMenuTabSet2 {
    param (
        [parameter(Mandatory=$True)]
			[ValidateNotNullOrEmpty()]
			[string[]] $MenuTabs,
        [parameter(Mandatory=$True)]
			[ValidateNotNullOrEmpty()]
			[string] $BaseLink
    )
    $output = "<table id=tablex><tr>"
    if ([string]::IsNullOrEmpty($TabSelected)) {
        $TabSelected = $MenuTabs[0]
    }
    foreach ($tab in $tabs) {
        $xlink = "$baselink`?f=$SearchField&v=$SearchValue&x=$SearchType&s=$SortField&so=$SortOrder&n=$CustomName&tab=$tab"
        if ($tab -eq $TabSelected) {
            $output += "<td class=`"btab`">$tab</td>"
        }
        else {
            $output += "<td class=`"btab`" onClick=`"document.location.href='$xlink'`" title=`"$tab`">$tab</td>"
        }
    }
    $output += "</tr></table>"
    return $output
}

function New-SkTableColumnSortRow {
    param (
        [parameter(Mandatory=$True)]
            [string[]] $ColumnNames,
        [parameter(Mandatory=$True)]
            [ValidateNotNullOrEmpty()]
            [string] $BaseLink
    )
    $output = ""
    if ([string]::IsNullOrEmpty($Script:SortField)) {
        $Script:SortField = $Columns[0]
    }
    if ($BaseLink -like '*?*') { $append = '&' } else { $append = '?' }
    foreach ($col in $ColumnNames) {
        if ($col -eq $Script:SortField) {
            if ($Script:SortOrder -eq 'Asc') {
                $xlink = "<a href=`"$BaseLink"+"$append`s=$col&so=desc`" title=`"Sort by $col / Descending`">$col</a>"
                $ilink = "<img src='graphics/sortasc.png' border=0 alt='' />"
            }
            else {
                $xlink = "<a href=`"$BaseLink"+"$append`s=$col&so=asc`" title=`"Sort by $col`">$col</a>"
                $ilink = "<img src='graphics/sortdesc.png' border=0 alt='' />"
            }
        }
        else {
            $xlink = "<a href=`"$BaseLink$append`s=$col&so=asc`" title=`"Sort by $col`">$col</a>"
            $ilink = ""
        }
        $output += '<th>'+$xlink+' '+$ilink+'</th>'
    }
    $Script:SortField = ""
    return $output
}

function New-SkMenuList {
    param (
        [parameter(Mandatory=$True)]
            $PropertyList,
        [parameter(Mandatory=$True)]
            [ValidateNotNullOrEmpty()]
            [string] $TargetLink,
        [parameter(Mandatory=$False)]
            [string] $Default = ""
    )
    if ([string]::IsNullOrEmpty($Default)) {
        $Default = $PropertyList[0]
        $Script:TabSelected = $Default
    }
    $output = "<form name='form2' id='form2' method='POST' action=''>"
    $output += "<select name='p' id='p' size='1' style='width:300px;padding:5px' onChange=`"this.options[this.selectedIndex].value && (window.location = this.options[this.selectedIndex].value);`">"
    $output += "<option value=''></option>"
    $output += $plist | %{ 
        if ($_ -eq $Default) {
            "<option value=`$TargetLink`&tab=$_' selected>$_</option>"
        }
        else {
            "<option value='$TargetLink`&tab=$_'>$_</option>"
        }
    }
    $output += "</select></form>"
    Write-Output $output
}

function Show-SkPage {
    param()
    $bodyset = @"
<!DOCTYPE HTML>
<html lang="en-us">
<head>
    <title>XPAGETITLE</title>
    <meta charset="UTF-8">
    <meta name="description" content="SkatterTools. http://github.com/skatterbrainz">
    <meta name="author" content="Skatterbrainz">
    <link rel="stylesheet" type="text/css" href="$SkTheme">
</head>
<body>
<h1>XPAGETITLE</h1>
XTABSET
<!-- begin content section -->
XCONTENT
<!-- end content section -->
</body>
</html>
"@
    $output = $bodyset -replace 'XPAGETITLE', $PageTitle
    $output = $output -replace 'XCONTENT', $content
    $output = $output -replace 'XTABSET', $tabset
    Write-Output $output
}

function Get-SkPageParam {
    param (
        [parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $TagName,
        [parameter(Mandatory=$False)]
        [string] $Default = ""
    )
    $output = $PoshQuery."$TagName"
    if ([string]::IsNullOrEmpty($output)) {
        $output = $Default
    }
    return $output
}

function Get-SkFormParam {
    param (
        [parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $ElementID,
        [parameter(Mandatory=$False)]
        [string] $Default = ""
    )
    $output = $PoshPost."$ElementID"
    if ([string]::IsNullOrEmpty($output)) {
        $output = $Default
    }
    return $output
}

function Write-SkDetailView {
    param (
        [parameter(Mandatory=$False)]
        [string] $PageRef = "", 
        [parameter(Mandatory=$False)]
        [string] $Mode = ""
    )
    if ($Mode -eq "1") {
        $output = @"
<h3>Page Details</h3><table id=tabledetail>
    <tr><td style=`"width:200px;`">SearchField</td><td>$($Script:SearchField)</td></tr>
    <tr><td style=`"width:200px;`">SearchValue</td><td>$($Script:SearchValue)</td></tr>
    <tr><td style=`"width:200px;`">SearchType</td><td>$($Script:SearchType)</td></tr>
    <tr><td style=`"width:200px;`">SortField</td><td>$($Script:SortField)</td></tr>
    <tr><td style=`"width:200px;`">SortOrder</td><td>$($Script:SortOrder)</td></tr>
    <tr><td style=`"width:200px;`">CustomName</td><td>$($Script:CustomName)</td></tr>
    <tr><td style=`"width:200px;`">CollectionType</td><td>$($Script:CollectionType)</td></tr>
    <tr><td style=`"width:200px;`">TabSelected</td><td>$($Script:TabSelected)</td></tr>
    <tr><td style=`"width:200px;`">Detailed</td><td>$($Script:Detailed)</td></tr>
    <tr><td style=`"width:200px;`">PageTitle</td><td>$PageTitle</td></tr>
    <tr><td style=`"width:200px;`">PageCaption</td><td>$PageCaption</td></tr>
    <tr><td style=`"width:200px;`">Last Step</td><td>$($Script:xxx)</td></tr>
    <tr><td colspan=2>
    <a href=`"$PageRef`?f=$($Script:SearchField)&v=$($Script:SearchValue)&x=$($Script:SearchType)&s=$($Script:SortField)&so=$($Script:SearchOrder)&t=$($Script:CollectionType)&n=$($Script:CustomName)&tab=$($Script:TabSelected)`">Hide Details</a>
    </td></tr>
</table>
"@
        return $output
    }
    else {
        $output = @"
<table id=table3>
<tr>
<td><a href=`"$PageRef`?f=$($Script:SearchField)&v=$($Script:SearchValue)&x=$($Script:SearchType)&s=$($Script:SortField)&so=$($Script:SearchOrder)&n=$($Script:CustomName)&tab=$($Script:TabSelected)&zz=1`">Show Details</a></td>
</tr>
</table>
"@
        return $output
    }
}

function Get-SkUrlEncode {
    param ($StringVal)
    $output = ""
    for ($i = 0; $i -lt $StringVal.Length; $i++) {
        $c = $([byte][char]$StringVal[$i] | Out-String).Trim()
        if ($c.Length -lt 3) {
            $output += "0$c"
        }
        else {
            $output += $c
        }
    }
    return $output
}

function Get-SkUrlDecode {
    param ($EncodedVal)
    $output = [string]::new("")
    $ccount = ($EncodedVal.Length - 2)
    for ($i = 0; $i -lt $ccount; $i+=3) {
        $chunk = $EncodedVal.Substring($i,3)
        $ascii = [convert]::ToUInt16($chunk)
        $output += [char]$ascii
    }
    return $output
}

function Get-SkWmiValue {
    param (
        [parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $PropName,
        [parameter(Mandatory=$False)]
        $Value
    )
    $output = ""
    if (![string]::IsNullOrEmpty($Value)) {
        switch ($PropName) {
            'AdminPasswordStatus' {
                switch ($Value) {
                    0 { $output = 'Disabled'; break; }
                    1 { $output = 'Enabled'; break; }
                    2 { $output = 'Not implemented'; break; }
                    3 { $output = 'Unknown'; break; }
                }
                break;
            }
            'BootOptionOnWatchDog' {
                switch ($Value) {
                    0 { $output = 'Reserved'; break; }
                    1 { $output = 'Operating System'; break; }
                    2 { $output = 'System Utilities'; break; }
                    3 { $output = 'Do Not Reboot'; break; }
                }
                break;
            }
            'LastUseTime' {
                try {
                    $datepart = "$($Value.Substring(4,2))`/$($Value.Substring(6,2))`/$($Value.Substring(0,4))"
                    $timepart = "$($Value.Substring(8,2))`:$($Value.Substring(10,2))"
                    $output   = "$(([datetime]$datepart).ToShortDateString()+' '+$([datetime]$timepart).ToLongTimeString())"
                }
                catch {
                    $output = "error"
                }
                break;
            }
            'InstallDate' {
                try {
                    $datepart = "$($Value.Substring(4,2))`/$($Value.Substring(6,2))`/$($Value.Substring(0,4))"
                    $timepart = "$($Value.Substring(8,2))`:$($Value.Substring(10,2))"
                    $output   = "$(([datetime]$datepart).ToShortDateString()+' '+$([datetime]$timepart).ToLongTimeString())"
                }
                catch {
                    $output = "error"
                }
                break;
            }
            'LastBootUpTime' {
                try {
                    $datepart = "$($Value.Substring(4,2))`/$($Value.Substring(6,2))`/$($Value.Substring(0,4))"
                    $timepart = "$($Value.Substring(8,2))`:$($Value.Substring(10,2))"
                    $output   = "$(([datetime]$datepart).ToShortDateString()+' '+$([datetime]$timepart).ToLongTimeString())"
                }
                catch {
                    $output = "error"
                }
                break;
            }
            'LocalDateTime' {
                try {
                    $datepart = "$($Value.Substring(4,2))`/$($Value.Substring(6,2))`/$($Value.Substring(0,4))"
                    $timepart = "$($Value.Substring(8,2))`:$($Value.Substring(10,2))"
                    $output   = "$(([datetime]$datepart).ToShortDateString()+' '+$([datetime]$timepart).ToLongTimeString())"
                }
                catch {
                    $output = "error"
                }
                break;
            }
            'ChassisBootupState' {
                switch ($Value) {
                    1 { $output = 'Other'; break; }
                    2 { $output = 'Unknown'; break; }
                    3 { $output = 'Safe'; break; }
                    4 { $output = 'Warning'; break; }
                    5 { $output = 'Critical'; break; }
                    6 { $output = 'Non-recoverable'; break; }
                }
                break;
            }
            'DomainRole' {
                switch ($Value) {
                    0 { $output = 'Standalone Workstation'; break; }
                    1 { $output = 'Member Workstation'; break; }
                    2 { $output = 'Standalone Server'; break; }
                    3 { $output = 'Member Server'; break; }
                    4 { $output = 'Backup Domain Controller'; break; }
                    5 { $output = 'Primary Domain Controller'; break; }
                }
                break; 
            }
            'FrontPanelResetStatus' {
                switch ($Value) {
                    0 { $output = 'Disabled'; break; }
                    1 { $output = 'Enabled'; break; }
                    2 { $output = 'Not implemented'; break; }
                    3 { $output = 'Unknown'; break; }
                }
                break;
            }
            'KeyboardPasswordStatus' {
                switch ($Value) {
                    0 { $output = 'Disabled'; break; }
                    1 { $output = 'Enabled'; break; }
                    2 { $output = 'Not implemented'; break; }
                    3 { $output = 'Unknown'; break; }
                }
                break;
            }
            'OperatingSystemSKU' {
                switch($Value) {
                      0 { $output = 'Undefined'; break; }
                      1 { $output = 'Ultimate'; break; }
                      2 { $output = 'Basic'; break; }
                      3 { $output = 'Home Premium'; break; }
                      4 { $output = 'Enterprise'; break; }
                      6 { $output = 'Business'; break; }
                      7 { $output = 'Standard'; break; }
                      8 { $output = 'DataCenter'; break; }
                      9 { $output = 'Small Business'; break; }
                     10 { $output = 'Enterprise'; break; }
                     11 { $output = 'Starter'; break; }
                     12 { $output = 'DataCenter Core'; break; }
                     13 { $output = 'Standard Core'; break; }
                     14 { $output = 'Enterprise Core'; break; }
                     17 { $output = 'Web Server'; break; }
                     19 { $output = 'Home Server'; break; }
                     20 { $output = 'Storage Express'; break; }
                     21 { $output = 'Storage Standard'; break; }
                     22 { $output = 'Storage Workgroup'; break; }
                     23 { $output = 'Storage Enterprise'; break; }
                     24 { $output = 'Small Business'; break; }
                     25 { $output = 'Small Business Server Premium Edition'; break; }
                     27 { $output = 'Windows Enterprise Edition'; break; }
                     28 { $output = 'Windows Ultimate Edition'; break; }
                     29 { $output = 'Windows Server Web Server Edition (Server Core installation)'; break; }
                     36 { $output = 'Windows Server Standard Edition without Hyper-V'; break; }
                     37 { $output = 'Windows Server Datacenter Edition without Hyper-V (full installation)'; break; }
                     38 { $output = 'Windows Server Enterprise Edition without Hyper-V (full installation)'; break; }
                     39 { $output = 'Windows Server Datacenter Edition without Hyper-V (Server Core installation)'; break; }
                     40 { $output = 'Windows Server Standard Edition without Hyper-V (Server Core installation)'; break; }
                     41 { $output = 'Windows Server Enterprise Edition without Hyper-V (Server Core installation)'; break; }
                     42 { $output = 'Microsoft Hyper-V Server'; break; }
                     43 { $output = 'Storage Server Express Edition (Server Core installation)'; break; }
                     44 { $output = 'Storage Server Standard Edition (Server Core installation)'; break; }
                     45 { $output = 'Storage Server Workgroup Edition (Server Core installation)'; break; }
                     46 { $output = 'Storage Server Enterprise Edition (Server Core installation)'; break; }
                     50 { $output = 'Windows Server Essentials (Desktop Experience installation)'; break; }
                     63 { $output = 'Small Business Server Premium (Server Core installation)'; break; }
                     64 { $output = 'Windows Compute Cluster Server without Hyper-V'; break; }
                     97 { $output = 'Windows RT'; break; }
                    101 { $output = 'Windows Home'; break; }
                    103 { $output = 'Windows Professional with Media Center'; break; }
                    104 { $output = 'Windows Mobile'; break; }
                    123 { $output = 'Windows IoT (Internet of Things) Core'; break; }
                    143 { $output = 'Windows Server Datacenter Edition (Nano Server installation)'; break; }
                    144 { $output = 'Windows Server Standard Edition (Nano Server installation)'; break; }
                    147 { $output = 'Windows Server Datacenter Edition (Server Core installation)'; break; }
                    148 { $output = 'Windows Server Standard Edition (Server Core installation)'; break; }
                    default { $output = $Value; break; }
                }
                break;
            }
            'OSProductSuite' {
                switch ($Value) {
                        1 { $output = 'Small Business Server'; break; }
                        2 { $output = 'Windows Server 2008'; break; }
                        4 { $output = 'Windows BackOffice'; break; }
                        8 { $output = 'Communication Server'; break; }
                       16 { $output = 'Terminal Services'; break; }
                       32 { $output = 'Small Business Server'; break; }
                       64 { $output = 'Windows Embedded'; break; }
                      128 { $output = 'DataCenter Edition'; break; }
                      256 { $output = 'Terminal Services, single-session'; break; }
                      512 { $output = 'Windows Home Edition'; break; }
                     1024 { $output = 'Web Server Edition'; break; }
                     8192 { $output = 'Storage Server Edition'; break; }
                    16384 { $output = 'Compute Cluster Edition'; break; }
                    default { $output = $Value; break; }
                }
                break;
            }
            'OSType' {
                switch ($Value) {
                     1 { $output = 'Other'; break; }
                     2 { $output = 'MacOS'; break; }
                     3 { $output = 'ATT UNIX'; break; }
                     4 { $output = 'DGUX'; break; }
                     5 { $output = 'DEC NT'; break; }
                     6 { $output = 'Digital UNIX'; break; }
                     7 { $output = 'OpenVMS'; break; }
                     8 { $output = 'HPUX'; break; }
                     9 { $output = 'AIX'; break; }
                    10 { $output = 'MVX'; break; }
                    11 { $output = 'OS400'; break; }
                    12 { $output = 'OS/2'; break; }
                    13 { $output = 'JavaVM'; break; }
                    14 { $output = 'MS-DOS'; break; }
                    15 { $output = 'Win3x'; break; }
                    16 { $output = 'Win95'; break; }
                    17 { $output = 'Win98'; break; }
                    18 { $output = 'WinNT'; break; }
                    19 { $output = 'WinCE'; break; }
                    20 { $output = 'NCR3000'; break; }
                    21 { $output = 'NetWare'; break; }
                    22 { $output = 'OSF'; break; }
                    23 { $output = 'DC/OS'; break; }
                    24 { $output = 'Reliant UNIX'; break; }
                    25 { $output = 'SCO UnixWare'; break; }
                    26 { $output = 'SCO OpenServer'; break; }
                    27 { $output = 'Sequent'; break; }
                    28 { $output = 'IRIX'; break; }
                    29 { $output = 'Solaris'; break; }
                    30 { $output = 'SunOS'; break; }
                    31 { $output = 'U6000'; break; }
                    32 { $output = 'ASeries'; break; }
                    33 { $output = 'TandemNSK'; break; }
                    34 { $output = 'TandemNT'; break; }
                    35 { $output = 'BS2000'; break; }
                    36 { $output = 'Linux'; break; }
                    37 { $output = 'Lynx'; break; }
                    38 { $output = 'Xenix'; break; }
                    39 { $output = 'VM/ESA'; break; }
                    40 { $output = 'Interactive UNIX'; break; }
                    41 { $output = 'BSD UNIX'; break; }
                    42 { $output = 'FreeBSD'; break; }
                    43 { $output = 'NetBSD'; break; }
                    44 { $output = 'GNU Hurd'; break; }
                    45 { $output = 'OS9'; break; }
                    46 { $output = 'Mach Kernel'; break; }
                    47 { $output = 'Inferno'; break; }
                    48 { $output = 'QNX'; break; }
                    49 { $output = 'EPOC'; break; }
                    50 { $output = 'IxWorks'; break; }
                    51 { $output = 'VxWorks'; break; }
                    52 { $output = 'MiNT'; break; }
                    53 { $output = 'BeOS'; break; }
                    54 { $output = 'HP MPE'; break; }
                    55 { $output = 'NextStep'; break; }
                    56 { $output = 'PalmPilot'; break; }
                    57 { $output = 'Rhapsody'; break; }
                    58 { $output = 'Windows 2000'; break; }
                    59 { $output = 'Dedicated'; break; }
                    60 { $output = 'OS/390'; break; }
                    61 { $output = 'VSE'; break; }
                    62 { $output = 'TPF'; break; }
                }
                break; 
            }
            'PCSystemType' {
                switch ($Value) {
                    0 { $output = 'Unspecified'; break; }
                    1 { $output = 'Desktop'; break; }
                    2 { $output = 'Mobile'; break; }
                    3 { $output = 'Workstation'; break; }
                    4 { $output = 'Enterprise Server'; break; }
                    5 { $output = 'SOHO Server'; break; }
                    6 { $output = 'Appliance PC'; break; }
                    7 { $output = 'Performance Server'; break; }
                    8 { $output = 'Maximum'; break; }
                }
                break;
            }
            'ProductType' {
                switch ($Value) {
                    1 { $output = 'Workstation'; break; }
                    2 { $output = 'Domain Controller'; break; }
                    3 { $output = 'Server'; break; }
                }
                break;
            }
            'ResetCapability' {
                switch ($Value) {
                    1 { $output = 'Other'; break; }
                    2 { $output = 'Unknown'; break; }
                    3 { $output = 'Disabled'; break; }
                    4 { $output = 'Enabled'; break; }
                    5 { $output = 'Not implemented'; break; }
                }
                break;
            }
            'SuiteMask' {
                $vlist = @{1 = 'Small Business'; 2 = 'Enterprise'; 4 = 'BackOffice'; 8 = 'Communications'; 16 = 'Terminal Services'; 32 = 'Small Business Restricted'; 64 = 'Embedded Edition'; 128 = 'Datacenter Edition'; 256 = 'Single User'; 512 = 'Home Edition'; 1024 = 'Web Server Edition'}
                $output = ($vlist.Keys | where {$_ -band $Value} | foreach {$vlist.Item($_)}) -join ', '
                break;
            }
            'MaxClockSpeed' {
                $output = "$([math]::Round($Value/1024,2))"+' Ghz'
                break;
            }
            'ThermalState' {
                switch ($Value) {
                    1 { $output = 'Other'; break; }
                    2 { $output = 'Unknown'; break; }
                    3 { $output = 'Safe'; break; }
                    4 { $output = 'Warning'; break; }
                    5 { $output = 'Critical'; break; }
                    6 { $output = 'Non-recoverable'; break; }
                }
                break;
            }
            'WakeUpType' {
                switch ($Value) {
                    0 { $output = 'Reserved'; break; }
                    1 { $output = 'Other'; break; }
                    2 { $output = 'Unknown'; break; }
                    3 { $output = 'APM Timer'; break; }
                    4 { $output = 'Modem Ring'; break; }
                    5 { $output = 'LAN Remote'; break; }
                    6 { $output = 'Power Switch'; break; }
                    7 { $output = 'PCI PME'; break; }
                }
                break;
            }
            'DriveType' {
                switch ($Value) {
                    2 { $output = 'Removable'; break }
                    3 { $output = 'Fixed'; break }
                    4 { $output = 'Network'; break }
                    5 { $output = 'CD-ROM'; break }                
                }
                break;
            }
            'Size' {
                $output = "$([math]::Round(($Value / 1GB), 2)) GB"
                break;
            }
            'FreeSpace' {
                $output = "$([math]::Round(($Value / 1GB), 2)) GB"
                break;
            }
            default {
                $output = $Value
                break;
            }
        }
    }
    Write-Output $output
}

function Get-SkWmiPropTableMultiple {
    param (
        [parameter(Mandatory=$True)]
            [ValidateNotNullOrEmpty()]
            [string] $ComputerName,
        [parameter(Mandatory=$True)]
            [ValidateNotNullOrEmpty()]
            [string] $WmiClass,
        [parameter(Mandatory=$False)]
            [string[]] $Columns,
        [parameter(Mandatory=$False)]
            [string] $SortField = ""
    )
    $rowcount = 0
    try {
        if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
            $output = "<table id=table1>"
            $props = Get-WmiObject -Class $WmiClass -ComputerName $SearchValue -ErrorAction SilentlyContinue
            if ($SortField -ne "") {
                $props = $props | Sort-Object $SortField
            }
            if ($Columns.Count -gt 0) {
                $props = $props | Select $Columns
            }
            $cols = $props[0].psobject.Properties.Name
            $colcount = $cols.Count
            $output += "<tr>"
            $output += $cols | ForEach-Object { "<th>$_</th>" }
            $output += "</tr>"
            foreach ($prop in $props) {
                $output += "<tr>"
                $cindex = 0
                foreach ($p in $prop.psobject.Properties) {
                    $pn  = $p.Name
                    $pv  = $p.Value
                    $pvx = Get-SkWmiValue -PropName $pn -Value $pv 
                    if ($cindex -gt 0) {
                        $output += "<td style=`"text-align:center`">$pvx</td>"
                    }
                    else {
                        $output += "<td>$pvx</td>"
                    }
                    $cindex++
                }
                $output += "</tr>"
                $rowcount++
            }
            $output += "<tr><td colspan=`"$colcount`" class=`"lastrow`">$rowcount items</td></tr>"
            $output += "</table>"
        }
        else {
            $output = "<table id=table2><tr><td>$ComputerName is not accessible</td></tr></table>"
        }
    }
    catch {
        $output += "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
    }
    finally {
        Write-Output $output
    }
}

function Get-SkWmiPropTableSingle {
    param (
        [parameter(Mandatory=$True)]
            [ValidateNotNullOrEmpty()]
            [string] $ComputerName,
        [parameter(Mandatory=$True)]
            [ValidateNotNullOrEmpty()]
            [string] $WmiClass
    )
    try {
        if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
            $props = Get-WmiObject -Class $WmiClass -ComputerName $ComputerName -ErrorAction SilentlyContinue
            $output = "<table id=table2>"
            foreach ($p in $props.Properties) {
                $pn = $p.Name
                $pv = $p.Value
                $pvx = Get-SkWmiValue -PropName $pn -Value $pv 
                $output += "<tr><td class=`"t2td1`">$pn</td><td class=`"t2td2`">$pvx</td></tr>"
            }
            $output += "</table>"
        }
        else {
            $output = "<table id=table2><tr><td>$ComputerName is not accessible</td></tr></table>"
        }
    }
    catch {
        $output += "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
    }
    finally {
        Write-Output $output
    }
}

# https://gallery.technet.microsoft.com/scriptcenter/0e43993a-895a-4afe-a2b2-045a5146048a
function Get-SkLoggedOnUser ($ComputerName) { 
    try {
        $regexa = '.+Domain="(.+)",Name="(.+)"$' 
        $regexd = '.+LogonId="(\d+)"$'
        $logontype = @{ 
            "0"="Local System" 
            "2"="Interactive" #(Local logon) 
            "3"="Network" # (Remote logon) 
            "4"="Batch" # (Scheduled task) 
            "5"="Service" # (Service account logon) 
            "7"="Unlock" #(Screen saver) 
            "8"="NetworkCleartext" # (Cleartext network logon) 
            "9"="NewCredentials" #(RunAs using alternate credentials) 
            "10"="RemoteInteractive" #(RDP\TS\RemoteAssistance) 
            "11"="CachedInteractive" #(Local w\cached credentials) 
        }
        $logon_sessions = @(Get-WmiObject Win32_LogonSession -ComputerName $ComputerName -ErrorAction SilentlyContinue) 
        $logon_users    = @(Get-WmiObject Win32_LoggedOnUser -ComputerName $ComputerName -ErrorAction SilentlyContinue) 
        $session_user = @{}
        $logon_users |% { 
            $_.antecedent -match $regexa > $nul 
            $username = $matches[1] + "\" + $matches[2] 
            $_.dependent -match $regexd > $nul 
            $session = $matches[1] 
            $session_user[$session] += $username 
        }
        $logon_sessions | ForEach-Object { 
            $starttime = [Management.ManagementDateTimeConverter]::ToDateTime($_.StartTime)
            $loggedonuser = New-Object -TypeName psobject 
            $loggedonuser | Add-Member -MemberType NoteProperty -Name "Session" -Value $_.logonid 
            $loggedonuser | Add-Member -MemberType NoteProperty -Name "User" -Value $session_user[$_.logonid] 
            $loggedonuser | Add-Member -MemberType NoteProperty -Name "Type" -Value $logontype[$_.logontype.ToString()] 
            $loggedonuser | Add-Member -MemberType NoteProperty -Name "Auth" -Value $_.authenticationpackage 
            $loggedonuser | Add-Member -MemberType NoteProperty -Name "StartTime" -Value $starttime 
            $loggedonuser 
        }
    }
    catch {}
}

function Get-SkWmiAccessError {
    param ()
    $output = "<table id=table2><tr><td style=`"height:150px;text-align:center`">"
    $output += "Machine is offline or inaccessible. Troubleshooting tips:"
    $output += "<ul><li>Confirm machine is actually online</li>"
    $output += "<li>Verify DNS IP mapping</li>"
    $output += "<li>Check firewall service and configuration</li>"
    $output += "<li>Verify WMI services are running</li></ul>"
    $output += "<br/>Error: $($Error[0].Exception.Message)</td></tr></table>"
    Write-Output $output 
}

function Get-SkOsBuildName {
    param (
        [parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string]$BuildData
    )
    switch ($BuildData) {
        '10.0 (17763)' { return '1809'; break; }
        '10.0 (17134)' { return '1803'; break; }
        '10.0 (16299)' { return '1709'; break; }
        '10.0 (15063)' { return '1703'; break; }
        '10.0 (14393)' { return '1607'; break; }
        '10.0 (10586)' { return '1511'; break; }
    }
}

function Get-SkWinEvents {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True)]
            [ValidateNotNullOrEmpty()]
            [string] $ComputerName,
        [parameter(Mandatory=$True)]
            [ValidateSet('Application','Security','System')]
            [string] $LogName,
        [parameter(Mandatory=$False)]
            [ValidateSet('Information','Error','Warning','FailureAudit','SuccessAudit')]
            [string] $EventType = "",
        [parameter(Mandatory=$False)]
            [string] $Source = "",
        [parameter(Mandatory=$False)]
            [int] $RowLimit = 20,
        [parameter(Mandatory=$False)]
            [ValidateRange(1,1000)]
            [int] $HourLimit = 24,
        [parameter(Mandatory=$false)]
            [string[]] $Columns = ('Index','Time','EntryType','Source','InstanceID','Message')
    )
    if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
        $rowcount = 0
        $colcount = $Columns.Count
        try {
			$output = "<table id=table1><tr>"
			$output += $($Columns | ForEach-Object {"<th>$($_.Trim())</th>"}) -join ""
			$output += "</tr>"
            $params = @{
                ComputerName = $ComputerName
                LogName      = $LogName
                Newest       = $RowLimit 
                After        = $((Get-Date).AddHours(-$HourLimit))
            }
            if ($Source -ne "") {
                $params.Add("Source", $Source)
            }
            if ($EventType -ne "") {
                $params.Add("EntryType", $EventType)
            }
            $events = Get-EventLog @params -ErrorAction Stop
            $rowcount = $events.Count
            Write-Verbose "$rowcount events returned"
			foreach ($event in $events) {
				$output += "<tr>"
				$output += $columns | ForEach-Object { "<td>$($event.$_)</td>" }
				$output += "</tr>"
			}
            if ($rowcount -eq 0) {
                $output += "<tr><td colspan=$colcount>No matching events were found</td></tr>"
            }
            else {
                $output += "<tr><td colspan=$colcount class=LastRow>$rowcount events found</td></tr>"
            }
			$content += "</table>"
        }
        catch {
            $output = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
        }
    }
    else {
        $output = "<table id=table2><tr><td>$ComputerName is not accessible</td></tr></table>"
    }
    Write-Output $output
}

function New-SkDesktopShortcut {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True)]
        [string] $Name,
        [parameter(Mandatory=$True)]
        [string] $Target,
        [parameter(Mandatory=$False)]
        [string] $Arguments = "",
        [parameter(Mandatory=$False)]
        [ValidateSet('file','web')]
        [string] $ShortcutType = 'file',
        [switch] $AllUsers
    )
    if ($ShortcutType -eq 'file' -and (!(Test-Path $Target))) {
        Write-Warning "Target not found: $Target"
        break
    }
    try {
        if ($AllUsers) {
            $ShortcutFile = "$env:ALLUSERSPROFILES\Desktop\$Name.lnk"
        }
        else {
            $ShortcutFile = "$env:USERPROFILE\Desktop\$Name.lnk"
        }
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
        $Shortcut.TargetPath = $Target
        if ($ShortcutType -eq 'file' -and $Arguments -ne "") {
            $Shortcut.Arguments = $Arguments
            $Shortcut.IconLocation = "$env:SystemRoot\System32\shell32.dll,167"
        }
        else {
            $Shortcut.IconLocation = "$env:SystemRoot\System32\shell32.dll,174"
        }
        [void]$Shortcut.Save()
    }
    catch {
        Write-Error $Error[0].Exception.Message
    }
}

function Get-SkShortcut {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [string] $Path
    )
    if (!(Test-Path $Path)) {
        Write-Error "$Path was not found!"
        break
    }
    $ScPath = Get-Item $Path
    try {
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($Path)
        if ($ScPath.Extension -eq '.url') {
            $props = [ordered]@{
                Name   = $Shortcut.FullName
                Target = $Shortcut.TargetPath
                Icon   = $Shortcut.IconLocation
            }
        }
        else {
            $props = [ordered]@{
                Name      = $Shortcut.FullName
                Target    = $Shortcut.TargetPath
                Arguments = $Shortcut.Arguments
                Icon      = $Shortcut.IconLocation
            }
        }
        New-Object PSObject -Property $props
    }
    catch {}
}

function Get-SkToolsInfo {
	Write-Host "skattertools $Global:SkToolsVersion is loaded and ready. You should get loaded too." -ForegroundColor Green
	Write-Host "(just don't get loaded and go driving or anything). Please read the license page for terms and other boring stuff" -ForegroundColor Green
}