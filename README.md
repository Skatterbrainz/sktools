# sktools (SkatterTools)

SkatterTools PowerShell Module

# Overview

  SkatterTools is a PowerShell module which provides an extension to PoSHServer to view and manage
  Active Directory and System Center Configuration Manager sites from your web browser.

# Install and Setup

  1. Install module: ```Install-Module sktools```
  2. Import module: ```Import-Module sktools```
  3. Run ```Install-SkatterTools``` function
  4. Edit the "skconfig.txt" file under your Documents folder
  5. In the PowerShell console, type ```Start-SkatterTools``` (minimize console)
  6. Open your web browser, go to http://localhost:8080

# skconfig.txt options

The example below is the default file configuration after using ```Install-SkatterTools```
In most cases, you will want to change the SkCmDbHost, SkCmSMSProvider and SkCmSiteCode values.

```
_Comment = SkatterTools configuration file. Created by Set-SkDefaults
_LastUpdated = 01/20/2019 19:34:25
_UpdatedBy = sccmadmin
_LocalHost = W10-CM-002
SkAPPNAME = SkatterTools
SkTheme = stdark.css
SkADEnabled = TRUE
SkADGroupManage = TRUE
SkCMEnabled = TRUE
SkCmDBHost = cm01.contoso.local
SkCmSMSProvider = cm01.contoso.local
SkCmSiteCode = P01
SkCmCollectionManage = TRUE
SkDebug = FALSE
```
