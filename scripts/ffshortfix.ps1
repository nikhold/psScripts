###Use to fix profile shortcuts after Firefox update
###Must run as administrator!!!
##Personal Profile shortcut
#get firefox.exe path
$prog=(get-command firefox).source
#set shortcut path
$targetLoc1="C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox - Personal.lnk"
#create shortcut object
$WshShell1 = New-Object -ComObject WScript.Shell
$shortcutObject1 = $WshShell1.CreateShortcut($targetLoc1)
#input shortcut path
$shortcutObject1.TargetPath = "$prog"
#input profile
$shortcutObject1.Arguments="-P default-release"
#input icon location
#This is optional, but if you would like to use this then
#obtain the ico file you want to use and but the location below
#$shortcutObject1.IconLocation=""
#save
$shortcutObject1.Save()

###This can be done with mutliple profiles!!!
##Just copy and paste the code above below and alter the variables to your liking :)
