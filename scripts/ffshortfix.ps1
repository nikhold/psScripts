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
$shortcutObject1.IconLocation="C:\Users\nikee\Documents - Copy\Programs\[Programs] Windows\FirefoxShortcutFixer\firefox.ico.ico"
#save
$shortcutObject1.Save()

##School profile shortcut
#set shortcut path
$targetLoc2="C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox - School.lnk"
#create shortcut object
$WshShell2 = New-Object -ComObject WScript.Shell
$shortcutObject2 = $WshShell2.CreateShortcut($targetLoc2)
#input shortcut path
$shortcutObject2.TargetPath = "$prog"
#input profile
$shortcutObject2.Arguments="-P School"
#input icon location
$shortcutObject2.IconLocation="C:\Users\nikee\Documents - Copy\Programs\[Programs] Windows\FirefoxShortcutFixer\firefox.ico.ico"
#save
$shortcutObject2.Save()