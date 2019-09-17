'Created by Terry Bates 17/09/2019 in his personal time because apparently systems engineering is dead @ STG...
'
'** V2 **
'
'Kill applications based on their executables product name, will kill all of them.
'MMMmm using powershell, gets me around the script signing issues...
'
'Usage: Change productname variable to the product you want kill.
'
'Example: productname = "Trendcare"
'

Dim shell, fso, procfile, procresults, filelocation, productname
Const ForReading = 1, TristateTrue = -1, KeepQuiet = 0

Set shell = WScript.CreateObject("WScript.Shell")
Set fso  = CreateObject("Scripting.FileSystemObject")

'Change me to product you want to kill all process instances of.
productname = "ruler"

'Where you want to write the results of powershell Get-Process command
filelocation = "c:\windows\temp\TasksToKill.txt"

'Create the powershell command, this trims out any blank rows returned by default.
pscommand = "powershell.exe -noprofile -command Get-Process | Where-Object {$_.Product -eq '"& productname & "' } | select ID | ft -HideTableHeaders | Out-String | ForEach-Object { $_.Trim() } | Out-File -FilePath " & filelocation

'Run it > Open File > Read contents > Close file
getresults = shell.Run(pscommand, KeepQuiet, true)
Set procfile = fso.OpenTextFile(filelocation, ForReading, False, TristateTrue)
procresults = Split(procfile.ReadAll, vbCrLf)
procfile.Close

'Check to see if these is anything to kill, if not exit.
unsetString = " "
If unsetString = Join(procresults) Then
	WScript.Quit
End If

'Use the blank array function to remove any blank lines
procresults = RemoveArrayElement(procresults, "")

'Create the kill command 
killcmd = "TASKKILL /PID " & Join(procresults, " /PID ")

'Run the killcmd command... quietly
killprocs = shell.Run (killcmd, KeepQuiet, true)

'Remove blank Array items
Function RemoveArrayElement(ByVal TheArray, ByVal Item)
  Dim S, N
  S = ""
  For N = 0 To UBound(TheArray)
    If StrComp(TheArray(N), Item, vbTextCompare) <> 0 Then
      If S <> "" Then
        S = S & vbTab & TheArray(N)
      Else
        S = TheArray(N)
      End If
    End If
  Next
  RemoveArrayElement = Split(S, vbTab)
End Function