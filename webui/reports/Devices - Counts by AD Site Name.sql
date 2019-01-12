SELECT DISTINCT
	case
		when (AD_Site_Name0 IS NULL) then 'Default'
		else AD_Site_Name0 end as ADSiteName,
	COUNT(*) AS Computers
FROM
	dbo.v_R_System
GROUP BY
	AD_SITE_Name0
ORDER BY
	ADSiteName