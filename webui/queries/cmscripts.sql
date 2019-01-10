select distinct 
	ScriptName,
        ScriptGuid,
        ScriptVersion,
        Author,
        CASE 
        	when (ApprovalState = 0) then 'Pending'	
		when (ApprovalState = 1) then 'Denied'
		when (ApprovalState = 3) then 'Approved'
		else 'Unknown' end as Approval,
        LastUpdateTime
FROM vSMS_Scripts