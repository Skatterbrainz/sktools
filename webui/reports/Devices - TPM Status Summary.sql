select 
	sys.Name0 as "Machine Name", 
	sys.AD_Site_Name0 as "Site Name",
	TPM.timestamp,
	v_GS_COMPUTER_SYSTEM.Manufacturer0 AS Manufacturer,
	v_GS_COMPUTER_SYSTEM.Model0 AS Model,
	TPM.ManufacturerVersion0 as 'Manufacturer Version',
	case
		when (TPM.SpecVersion0 in ('1.2, 2, 0', '1.2, 2, 1', '1.2, 2, 2', '1.2, 2, 3')) then '1.2' 
		else 'Null' end as "TPM_VERSION",
	case
		when (TPM.IsActivated_InitialValue0 = 1) then 'Yes'
		else 'No' end as "TPM_Activated",
	case 
		when (TPM.IsEnabled_InitialValue0 = 1) then 'Yes'
		else 'No' end as "TPM_Enabled"
from 
	v_GS_TPM TPM
	join v_r_system sys on sys.ResourceID = TPM.ResourceID
	inner join v_GS_COMPUTER_SYSTEM on (v_GS_COMPUTER_SYSTEM.ResourceID = tpm.ResourceID)
order by 
	"TPM_Activated" asc, "TPM_VERSION" desc, TPM.timestamp