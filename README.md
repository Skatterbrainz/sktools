# sktools (SkatterTools)

SkatterTools PowerShell Module

# Overview

  SkatterTools is a PowerShell module which provides an extension to PoSHServer to view and manage
  Active Directory and System Center Configuration Manager sites from your web browser.

# Install and Setup

  1. Open a PowerShell console using "Run as Administrator"
  2. Install module: ```Install-Module sktools```
  3. Run ```Install-SkatterTools``` function
  4. Edit the "skconfig.txt" file under your Documents folder
  5. In the PowerShell console, type ```Start-SkatterTools``` (minimize console)
  6. Open your web browser, go to http://localhost:8080

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
_Comment = SkatterTools configuration file. Lines with underscore prefix are comments.
_LastUpdated = 02/1/2019 10:56:54
_ModuleVersion = 1902.1.0
_UpdatedBy = sccmadmin
_LocalHost = W10-CM-001
_UserDomain = CONTOSO
SkAPPNAME = SkatterTools
SkTheme = stdark.css
SkADEnabled = TRUE
SkADGroupManage = TRUE
SkCMEnabled = TRUE
SkCmDBHost = cm01.contoso.local
SkCmSMSProvider = cm01.contoso.local
SkCmSiteCode = P01
SkCmCollectionManage = TRUE
SkDebug = TRUE
SkTabSelectAdUsers = All
SkTabSelectAdGroups = All
SkTabSelectAdComputers = All
SkTabSelectCmFiles = A
SkTabSelectCmUsers = All
SkTabSelectCmDevices = All
SkTabSelectCmDevColls = All
SkTabSelectCmUserColls = All
SkCmCollectionCheck = TRUE
SkUseDashboard = TRUE
SkToolsPath = C:\Users\sccmadmin\Documents
```

# Testing Information

sktools was developed with PowerShell 5.1 (aka Windows PowerShell 5.1).  It was also tested with
the following operating systems and products:

* Windows 10 Enterprise x64 1803, 1809, Insider 18323
* Windows Server 2016 Enterprise, Datacenter Edition
* System Center Configuration Manager 1810, 1812, 1901
* SQL Server 2016, 2017
* Internet Explorer 11
* Microsoft Edge
* Google Chrome 72
* Firefox 64
* Brave 0.58

# Known Issues and Limitations

  * sktools interfaces to Configuration Manager use Windows Authentication, and will therefore allow
    the same level of access to ConfigMgr features as the same user would have when using the 
    Configuration Manager administration console.  The same is true with regards to permissions to
    the Active Directory forest and domain environment.
  * Integrated authentication often behaves differently by web browser.  For example, in some browsers
    you may still be prompted to enter credentials when connecting to Configuration Manager or to
    Active Directory.
  * Antivirus and Antimalware products/services may interfere with SkatterTools.
  * Firewall settings may interfere with remote connections to Active Directory, Configuration Manager
    SQL Server, the SMS Provider, and to other Windows machines across the network.

# Warranties and Terms of Use

Terms of use are described in the license document included with the module.
There are NO warranties of any kind whatsoever for this product/service/project.  USE AT YOUR OWN RISK.
Never operate in a production environment without thorough testing and validation. 

# Technical Support

There is no official support provided with this product/project, however, feedback is ALWAYS welcome.
Please submit comments, suggestions, and bug reports, using the "Issues" feature for the sktools 
GitHub repository at https://github.com/Skatterbrainz/sktools/issues.  Enhancement requests will be
reviewed to determine feasibility and responded to accordingly. If your enhancement request is 
approved and implemented, your name will be associated with it in the application.
