About
-------------------------
The File System Capacity Logical Disk plug-in monitor will return the used space for each of the drives listed in the 
LogicalDisk performance counter as a percent value on Windows system.

If desired, it is possible to ignore drives from being compared with the Exclude Drives field.  The list of drives 
should be comma delimited and can accept regular expressions, if desired. Because regular expression strings are 
accepted, instead of using the backslash when specifying Windows directories, use a forward slash.

For example, to ignore drives A:, L:, and the range of drives M:\Data1 to M:\Data5, enter A:,L:,M:/Data[1-5].


Agent Installation
-------------------------
Windows:
1. Place the fscapLogicalDisk.vbs file in the directory up.time Agent directory, which is
	"C:\Program Files (x86)\uptime software\up.time agent" 
	or "C:\Program Files\uptime software\up.time agent" 
   
2. Add entry to Custom Script section in up.time Agent Console tool
	a. Click Start -> up.time Agent -> up.time Agent Console
	b. Click on the Advanced menu and select Custom Scripts
	c. Enter the following:
	Command Name: fscaplogical
	Path to Script: cscript //nologo "C:\Program Files (x86)\uptime software\up.time agent\fscapLogicalDisk.vbs"
	d. Click the Add/Edit button, then the Close button, and click Yes to restart the up.time Agent service