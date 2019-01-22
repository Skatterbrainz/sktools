$Script:PageTitle   = "CM SQL Server: Database Recovery Models"
$Script:PageCaption = "CM SQL Server: Database Recovery Models"
$content     = ""
$tabset      = ""
$outree      = $null
$query       = $null
$xxx         = ""

try {
    $content += (Get-DbaDbRecoveryModel -SqlInstance $SkCmDbHost -ErrorAction Continue | 
		Select-Object Name,ComputerName,InstanceName,RecoveryModel,SizeMB,Compatibility,LastFullBackup,LastDiffBackup,LastLogBackup | 
        ConvertTo-Html -Fragment) -replace '<table>', '<table id=table1>'

}
catch {
    $content = "<table id=table2><tr><td>Error: $($Error[0].Exception.Message)</td></tr></table>"
}

Write-SkWebContent
