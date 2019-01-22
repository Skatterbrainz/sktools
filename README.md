# sktools (SkatterTools)

SkatterTools PowerShell Module

# Overview

  SkatterTools is a PowerShell module which provides an extension to PoSHServer to view and manage
  Active Directory and System Center Configuration Manager sites from your web browser.

# Install and Setup

  1. Open a PowerShell console using "Run as Administrator"
  2. Install module: ```Install-Module sktools```
  3. Import module: ```Import-Module sktools```
  4. Run ```Install-SkatterTools``` function
  5. Edit the "skconfig.txt" file under your Documents folder
  6. In the PowerShell console, type ```Start-SkatterTools``` (minimize console)
  7. Open your web browser, go to http://localhost:8080

# Updating the Module

  * To update the module, open a PowerShell console using "Run as Administrator"
  * Type ```Update-Module sktools -Force```
  * If a session was already running, terminate and restart it (e.g. ```Start-SkatterTools```)
  
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
