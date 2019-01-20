select distinct 
	[FileName],
	[FileDescription],
	[FileID],
	[FileVersion],
	[FileSize],
	Count(*) as [Copies] 
from 
	v_GS_SoftwareFile 
group by 
	FileName,FileID,FileVersion,FileDescription,FileSize
order by
	FileName, FileID