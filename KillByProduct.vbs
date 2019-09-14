'Created by Terry Bates 14/09/2019 in his personal time because apparently systems engineering is dead @ STG...
'
'Kill applications based on their executables product name, will kill all of them.
'MMMmm using powershell, gets me around the script signing issues...
'
'Usage: Replace the "$_.Product -eq 'Ruler'" in the pscommand variable to the product you want kill.
'
'Example: ...$_.Product -eq 'Tendcare' } |...
'

Dim procresults

'Create the powershell command, this trims out any blank rows returned by default.
pscommand = "Get-Process | Where-Object {$_.Product -eq 'Ruler' } | select ID | ft -HideTableHeaders | Out-String | ForEach-Object { $_.Trim() }"
cmd = "powershell.exe -noprofile -command " & pscommand

Set shell = CreateObject("WScript.Shell")
Set executor = shell.Exec(cmd)
executor.StdIn.Close

'Wscript.Echo executor.StdOut.ReadAll
'Do While executor.StdOut.AtEndOfStream <> True , vbCrlf
procresults = Split(executor.StdOut.ReadAll, vbCrlf)

'Check to see if these is anything to kill, if not exit.
unsetString = " "
If unsetString = Join(procresults) Then
	Wscript.Echo "Nothing to kill"
	WScript.Quit
End If

'Use the blank array function to remove any blank lines
procresults = RemoveArrayElement(procresults, "")

'Create the command 
killcmd = "TASKKILL /PID " & Join(procresults, " /PID ")

'Run the killcmd command
shell.Exec (killcmd)

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