SELECT 
	WSUSServerName,
	WSUSSourceServer,
	SiteCode,
	SyncCatalogVersion,
	LastSuccessfulSyncTime,
	LastSyncState,
	LastSyncStateTime,
	LastSyncErrorCode,
	ReplicationLinkStatus,
	LastReplicationLinkCheckTime
FROM 
	vSMS_SUPSyncStatus