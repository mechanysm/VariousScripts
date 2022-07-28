#CUDeploy
#Created by: Terry Bates
#Date: 28/07/2022

#WMI Queries set to varialbles
$ImageDrive = (Get-CimInstance -ClassName Win32_LogicalDisk | select DeviceID, VolumeName | Where Volumename -eq "Images" | select DeviceID | ft -HideTableHeaders | Out-String).trim()


#Inject CU Package
Write-Host -ForegroundColor green "Inject CU Package"

#Keeping the other wait in here as I like it but new one allows skipping
#5..1 | ForEach-Object { Write-Host -NoNewline "`rStarting In $_"; Start-Sleep -Milliseconds 1000 }
Write-Host "Starting in 5 Seconds, press any key to stop" -ForegroundColor Cyan
start-sleep -milliseconds 100; 
$host.ui.RawUI.FlushInputBuffer();
$counter = 0 
$i=0; while(-not $host.UI.RawUI.KeyAvailable -and ($counter++ -lt 75)) { Write-Host -NoNewline ("`r{0}" -f '/-\|'[($i++ % 4)]); start-sleep -Milliseconds 50 }
if ($counter++ -gt 75)
    {

		if (Test-Path $ImageDrive\CU -PathType Container)
			{
				Dism.exe /Image:W:\ /Add-Package /PackagePath:"$ImageDrive\CU\" /ScratchDir:$($usb.scratch)
		}
		Else { Write-Host -fore red -back green "CU Path Does Not Exist - Check that CU folder exists in $ImageDrive" }
		Write-Output ""
	}