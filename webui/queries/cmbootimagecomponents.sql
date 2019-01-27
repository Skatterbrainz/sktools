SELECT DISTINCT 
	dbo.vSMS_WinPEOptionalComponentInBootImage.ImageID as PackageID, 
	dbo.vSMS_WinPEOptionalComponentInBootImage.Name as Component, 
	dbo.vSMS_WinPEOptionalComponentInBootImage.Architecture, 
	dbo.vSMS_WinPEOptionalComponentInBootImage.ComponentID, 
	dbo.vSMS_WinPEOptionalComponentInBootImage.MsiComponentID, 
	dbo.vSMS_WinPEOptionalComponentInBootImage.Size, 
	CASE WHEN (vSMS_WinPEOptionalComponentInBootImage.IsRequired = 1) THEN 'Yes' ELSE 'No' END AS Required, 
	CASE WHEN (vSMS_WinPEOptionalComponentInBootImage.IsManageable = 1) THEN 'Yes' ELSE 'No' END AS Manageable
FROM 
	dbo.vSMS_WinPEOptionalComponentInBootImage INNER JOIN
	dbo.vSMS_OSDeploymentKitWinPEOptionalComponents ON 
	dbo.vSMS_WinPEOptionalComponentInBootImage.MsiComponentID = dbo.vSMS_OSDeploymentKitWinPEOptionalComponents.MsiComponentID
ORDER BY 
	Component