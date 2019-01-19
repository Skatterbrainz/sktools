SELECT
	[Name],
	ResourceID,
	Manufacturer,
	Model,
	SerialNumber,
	OperatingSystem,
	OSBuild,
	Processor,
	Cores,
	ClientVersion,
	LastHwScan,
	LastDDR,
	LastPolicyRequest,
	ADSiteName,
	TrustExec,
	VmCapable
FROM (
	SELECT 
		dbo.v_R_System.ResourceID, 
		dbo.v_R_System.Name0 as Name, 
		dbo.v_GS_COMPUTER_SYSTEM.Manufacturer0 as Manufacturer, 
		dbo.v_GS_COMPUTER_SYSTEM.Model0 as Model, 
		dbo.v_GS_SYSTEM_ENCLOSURE.SerialNumber0 as SerialNumber, 
		dbo.vWorkstationStatus.ClientVersion, 
		dbo.vWorkstationStatus.LastHardwareScan as LastHwScan, 
		dbo.vWorkstationStatus.LastPolicyRequest, 
		dbo.vWorkstationStatus.LastDDR, 
		dbo.v_R_System.AD_Site_Name0 as ADSiteName, 
		dbo.v_GS_OPERATING_SYSTEM.Caption0 as OperatingSystem, 
		dbo.v_GS_OPERATING_SYSTEM.BuildNumber0 as OSBuild, 
		dbo.v_GS_PROCESSOR.Name0 AS Processor, 
		dbo.v_GS_PROCESSOR.NumberOfCores0 AS Cores, 
		case 
			when (dbo.v_GS_PROCESSOR.IsTrustedExecutionCapable0 = 1) then 'Yes'
			else 'No' end as TrustExec,
		case 
			when (dbo.v_GS_PROCESSOR.IsVitualizationCapable0 = 1) then 'Yes'
			else 'No' end as VmCapable
	FROM 
		dbo.v_R_System INNER JOIN
		dbo.v_GS_COMPUTER_SYSTEM ON dbo.v_R_System.ResourceID = dbo.v_GS_COMPUTER_SYSTEM.ResourceID INNER JOIN
		dbo.v_GS_SYSTEM_ENCLOSURE ON dbo.v_R_System.ResourceID = dbo.v_GS_SYSTEM_ENCLOSURE.ResourceID INNER JOIN
		dbo.vWorkstationStatus ON dbo.v_R_System.ResourceID = dbo.vWorkstationStatus.ResourceID INNER JOIN
		dbo.v_GS_OPERATING_SYSTEM ON dbo.v_R_System.ResourceID = dbo.v_GS_OPERATING_SYSTEM.ResourceID INNER JOIN
		dbo.v_GS_PROCESSOR ON dbo.v_R_System.ResourceID = dbo.v_GS_PROCESSOR.ResourceID
) AS T1 