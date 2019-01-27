$ResourceName   = $PoshPost.resname
$ResourceType   = $PoshPost.restype
$ResourceID     = $PoshPost.resid
$CollectionID   = $PoshPost.collid
$CollectionName = $PoshPost.collname
$CollectionType = $PoshPost.colltype
$TargetType     = $PoshPost.targettype

$PageTitle = "Add Collection Member"
$query   = ""
$tabset  = ""

<#
$content = "<table id=table2>
<tr><td>ResourceName</td><td>$ResourceName</td></tr>
<tr><td>ResourceType</td><td>$ResourceType</td></tr>
<tr><td>ResourceID</td><td>$ResourceID</td></tr>
<tr><td>CollectionID</td><td>$CollectionID</td></tr>
<tr><td>CollectionName</td><td>$CollectionName</td></tr>
<tr><td>CollectionType</td><td>$CollectionType</td></tr>
<tr><td>TargetType</td><td>$TargetType</td></tr>
</table>"
#>
$content = ""

#$result = Add-CMCollectionMemberDirect -CollectionName $CollectionName -ResourceName $ResourceName
try {
	if ($CollectionID -ne "") {
		$laststep = "getting collection name"
		$CollectionName = Get-SkCmObjectName -TableName "v_Collection" -SearchProperty "CollectionID" -SearchValue $CollectionID -ReturnProperty "Name"
	}
	$laststep = "collection name is $CollectionName"
	$laststep = "checking for compound resourceid and resourcename"
	if ($ResourceID -match '\:') {
		$laststep = "splitting compound identifier"
		$xx = $ResourceID -split ':'
		$ResourceID   = $xx[0]
		$ResourceName = $xx[1]
	}
	if ($CollectionID -match '\:') {
		$laststep = "splitting collection identifier"
		$xx = $CollectionID -split ':'
		$CollectionID   = $xx[0]
		$CollectionName = $xx[1]
	}
	$laststep = "checking for $ResourceType"
	switch ($ResourceType) {
		5 {
			if ($TargetType -eq 'collection') {
				$TargetLink = "cmcollection.ps1?f=collectionid&v=$CollectionID&t=$CollectionType&n=&tab=members"
				$laststep   = "defined targetlink: device collection"
			}
			else {
				$TargetLink = "cmdevice.ps1?f=resourceid&v=$ResourceID&x=equals&n=$ResourceName&tab=Collections"
				$laststep   = "defined targetlink: device"
			}
			break;
		}
		4 {
			if ($TargetType -eq 'collection') {
				$TargetLink = "cmcollection.ps1?f=collectionid&v=$CollectionID&t=$CollectionType&n=&tab=members"
				$laststep   = "defined targetlink: user collection"
			}
			else {
				$TargetLink = "cmuser.ps1?f=resourceid&v=$ResourceID&x=equals&n=$ResourceName&tab=Collections"
				$laststep   = "defined targetlink: user"
			}
			break;
		}
	} # switch 

    switch ($ResourceType) {
        5 {
            if ($ResourceID -eq "") {
                $laststep = "getting device resourceid"
                [string]$ResourceID = $(Get-WmiObject -ComputerName $SkCmSMSProvider -Namespace "Root\Sms\Site_$SkCmSiteCode" -Query "Select * From SMS_R_System Where Name='$($ResourceName)'").ResourceID
            }
            $laststep = "defining new rule object"
            $SmsNewRule = $([wmiclass]$("\\$($SkCmSMSProvider)\root\sms\site_$($SkCmSiteCode):SMS_CollectionRuleDirect")).CreateInstance()
            $laststep = "getting device collection object"
            $SmsCollection = Get-WmiObject -ComputerName $SkCmSMSProvider -Namespace "Root\Sms\Site_$SkCmSiteCode" -Query "Select * From SMS_Collection Where Name='$($CollectionName)'"
            [void]$SmsCollection.Get()
            $SmsNewRule.ResourceClassName = "SMS_R_System"
            $SmsNewRule.ResourceID = $ResourceID
            $SmsNewRule.RuleName = $ResourceName
            $laststep = "adding rule to collection"
            [System.Management.ManagementBaseObject[]]$SmsRules = $SmsCollection.CollectionRules
            $SmsRules += $SmsNewRule
            $SmsCollection.CollectionRules = $SmsRules
            $laststep = "updating device collection"
            [void]$SmsCollection.Put()
            $laststep = "device collection update completed"
            $result = "Success"
            break;
        }
        4 {
            if ($ResourceID -eq "") {
                $laststep = "getting user resourceid"
                [string]$ResourceID = $(Get-WmiObject -ComputerName $SkCmSMSProvider -Namespace "Root\Sms\Site_$SkCmSiteCode" -Query "Select * From SMS_R_User Where UserName='$($ResourceName)'").ResourceID
            }
			$laststep = "resourceid is $ResourceID"
            $SmsNewRule = $([wmiclass]$("\\$($SkCmSMSProvider)\root\sms\site_$($SkCmSiteCode):SMS_CollectionRuleDirect")).CreateInstance()
            $laststep = "getting user collection object"
            $SmsCollection = Get-WmiObject -ComputerName $SkCmSMSProvider -Namespace "Root\Sms\Site_$SkCmSiteCode" -Query "Select * From SMS_Collection Where Name='$($CollectionName)'" -ErrorAction SilentlyContinue
            [void]$SmsCollection.Get()
			$laststep = "setting up rule object"
            $SmsNewRule.ResourceClassName = "SMS_R_User"
            $SmsNewRule.ResourceID = $ResourceID
            $SmsNewRule.RuleName = $ResourceName
            $laststep = "adding rule to collection"
            [System.Management.ManagementBaseObject[]]$SmsRules = $SmsCollection.CollectionRules
            $SmsRules += $SmsNewRule
            $SmsCollection.CollectionRules = $SmsRules
            $laststep = "updating user collection"
            [void]$SmsCollection.Put()
            $laststep = "user collection update completed"
            $result = "Success"
            break;
        }
		default {
			$result = "Not Implemented"
			break;
		}
    } # switch
}
catch {
    $result = "Error: $($Error[0].Exception.Message)"
}
finally {
	$content += "<table id=table2>"
	$content += "<tr><td>Resource Name</td><td>$ResourceName</td></tr>"
	$content += "<tr><td>Resource ID</td><td>$ResourceID</td></tr>"
	$content += "<tr><td>Resource Type</td><td>$ResourceType</td></tr>"
	$content += "<tr><td>Collection ID</td><td>$CollectionID</td></tr>"
	$content += "<tr><td>Collection Name</td><td>$CollectionName</td></tr>"
	$content += "<tr><td>SMS Provider</td><td>$SkCmSMSProvider</td></tr>"
	$content += "<tr><td>SMS Site Code</td><td>$SkCmSiteCode</td></tr>"
	$content += "<tr><td>Request Status</td><td>$result</td></tr>"
	$content += "<tr><td>Last step</td><td>$laststep</td></tr>"

	$content += "<tr><td>Return Link</td><td><a href=`"$TargetLink`">$TargetLink</a></td></tr>"
	#$content += "<tr><td colspan=2 style=`"heigh:150px;text-align:center`">"
	#$content += "<h3>Adding to collection...</h3>"
	#$content += "<img src=`"graphics\301.gif`" border=0 /></td></tr>"
	$content += "</table>"
}

Write-SkWebContent
