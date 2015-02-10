On Error Resume Next

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20

Dim intPercentUsed, strHostname, arrIgnore, intIgnore, re
Set re = New RegExp
With re
    .Pattern = ""
    .Global = False
    .IgnoreCase = True
End With

'if any drives to ignore are provided, store in array
arrIgnore = Split(Wscript.Arguments.Item(0),",")

'gather LogicalDisk counters
Set objWMIService = GetObject("winmgmts:\\localhost\root\CIMV2")
Set colItems = objWMIService.ExecQuery( _
            "SELECT * FROM Win32_PerfFormattedData_PerfDisk_LogicalDisk", _
            "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)
                
'do for each of the drives                
For Each objItem In colItems
    'set ignored flag to zero
    intIgnore = 1
    intPercentUsed = ""
    
    'catch drives that don't have a size (ie. removable drives)
    'If objItem.FreeSpace > -1 Then 
    '    intIgnore = 0
    'Else
    '    intIgnore = 1
    'End If
    
    'set ignore flag if drive is one that should be ignored
    For Each str In arrIgnore
        If str = "" Then
            Exit For
        Else
            str = Replace(str,"/","\\")
            re.Pattern = "^" + str + "$"
        End If
        
'        If re.Pattern <> "" & re.Test(objItem.name) Then
        If re.Test(objItem.name) Then
            intIgnore = 0
            Exit For
        End If
    Next
    
    If objItem.Name = "_Total" Then
        intIgnore = 1
    End If
    
    'if drive should not be ignored, calculate used percentage and echo value
    If intIgnore = 0 Then
        intPercentUsed = 100 - objItem.PercentFreeSpace
        intGBfree = objItem.FreeMegabytes / 1024;
        WScript.Echo objItem.Name & ".used " & intPercentUsed
        WScript.Echo objItem.Name & ".GBfree " & intGBfree
    End If
Next