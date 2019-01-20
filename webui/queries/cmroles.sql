SELECT 
	RoleName,
	RoleID,
	RoleDescription,
	case when (IsBuiltIn = 1) then 'Yes' else 'No' end as 'BuiltIn',
	SourceSite,
	NumberOfAdmins,
	case when (IsSecAdminRole = 1) then 'Yes' else 'No' end as 'SecAdmin',
	case when (IsDelAdminRole = 1) then 'Yes' else 'No' end as 'DelAdmin'
FROM 
	v_Roles
ORDER BY
	RoleName