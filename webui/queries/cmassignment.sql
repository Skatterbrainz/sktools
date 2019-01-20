SELECT 
	AssignmentID, 
	Assignment_UniqueID, 
	AssignmentName, 
	Description, 
	LocalCollectionID, 
	CollectionID, 
	CollectionName, 
	case 
		when (IncludeSubCollections = 1) then 'Yes'
		when (IncludeSubCollections = 0) then 'No'
		end as IncludeSubCollections, 
	case 
		when (DesiredConfigType = 1) then 'Required'
		when (DesiredConfigType = 2) then 'Not Allowed'
		end as DesiredConfigType,
	case 
		when (AssignmentType = 0) then 'DCM Baseline'
		when (AssignmentType = 1) then 'Updates'
		when (AssignmentType = 2) then 'Application'
		when (AssignmentType = 5) then 'Update Group'
		when (AssignmentType = 8) then 'Policy'
		end as AssignmentType, 
	case 
		when (AssignmentAction = 1) then 'Detect'
		when (AssignmentAction = 2) then 'Apply' end as AssignmentAction, 
	NonComplianceCriticality, 
	case 
		when (DPLocality = 4) then 'Download from Local'
		when (DPLocality = 6) then 'Download from Remote'
		when (DPLocality = 17) then 'No Fallback to Unprotected'
		when (DPLocality = 18) then 'Allow WUMU'
		when (DPLocality = 19) then 'Allow Metered Connection'
		end as DPLocality, 
	case 
		when (LogComplianceToWinEvent = 1) then 'Yes'
		when (LogComplianceToWinEvent = 0) then 'No'
		end as LogComplianceToWinEvent, 
	case 
		when (SendDetailedNonComplianceStatus = 1) then 'Yes'
		when (SendDetailedNonComplianceStatus = 0) then 'No'
		end as SendDetailedNonComplianceStatus, 
	case 
		when (SuppressReboot = 1) then 'Suppress Server Reboots'
		when (SuppressReboot = 0) then 'Suppress Workstation Reboots'
		end as SuppressReboot, 
	case 
		when (NotifyUser = 1) then 'Yes'
		when (NotifyUser = 0) then 'No'
		end as NotifyUser, 
	case 
		when (UseGMTTimes = 1) then 'Yes'
		when (UseGMTTimes = 0) then 'No'
		end as UseGMTTimes, 
	CreationTime, 
	ExpirationTime, 
	StartTime, 
	LastModificationTime, 
	LastModifiedBy, 
	UpdateDeadlineTime, 
	EvaluationSchedule, 
	EnforcementDeadline, 
	case 
		when (SoftDeadlineEnabled = 1) then 'Yes'
		when (SoftDeadlineEnabled = 0) then 'No'
		end as SoftDeadlineEnabled, 
	case 
		when (OverrideServiceWindows = 1) then 'Yes'
		when (OverrideServiceWindows = 0) then 'No'
		end as OverrideServiceWindows, 
	case 
		when (RebootOutsideOfServiceWindows = 1) then 'Yes'
		when (RebootOutsideOfServiceWindows = 0) then 'No'
		end as RebootOutsideOfServiceWindows, 
	SourceSite, 
	case 
		when (Priority = 0) then 'Low'
		when (Priority = 1) then 'Medium'
		when (Priority = 2) then 'High'
		end as Priority, 
	case 
		when (OfferTypeID = 0) then 'Required'
		when (OfferTypeID = 2) then 'Available'
		end as OfferTypeID, 
	case 
		when (OfferFlags = 1) then 'PreDeploy'
		when (OfferFlags = 2) then 'On-Demand'
		else OfferFlags end as OfferFlags, 
	case 
		when (RequireApproval = 1) then 'Yes'
		when (RequireApproval = 0) then 'No' 
		end as RequireApproval, 
	case 
		when (UpdateSupersedence = 1) then 'Yes'
		when (UpdateSupersedence = 0) then 'No'
		end as UpdateSupersedence, 
	LocaleID, 
	case 
		when (WoLEnabled = 1) then 'Yes'
		when (WoLEnabled = 0) then 'No'
		end as WoLEnabled, 
	case 
		when (RaiseMomAlertsOnFailure = 1) then 'Yes'
		when (RaiseMomAlertsOnFailure = 0) then 'No'
		end as RaiseMomAlertsOnFailure, 
	case 
		when (DisableMomAlerts = 1) then 'Yes'
		when (DisableMomAlerts = 0) then 'No'
		end as DisableMomAlerts, 
	case 
		when (EnforcementEnabled = 1) then 'Yes'
		when (EnforcementEnabled = 0) then 'No'
		end as EnforcementEnabled, 
	case 
		when (ContainsExpiredUpdates = 1) then 'Yes'
		when (ContainsExpiredUpdates = 0) then 'No'
		end as ContainsExpiredUpdates, 
	TargetCollectionSiteID, 
	case 
		when (UserUIExperience = 1) then 'Yes'
		else 'No'
		end as UserUIExperience, 
	case 
		when (AssignmentEnabled = 1) then 'Yes'
		when (AssignmentEnabled = 0) then 'No'
		end as AssignmentEnabled, 
	case 
		when (LimitStateMessageVerbosity = 1) then 'Yes'
		when (LimitStateMessageVerbosity = 0) then 'No'
		end as LimitStateMessageVerbosity, 
	StateMessageVerbosity, 
	case 
		when (StateMessagePriority = 0) then 'Urgent'
		when (StateMessagePriority = 1) then 'High'
		when (StateMessagePriority = 5) then 'Normal'
		when (StateMessagePriority = 10) then 'Low'
		end as StateMessagePriority, 
	case 
		when (PersistOnWriteFilterDevices = 1) then 'Yes'
		when (PersistOnWriteFilterDevices = 0) then 'No'
		end as PersistOnWriteFilterDevices, 
	AssignedCI_UniqueID, 
	ApplicationName, 
	AppModelID
FROM 
	v_ApplicationAssignment