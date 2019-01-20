SELECT 
    ForestID,
    SMSSiteCode,
    SMSSiteName,
    LastDiscoveryTime,
    case 
		when (LastDiscoveryStatus = 0) then 'Succeeded'
		when (LastDiscoveryStatus = 1) then 'Completed'
		when (LastDiscoveryStatus = 2) then 'Access Denied'
		when (LastDiscoveryStatus = 3) then 'Failed'
		when (LastDiscoveryStatus = 4) then 'Stopped'
		else LastDiscoveryStatus 
		end as LastDiscoveryStatus,
    LastPublishingTime,
    case 
        when (PublishingStatus = 1) then 'Published'
        else '' end as PublishingStatus,
    case 
        when (DiscoveryEnabled = 1) then 'Yes'
        else 'No' end as DiscoveryEnabled,
    case 
        when (PublishingEnabled = 1) then 'Yes'
        else 'No' end as PublishingEnabled 
FROM 
    vActiveDirectoryForestDiscoveryStatus
