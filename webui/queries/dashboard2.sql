SELECT DISTINCT
	StatName, Count(*) as Counters
FROM (
SELECT DISTINCT 
    ComponentName,
    case 
        when (Status = 0) then '#248f24'
        when (Status = 1) then '#cccc00'
        when (Status = 2) then '#990000'
        end as StatName,
    MAX([Infos]) as Info,
    MAX([Warnings]) as Warning,
    MAX([Errors]) as [Error] 
FROM 
    vSMS_ComponentSummarizer 
GROUP BY
    ComponentName, LastContacted, Status, State) AS T1
GROUP BY StatName