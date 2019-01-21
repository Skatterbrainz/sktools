SELECT 
	v_FullCollectionMembership.CollectionID, 
	v_FullCollectionMembership.ResourceID, 
	v_FullCollectionMembership.ResourceType, 
	v_FullCollectionMembership.Name, 
    v_FullCollectionMembership.IsDirect, 
	v_R_User.User_Name0 AS UserName,
	v_Collection.Name AS CollectionName
FROM 
	v_FullCollectionMembership INNER JOIN v_R_User 
	ON v_FullCollectionMembership.ResourceID = v_R_User.ResourceID
	INNER JOIN v_Collection 
	ON v_FullCollectionMembership.CollectionID = v_Collection.CollectionID
ORDER BY 
	v_Collection.Name, 
	v_FullCollectionMembership.Name
