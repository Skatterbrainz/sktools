SELECT 
	v_GS_OPTIONAL_FEATURE.Name0 AS FeatureName, 
	v_GS_OPTIONAL_FEATURE.Caption0 AS FeatureID, 
	v_GS_OPTIONAL_FEATURE.ResourceID, 
    case 
		when (v_GS_OPTIONAL_FEATURE.InstallState0 = 1) then 'Enabled'
		when (v_GS_OPTIONAL_FEATURE.InstallState0 = 2) then 'Disabled'
		when (v_GS_OPTIONAL_FEATURE.InstallState0 = 3) then 'Absent'
		when (v_GS_OPTIONAL_FEATURE.InstallState0 = 4) then 'Enabled'
		end as InstallState, 
	v_R_System.Name0 AS ComputerName
FROM 
	v_GS_OPTIONAL_FEATURE INNER JOIN
    v_R_System ON v_GS_OPTIONAL_FEATURE.ResourceID = v_R_System.ResourceID
ORDER BY
	v_GS_OPTIONAL_FEATURE.Name0,
	v_GS_OPTIONAL_FEATURE.Caption0