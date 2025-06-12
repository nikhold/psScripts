#clear space and set title
Clear-host
$host.UI.RawUI.WindowTitle = "Backup Routine"
#set begin value
$begin = 5
### Since this version is public, some values have been changed to be anonymized
### Therefore these values will have to be edited before the script will work
### Comments starting with ## will denote the needed changes
## replace "D:\" or "E:\" with desired drive letters
#test if specified letter drive is present. If not, ask user to retry or exit
while(((Test-Path -path D:\) -or (Test-path -path E:\)) -eq $FALSE) {
    #Set system choices
    $choices = [System.Management.Automation.Host.ChoiceDescription[]] @(
    "&Retry", "&Cancel")
    #set default choice to cancel, error title, and message text
    $defaultChoice = 0 
    $title = "ERROR: Proper External Drive Not Detected"
    $message = "Select an option:"
    #run system choice menu
    $choice = $host.ui.PromptForChoice($title, $message, $choices, $defaultChoice)
    #execute choice 1 (retry) or choice 2 (exit)
    switch ($choice) {
        0 {Test-path -path D:\; Test-path -path E:\; Clear-host} #choice 1
        1 {exit} #choice 2
}}
## replace "D:\", "E:\", and $L(used to determine sizing, must match desired drive letters respectively) with desired drive letters, 
## and $directory(download location) or $searchPath(directory containing folder to be copied) with desired folders
#determine if upload or download drive is detected, and set locations accordingly
$D = Test-path -path D:\
if ($D -eq $TRUE) {$directory = "D:\folderName"; $L = "D"; $searchPath = "C:\Users\name"; $header = "Download" 
} else {$directory = "C:\Users\name"; $L = "E"; $searchPath = "E:\"; $header = "Upload"}
#run loop for script
while ($begin -lt 6) {
    #display information about type of drive detected
    Write-host "External ${header} Drive Detected"
    #retrieve freespace of inserted drive
    $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='${L}:'" | Select-Object Size, FreeSpace
    #determine freespace of drive in gigabytes
    $space = [Math]::round(($disk.FreeSpace / 1GB),2)
    #determine used space in bytes
    $usedOriginal = [Math]::round(($disk.Size - $disk.FreeSpace),2)
    #test if bytes can be converted to kilobytes, megabytes, or gigabytes
    #run kigabyte test and set variables to display proper size
    if (($usedOriginal -gt 1024) -and ($usedOriginal -lt 1048576)) {$used = [Math]::round(($disk.Size - $disk.FreeSpace) / 1KB)
    write-host "Space Used: $used KB"}
    #run megabyte test and set variables to display proper size 
    if (($usedOriginal -gt 1048576) -and ($usedOriginal -lt 1073741824)) {$used = [Math]::round(($disk.Size - $disk.FreeSpace) / 1MB)
    write-host "Space Used: $used MB"}
    #run gigabyte test and set variables to display proper size
    if ($usedOriginal -gt 1073741824) {$used = [Math]::round(($disk.Size - $disk.FreeSpace) / 1GB)
    write-host "Space Used: $used GB"}
    #display available drive space
    write-host "Space Available: $space GB"
    #ask user for folder to be copied
    $hinput = read-host "What folder would like to copy?"
    #find folder within given search directory and filter by user input
    $folder = @(Get-ChildItem -path $searchpath -recurse -directory -filter $hinput)
    #clear window to improve readability
    clear-host
    #test if folder exists
    #if not, prompt user for next course of action
    while ($folder.length -eq 0) {$choices = [System.Management.Automation.Host.ChoiceDescription[]] @(
        "&Retry", "&Cancel")
        #set default choice to cancel, error title, and message text
        $defaultChoice = 1
        $title = "ERROR: Folder Not Found"
        $message = "Select an option:"
        #run system choice menu
        $choice = $host.ui.PromptForChoice($title, $message, $choices, $defaultChoice)
        #execute choice 1 (retry) or choice 2 (exit)
        switch ($choice) {
            #choice 1
            0 {clear-host;
                #display information about type of drive detected 
                Write-host "External ${header} Drive Detected"
                #retrieve freespace of inserted drive
                $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='${L}:'" | Select-Object Size, FreeSpace
                #determine freespace of drive in gigabytes
                $space = [Math]::round(($disk.FreeSpace / 1GB),2)
                #determine used space in bytes
                $usedOriginal = [Math]::round(($disk.Size - $disk.FreeSpace),2)
                #test if bytes can be converted to kilobytes, megabytes, or gigabytes
                #run kigabyte test and set variables to display proper size
                if (($usedOriginal -gt 1024) -and ($usedOriginal -lt 1048576)) {$used = [Math]::round(($disk.Size - $disk.FreeSpace) / 1KB)
                write-host "Space Used: $used KB"} 
                #run megabyte test and set variables to display proper size 
                if (($usedOriginal -gt 1048576) -and ($usedOriginal -lt 1073741824)) {$used = [Math]::round(($disk.Size - $disk.FreeSpace) / 1MB)
                write-host "Space Used: $used MB"}
                #run gigabyte test and set variables to display proper size
                if ($usedOriginal -gt 1073741824) {$used = [Math]::round(($disk.Size - $disk.FreeSpace) / 1GB)
                write-host "Space Used: $used GB"}
                #display available drive space
                write-host "Space Available: $space GB"
                #ask user for folder to be copied
                $hinput = read-host "What folder would like to copy?"
                #find folder within given search directory and filter by user input, then clear window for readability
                $folder = @(Get-ChildItem -path $searchpath -recurse -directory -filter $hinput); Clear-host}
                #choice 2
            1 {exit}
}}
    #get size of folder to be copied
    $fsize = (((get-childitem -literalpath $folder.FullName -recurse | Measure-Object -Property Length -Sum).sum))
    #test if size can be converted to kilobytes, megabytes, or gigabytes
    #run kigabyte test and set variables to display proper size
    if (($fsize -gt 1024) -and ($fsize -lt 1048576)) {$fsize = (((get-childitem -literalpath $folder.FullName -recurse | Measure-Object -Property Length -Sum).sum) / 1KB)
    write-host "Folder found. File Size: $([math]::round($fsize,2)) KB." }
    #run megabyte test and set variables to display proper size 
    if (($fsize -gt 1048576) -and ($fsize -lt 1073741824)) {$fsize = ((Get-childitem -literalpath $folder.FullName -recurse | Measure-Object -Property Length -Sum).sum / 1MB)
    write-host "Folder found. File Size: $([math]::round($fsize,2)) MB." }
    #run gigabyte test and set variables to display proper size
    if ($fsize -gt 1073741824) {$fsize = ((Get-childitem -literalpath $folder.FullName -recurse | Measure-Object -Property Length -Sum).sum / 1GB)
    write-host "Folder found. File Size: $([math]::round($fsize,2)) GB."}
    #pause to allow user to read folder size and decide to continue
    pause
    #copy using Robocopy.exe, mirrors current directory structure, no output, clear window and display success message
    Robocopy.exe $folder $directory /mir > nul; Clear-Host; write-host "Files copied successfully!"
    #list choices
    $choices = [System.Management.Automation.Host.ChoiceDescription[]] @(
    "&View", "&Retry", "&Exit")
    #set default choice to view, introduce options, and message text
    $defaultChoice = 0
    $title = "Would you like to view your file, copy another, or exit?"
    $message = "Select an option:"
    #run system choice
    $choice = $host.ui.PromptForChoice($title, $message, $choices, $defaultChoice)
    #execute choice 1 (view), choice 2 (retry), or choice 3 (exit)
    switch ($choice) {
        #choice 1, open in file explorer
        0 { explorer $directory ; exit }
        #choice 2, clear window and restart loop
        1 {Clear-host}
        #choice 3, exit script
        2 {exit}
}}
