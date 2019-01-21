SELECT  
	v_Advertisement.AdvertisementName, 
	v_Advertisement.AdvertisementID, 
	v_Package.Name AS PackageName, 
	v_Advertisement.PackageID, 
	v_Advertisement.ProgramName, 
    v_Advertisement.CollectionID, 
	v_Collection.Name AS CollectionName, 
	v_Advertisement.AssignmentID
FROM 
	v_Advertisement INNER JOIN
    v_Package ON dbo.v_Advertisement.PackageID = v_Package.PackageID INNER JOIN
	v_Collection ON v_Advertisement.CollectionID = v_Collection.CollectionID