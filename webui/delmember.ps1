$ResourceName   = $PoshPost.resname
$ResourceType   = $PoshPost.restype
$ResourceID     = $PoshPost.resid
$CollectionID   = $PoshPost.collid
$CollectionName = $PoshPost.collname
$CollectionType = $PoshPost.colltype
$TargetType     = $PoshPost.targettype

$PageTitle = "Delete Collection Member"
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

#$result = Dell-CMCollectionMemberDirect -CollectionName $CollectionName -ResourceName $ResourceName
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
			$laststep = "getting collection object"
			$Collection = Get-WmiObject -Namespace "root\SMS\Site_$SkCmSiteCode" -Query "select * from SMS_Collection Where SMS_Collection.CollectionID='$CollectionID'" -ComputerName $SkCmSMSProvider -ErrorAction Stop
			$Collection.Get()
			$laststep = "getting collection membership rules"
			ForEach ($Rule in $($Collection.CollectionRules | Where {$_.RuleName -eq "$ResourceName"})) {
				$ComputerObject = Get-WmiObject -Namespace "root\SMS\Site_$SkCmSiteCode" -Query "select * from SMS_R_System where Name='$ResourceName'" -ComputerName $SCCMServer
				$ResourceID = $ComputerObject.ResourceID
				$smsObject  = Get-WmiObject -Namespace "root\SMS\Site_$SkCmSiteCode" -Query "Select * From SMS_R_System Where ResourceID='$ResourceID'" -ComputerName $SCCMServer
				if($smsObject.Name -eq "$ResourceName") {
					$laststep = "deleting resource"
					$Collection.DeleteMemberShipRule($Rule) | Out-Null
				}
			}
			$laststep = "finished enumerating rules"
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
	$content += "<table id=table2>
	<tr><td>Resource Name</td><td>$ResourceName</td></tr>
	<tr><td>Resource ID</td><td>$ResourceID</td></tr>
	<tr><td>Resource Type</td><td>$ResourceType</td></tr>
	<tr><td>Collection ID</td><td>$CollectionID</td></tr>
	<tr><td>Collection Name</td><td>$CollectionName</td></tr>
	<tr><td>SMS Provider</td><td>$SkCmSMSProvider</td></tr>
	<tr><td>SMS Site Code</td><td>$SkCmSiteCode</td></tr>
	<tr><td>Request Status</td><td>$result</td></tr>
	<tr><td>Last step</td><td>$laststep</td></tr>
	<tr><td>Return Link</td><td><a href=`"$TargetLink`">$TargetLink</a></td></tr>
	</table>"
}

Write-SkWebContent
