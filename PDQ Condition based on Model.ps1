If(Get-WmiObject -Class:Win32_ComputerSystem -Filter:"Model LIKE '%Surface Go%'" -ComputerName:localhost)
{ Exit 0 }
Else
{ Exit 1 }