SELECT 
	v_Advertisement.AdvertisementName, 
	v_Advertisement.AdvertisementID, 
	v_Package.Name AS PackageName,
	v_Advertisement.PackageID, 
	v_Advertisement.ProgramName, 
    v_Advertisement.CollectionID, 
	v_Collection.Name AS CollectionName, 
	v_Advertisement.AssignmentID, 
	v_Advertisement.Comment, 
	case 
		when (v_Advertisement.IncludeSubCollection = 1) then 'Yes' else 'No' end as IncludeSubCollection, 
    case 
		when (v_Advertisement.AssignedScheduleEnabled = 1) then 'Yes' else 'No' end as AssignedScheduleEnabled, 
	v_Advertisement.PresentTime, 
	case 
		when (v_Advertisement.PresentTimeEnabled = 1) then 'Yes' else 'No' end as PresentTimeEnabled, 
	case 
		when (v_Advertisement.PresentTimeIsGMT = 1) then 'Yes' else 'No' end as PresentTimeIsGMT, 
	v_Advertisement.ExpirationTime, 
    case 
		when (v_Advertisement.ExpirationTimeEnabled = 1) then 'Yes' else 'No' end as ExpirationTimeEnabled,
	case 
		when (v_Advertisement.ExpirationTimeIsGMT = 1) then 'Yes' else 'No' end as ExpirationTimeIsGMT, 
	v_Advertisement.TimeFlags, 
	v_Advertisement.AdvertFlags, 
	case 
		when (v_Advertisement.DeviceFlags = 0) then 'None'
		when (v_Advertisement.DeviceFlags = 24) then 'Always Assign'
		when (v_Advertisement.DeviceFlags = 25) then 'Hi-Bandwidth'
		when (v_Advertisement.DeviceFlags = 26) then 'ActiveSync'
		end as DeviceFlags, 
    v_Advertisement.RemoteClientFlags, 
	case 
		when (v_Advertisement.Priority = 1) then 'High'
		when (v_Advertisement.Priority = 2) then 'Normal'
		when (v_Advertisement.Priority = 3) then 'Low'
		end as Priority, 
	v_Advertisement.SourceSite, 
	case 
		when (v_Advertisement.ActionInProgress = 0) then 'None'
		when (v_Advertisement.ActionInProgress = 1) then 'Update'
		when (v_Advertisement.ActionInProgress = 2) then 'Add'
		end as ActionInProgress, 
	v_Advertisement.HierarchyPath
FROM 
	v_Advertisement INNER JOIN
    v_Package ON 
	v_Advertisement.PackageID = v_Package.PackageID INNER JOIN
    v_Collection ON 
	v_Advertisement.CollectionID = v_Collection.CollectionID