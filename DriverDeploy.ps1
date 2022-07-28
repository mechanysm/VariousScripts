#DriverDeploy
#Created by: Terry Bates
#Date: 18/01/2022

#Drivers URL
#https://hpia.hpcloud.hp.com/downloads/driverpackcatalog/HP_Driverpack_Matrix_x64.html

#WMI Queries set to varialbles
$SysManufacturer = (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property Manufacturer | ft -HideTableHeaders | Out-String).Trim()
$SysModel = (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property Model | ft -HideTableHeaders | Out-String).Trim()
$OSArch = (Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property OSArchitecture | ft -HideTableHeaders | Out-String).Trim()
$ImageDrive = (Get-CimInstance -ClassName Win32_LogicalDisk | select DeviceID, VolumeName | Where Volumename -eq "Images" | select DeviceID | ft -HideTableHeaders | Out-String).trim()

Write-Output "Deploying drivers based on the following device variables"
Write-Output ""
    Write-Host -ForegroundColor Yellow "PC Manufacturer: " -NoNewline; Write-Host -ForegroundColor Red "$SysManufacturer"
    Write-Host -ForegroundColor Yellow "PC Model: " -NoNewline; Write-Host -ForegroundColor Red "$SysModel"
    Write-Host -ForegroundColor Yellow "OS Architeture: " -NoNewline; Write-Host -ForegroundColor Red "$OSArch"
    Write-Host -ForegroundColor Yellow "Image\Driver Drive: " -NoNewline; Write-Host -ForegroundColor Red "$ImageDrive"
Write-Output ""

#Keeping the other wait in here as I like it but new one allows skipping
#5..1 | ForEach-Object { Write-Host -NoNewline "`rStarting In $_"; Start-Sleep -Milliseconds 1000 }
Write-Host "Starting in 5 Seconds, press any key to stop" -ForegroundColor Cyan
start-sleep -milliseconds 100; 
$host.ui.RawUI.FlushInputBuffer();
$counter = 0 
$i=0; while(-not $host.UI.RawUI.KeyAvailable -and ($counter++ -lt 75)) { Write-Host -NoNewline ("`r{0}" -f '/-\|'[($i++ % 4)]); start-sleep -Milliseconds 50 }
if ($counter++ -gt 75)
    {
		#To reduce requirement for 2 copies of drivers are DISM doesn't like sym links only and hard links not possible.
		if ($SysModel -eq "HP ProBook 450 G8 Notebook PC")
		{
			$SysModel = "HP ProBook 430 G8 Notebook PC"
			Write-Output "System model changed to $SysModel as drivers are the same"
		}

		if ($SysModel -eq "HP ProBook 450 G7")
		{
			$SysModel = "HP ProBook 430 G7"
			Write-Output "System model changed to $SysModel as drivers are the same"
		}

		if ($SysModel -eq "HP ProBook 450 G6")
		{
			$SysModel = "HP ProBook 430 G6 Notebook PC"
			Write-Output "System model changed to $SysModel as drivers are the same"
		}

		if ($SysModel -eq "HP ZBook Firefly 14 inch G8 Mobile Workstation PC")
		{
			$SysModel = "HP ZBook Firefly 14 G8 Mobile Workstation"
			Write-Output "System model changed to $SysModel as drivers are the same"
		}

		#Inject Device Drivers
		Write-Host -ForegroundColor green "Inject Device Drivers"
		if (Test-Path $ImageDrive\Drivers-to-load\$sysmanufacturer -PathType Container)
		{
			if (Test-Path $ImageDrive\Drivers-to-load\$SysManufacturer\$SysModel -PathType Container)
			{
				if (Test-Path $ImageDrive\Drivers-to-load\$SysManufacturer\$SysModel\$OSArch)
				{
					Dism.exe /Image:W:\ /Add-Driver /Driver:"$ImageDrive\Drivers-to-load\$SysManufacturer\$SysModel\$OSArch" /Recurse
				}
			}
		}
		Else { Write-Host -fore red -back green "Path Does Not Exist - Check that drivers exist in a subfolder at $ImageDrive\Drivers-to-load\$SysManufacturer\$SysModel\$OSArch" }
		Write-Output ""
}