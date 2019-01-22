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

# Default Port Setting

By default, SkatterTools runs on TCP port 8080.  If you prefer another port, use the -Port parameter
when launching the service.  For example, ```Start-SkatterTools -Port 8181```

# skconfig.txt options

If you will be using SkatterTools with a Configuration Manager site environment, you will need
to configure the settings in the skconfig.txt file, which is created in your Documents folder
after using the ```Install-SkatterTools``` function.

If you modify the skconfig.txt file while SkatterTools is running, you will need to terminate the
PowerShell console which is running the PoSHServer service, and restart it.  If you also have the
SkatterTools web console open, you can either refresh or close and re-open the browser.

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
