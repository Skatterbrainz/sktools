SELECT 
	v_R_User.User_Name0 as [UserName],
    v_R_User.Unique_User_Name0 AS UserDNSName, 
    v_R_User.Full_User_Name0 AS FullName, 
    v_R_User.Windows_NT_Domain0 AS UserDomain, 
    v_R_User.ResourceID, 
    v_R_User.Department, 
    v_R_User.Title, 
    v_R_User.Mail0 as Email, 
    v_R_User.User_Principal_Name0 AS UPN, 
    v_R_User.Distinguished_Name0 AS UserDN, 
    v_R_User.SID0 AS SID, 
    u2.Unique_User_Name0 AS Mgr 
FROM 
    v_R_User LEFT OUTER JOIN 
    v_R_User AS u2 ON 
	v_R_User.manager = u2.Distinguished_Name0 
