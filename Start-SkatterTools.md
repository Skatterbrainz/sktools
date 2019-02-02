---
external help file: sktools-help.xml
Module Name: sktools
online version: https://github.com/SkatterBrainz/sktools
      http://www.poshserver.net
schema: 2.0.0
---

# Start-SkatterTools

## SYNOPSIS
Powershell Web Server Console application for viewing and managing Active Directory and 
System Center Configuration Manager.
Built with PoSHServer.

## SYNTAX

```
Start-SkatterTools [[-Hostname] <String>] [[-Port] <String>] [[-SSLIP] <String>] [[-SSLPort] <String>]
 [[-SSLName] <String>] [[-HomeDirectory] <String>] [[-LogDirectory] <String>] [[-CustomConfig] <String>]
 [[-CustomChildConfig] <String>] [[-CustomJob] <String>] [[-CustomJobSchedule] <String>] [[-JobID] <String>]
 [[-JobUsername] <String>] [[-JobPassword] <String>] [-JobCredentials] [-SSL] [-DebugMode] [-asJob] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Listens a port to serve web content.
Supports HTML and Powershell.

## EXAMPLES

### EXAMPLE 1
```
Start-PoSHServer -IP 127.0.0.1 -Port 8080
```

### EXAMPLE 2
```
Start-PoSHServer -Hostname "poshserver.net" -Port 8080
```

### EXAMPLE 3
```
Start-PoSHServer -Hostname "poshserver.net" -Port 8080 -asJob
```

### EXAMPLE 4
```
Start-PoSHServer -Hostname "poshserver.net" -Port 8080 -SSL -SSLPort 8443 -asJob
```

### EXAMPLE 5
```
Start-PoSHServer -Hostname "poshserver.net" -Port 8080 -SSL -SSLIP "127.0.0.1" -SSLPort 8443 -asJob
```

### EXAMPLE 6
```
Start-PoSHServer -Hostname "poshserver.net" -Port 8080 -DebugMode
```

### EXAMPLE 7
```
Start-PoSHServer -Hostname "poshserver.net,www.poshserver.net" -Port 8080
```

### EXAMPLE 8
```
Start-PoSHServer -Hostname "poshserver.net,www.poshserver.net" -Port 8080 -HomeDirectory "C:\inetpub\wwwroot"
```

### EXAMPLE 9
```
Start-PoSHServer -Hostname "poshserver.net,www.poshserver.net" -Port 8080 -HomeDirectory "C:\inetpub\wwwroot" -LogDirectory "C:\inetpub\wwwroot"
```

### EXAMPLE 10
```
Start-PoSHServer -Hostname "poshserver.net" -Port 8080 -CustomConfig "C:\inetpub\config.ps1" -CustomJob "C:\inetpub\job.ps1"
```

## PARAMETERS

### -Hostname
Hostname

```yaml
Type: String
Parameter Sets: (All)
Aliases: IP

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Port
Port Number

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SSLIP
SSL IP Address

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SSLPort
SSL Port Number

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SSLName
SSL Port Number

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HomeDirectory
Home Directory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: "$PSScriptRoot\webui"
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogDirectory
Log Directory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomConfig
Custom Config Path

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomChildConfig
Custom Child Config Path

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomJob
Custom Job Path

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomJobSchedule
Custom Job Schedule

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: 5
Accept pipeline input: False
Accept wildcard characters: False
```

### -JobID
Background Job ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JobUsername
Background Job Username

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JobPassword
Background Job User Password

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JobCredentials
Background Job Credentials

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SSL
Enable SSL

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DebugMode
Debug Mode

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -asJob
Background Job

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Display what would happen if you would run the function with given parameters.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts for confirmation for each operation.
Allow user to specify Yes/No to all option to stop prompting.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### None
## NOTES
sktools by David M.
Stein / skatterbrainz
website: https://github.com/SkatterBrainz/sktools

      poshserver 3.7 by Yusuf Ozturk
      Website: http://www.yusufozturk.info
      Email: yusuf.ozturk@outlook.com
      Date created: 09-Oct-2011
      Last modified: 07-Apr-2014

## RELATED LINKS

[https://github.com/SkatterBrainz/sktools
      http://www.poshserver.net](https://github.com/SkatterBrainz/sktools
      http://www.poshserver.net)

