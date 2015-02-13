On Error Resume Next

'This is a modified version of the fscap-LogicalDisk script uses an optional 
'include filter instead of an ignore filter
'For the original see https://github.com/uptimesoftware/fscap-logical-disk-monitor


Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20

Dim intPercentUsed, strHostname, arrIgnore, intIgnore, re
Set re = New RegExp
With re
    .Pattern = ""
    .Global = False
    .IgnoreCase = True
End With

'Function to help check if an array is empty
Function IsArrayDimmed(arr)
   IsArrayDimmed = False
   If IsArray(arr) Then
     On Error Resume Next
     Dim ub : ub = UBound(arr)
     If (Err.Number = 0) And (ub >= 0) Then IsArrayDimmed = True
   End If  
 End Function


'if any drives to include are provided, store in array
arrIgnore = Split(Wscript.Arguments.Item(0),",")

arrIgnoreIsEmpty = IsArrayDimmed(arrIgnore)

'gather LogicalDisk counters
Set objWMIService = GetObject("winmgmts:\\localhost\root\CIMV2")
Set colItems = objWMIService.ExecQuery( _
            "SELECT * FROM Win32_PerfFormattedData_PerfDisk_LogicalDisk", _
            "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)
                
'do for each of the drives                
For Each objItem In colItems
    'if arrIgnore is empty, then initially set our flag to true
    'So that all drives are displayed in the output

    If arrIgnoreIsEmpty <> 0 Then
        intIgnore = 1
    Else
        'Otherwise we want to ignore all drives by default, and only 
        'include the ones that match our filters
        intIgnore = 0
    End If
    intPercentUsed = ""
    
    'unset ignore flag if drive is one that should be included
    For Each str In arrIgnore
        If str = "" Then
            Exit For
        Else
            str = Replace(str,"/","\\")
            re.Pattern = "^" + str + "$"
        End If
        
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
        intGBfree = int(objItem.FreeMegabytes / 1024 )
        WScript.Echo objItem.Name & ".used " & intPercentUsed
        WScript.Echo objItem.Name & ".GBfree " & intGBfree
    End If
Next