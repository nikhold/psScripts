### script for running background checks on systems
### gather information
## system info
$cInfo = Get-ComputerInfo;
# computer name
$cName = $cInfo.CsName;
# computer OS
$cOS = $cInfo.OsName;
# computer model
$cModel = $cInfo.CsModel;
# time and date
$genDate = $cInfo.OsLocalDateTime;
# break down into other variables
$dayName = $genDate.day;
$monthName = $genDate.month;
$hourName = $genDate.Hour;
$minuteName = $genDate.Minute;
# format for file name
$fileDate = "$monthName-$dayName-$hourName$minuteName";
# OS Uptime
$osUpTime = $cInfo.OsUpTime;
# set restart recommendation if uptime > 3 days
if ($osUpTime.Days -gt 3) {
    $restartWarning = "(RESTART RECOMMENDED!)"
} else {
    $restartWarning = ""
}
# safety check, pass if boot, power supply, and thermal state are safe
if (($cInfo.CsChassisBootupState -and $cInfo.CsPowerSupplyState -and $cInfo.CsThermalState) -eq "Safe") {
    $safetyCheck = "Safe"
} else {
    $safetyCheck = "NEEDS ATTENTION"
}
# powershell version
$pwshVersion = $PSVersionTable.PSVersion;
## drive info
# drive health
$driveStatus = get-physicaldisk | select-object -expandproperty OperationalStatus;
$driveHealth = get-physicaldisk | select-object -expandproperty HealthStatus;
# drive space
# get total drive space
$driveSpaceInfo = Get-WmiObject Win32_LogicalDisk | Select-Object Size, FreeSpace
# get free drive space
$driveFreeSpace = [Math]::round(($driveSpaceInfo.FreeSpace)/1GB, 2)
# calculate used space
$driveUsedSpace = [math]::round(($driveSpaceInfo.Size - $driveSpaceInfo.FreeSpace)/1GB, 2)
## battery info
# battery degradation
# get actual (current) battery capacity
$actualCapacity = get-ciminstance -namespace ROOT\WMI -classname "BatteryFullChargedCapacity" | select-object -expandproperty FullChargedCapacity;
# get original battery capacity
$designedCapacity = Get-WmiObject -Namespace ROOT\WMI -ClassName "BatteryStaticData" | Select-Object -expandproperty DesignedCapacity;
# calculate battery degredation
$batteryDegradation = ([math]::Round(100 - (($actualCapacity / $designedCapacity)*100)));
# get current battery charge
$batteryCharge = (get-WmiObject win32_battery).estimatedChargeRemaining
# get time remaining and set appropriate time unit
$timeRemaining = (get-wmiobject win32_battery).estimatedRunTime
$timeUnit = "minutes"
# test if best format is hours or minutes
if ($timeRemaining -gt 60) {
    # format time into hours and set appropriate time unit
    $timeRemaining = [math]::round(((Get-WmiObject win32_battery).estimatedRunTime)/60, 2)
    $timeUnit = "hours"
}
## 

## output section
clear-host
write-host "MAINTENANCE LOG FOR $cName"
write-host "Date Log Generated: $genDate"
Write-host "--------------------------------"
write-host "SYSTEM:"
write-host "Current Runtime: $osUpTime $restartWarning"
write-host "Safety Check: $safetyCheck"
write-host "Computer Model: $cModel"
write-host "OS Version: $cOS"
write-host "Powershell Version: $pwshVersion"
Write-host "--------------------------------"
write-host "DRIVE:"
write-host "Storage Available: $driveFreeSpace GB"
write-host "Storage Taken: $driveUsedSpace GB"
Write-host "Drive Status: $driveStatus"
write-host "Drive Health: $driveHealth"
Write-host "--------------------------------"
write-host "BATTERY:"
write-host "Current Charge: $batteryCharge%"
write-host "Charge Time Remaining: $timeRemaining $timeUnit"
Write-host "Battery Degraded: $batteryDegradation%"
Write-host "--------------------------------"
## Print/exit section
$outputDecision = read-host "Output Text to .log file? (Y/N)"
if ($outputDecision -eq "Y") {
    if ((test-path -path ./Reports) -eq $FALSE) {new-item -path Reports -ItemType Directory}
    clear-host
    write-output "MAINTENANCE LOG FOR $cName" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "Date Log Generated: $genDate" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    Write-output "--------------------------------" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "SYSTEM:" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "Current Runtime: $osUpTime $restartWarning" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "Safety Check: $safetyCheck" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "Computer Model: $cModel" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "OS Version: $cOS" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "Powershell Version: $pwshVersion" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    Write-output "--------------------------------" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "DRIVE:" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "Storage Available: $driveFreeSpace GB" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "Storage Taken: $driveUsedSpace GB" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    Write-output "Drive Status: $driveStatus" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "Drive Health: $driveHealth" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    Write-output "--------------------------------" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "BATTERY:" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "Current Charge: $batteryCharge%" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    write-output "Charge Time Remaining: $timeRemaining $timeUnit" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    Write-output "Battery Degraded: $batteryDegradation%" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
    Write-output "--------------------------------" | out-file -literalpath "./Reports/maintenanceReport_$fileDate.log" -append
}
 