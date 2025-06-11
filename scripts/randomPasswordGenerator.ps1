# Set title
$host.UI.RawUI.WindowTitle = "Password Generator"
# Set loop for script (in case of retry)
$retryTest = $TRUE
while ($retryTest -eq $TRUE) {
    # Clear window
    Clear-host
    # Prompt user for length of password
    $length = read-host "Needed Password Length"
    # Prompt user for special characters
    $specialChar = read-host "Special Characters Required? [Y/N]"
    # Test for input other than Y or N
    while ((($specialChar -eq 'Y') -or ($specialChar -eq 'N')) -eq $FALSE) {
        write-host "INVALID: Y or N not selected, try again"
        $specialChar = read-host "Special Characters Required? [Y/N]"
    }
    ### Run generator for no special characters ###
    if ($specialChar -eq 'N') {
        # set character pools
        $upperAlph = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.ToCharArray()
        $lowerAlph = 'abcdefghijklmnopqrstuvwxyz'.ToCharArray()
        $num = '1234567890'.ToCharArray()
        $combPool = $upperAlph + $lowerAlph + $num
        # generate at least one of each category
        $randomString = ($upperAlph|get-random -count 1) + ($lowerAlph|get-random -count 1) + ($num|get-random -count 1)
        # generate rest of random password
        if ($randomString.Length -lt $length) {
            $randomString = $randomString + -join((4..$length) | ForEach-Object {$combPool | Get-Random})
        }
        # Shuffle password
        $randomPassword = -join($randomString.ToCharArray()|get-random -count $length)
        # display password
        Write-host "Generated Password: $randomPassword"
    }
    ### Run generator for special characters ###
    if ($specialChar -eq 'Y') {
        # set character pools
        $upperAlph = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.ToCharArray()
        $lowerAlph = 'abcdefghijklmnopqrstuvwxyz'.ToCharArray()
        $num = '1234567890'.ToCharArray()
        $specialString = '!@#$%^&*()-_=+[]{}|;:,.<>?/'.ToCharArray()
        $combPool = $upperAlph + $lowerAlph + $num + $specialString
        # generate at least one of each category
        $randomString = ($upperAlph|get-random -count 1) + ($lowerAlph|get-random -count 1) + ($num|get-random -count 1) + ($specialString|get-random -count 1)
        # generate rest of random password
        if ($randomString.Length -lt $length) {
            $randomString = $randomString + -join((5..$length) | ForEach-Object {$combPool | Get-Random})
        }
        # Shuffle password
        $randomPassword = -join($randomString.ToCharArray()|get-random -count $length)
        # display password
        Write-host "Generated Password: $randomPassword"
    }
    # Prompt user for retry if password is not desired
    $retry = read-host "Would you like to retry? [Y/N]"
    # Test input other than Y or N
    while ((($retry -eq 'Y') -or ($retry -eq 'N')) -eq $FALSE) {
        write-host "INVALID: Y or N not selected, try again"
        $retry = read-host "Would you like to retry? [Y/N]"
    }
    # Determine whther to retry or not
    if ($retry -eq 'Y') {$retryTest = $TRUE}
    # If not retrying, delete variable from memory to secure password
    if ($retry -eq 'N') {
        $retryTest = $FALSE
        $randomString = $null
        $randomPassword = $null
        # Call .Net Garbage Collector to remove null password strings
        [System.GC]::Collect()
    }
}
