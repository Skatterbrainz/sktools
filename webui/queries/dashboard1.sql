Select Distinct 
    case 
      when (Status = 0) then 'Green'
      when (Status = 1) then 'Yellow'
      when (Status = 2) then 'Red'
      end as StatName,
	Count(*) as Counters
FROM v_SiteSystemSummarizer
group by Status 
