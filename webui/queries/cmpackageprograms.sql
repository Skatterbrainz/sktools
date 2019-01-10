SELECT DISTINCT 
	v_Program.ProgramName, 
	v_Program.Comment, 
	v_Program.Description, 
	v_Program.CommandLine, 
	v_Program.Duration, 
	v_Program.DiskSpaceRequired, 
        v_Program.ProgramFlags, 
	v_Package.Name AS PackageName
FROM 
	v_Program INNER JOIN
        v_Package ON v_Program.PackageID = v_Package.PackageID
ORDER BY 
	v_Program.ProgramName