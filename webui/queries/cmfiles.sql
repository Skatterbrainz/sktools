SELECT 
	[Name0] as ComputerName,
	v_GS_SoftwareFile.ResourceID,
	[FileID],
	[FileName],
	[FileDescription],
	[FileVersion],
	[FilePath],
	[FileModifiedDate],
	[FileSize],
	[FileCount],
	[ModifiedDate],
	[CreationDate],
	[ProductId] 
FROM 
	v_GS_SoftwareFile INNER JOIN
	v_R_System on v_GS_SoftwareFile.ResourceID = v_R_System.ResourceID 
ORDER BY 
	v_R_System.Name0, 
	FileName