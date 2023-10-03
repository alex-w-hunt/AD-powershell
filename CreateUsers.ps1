#-- Generate a geneic password to be used initally for all accounts --#
$password = ConvertTo-SecureString "Password123" -AsPlainText -Force

#-- Read in the CSV file given by HR --#
$newusers = Import-Csv newusers.csv

#-- Create variables to be used for each user --#
$newusers | ForEach-Object {
    Write-Host Creating user: $username -BackgroundColor Black -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    $lastname = $_.Name.Split(' ')[1]
    $firstname = $_.Name.Split(' ')[0]
    $username = $firstname.toLower()[0] + $lastname.toLower()
    #-- Add the user to AD --#
    New-ADUser  -Name $_.Name `
                -GivenName $firstname `
                -Surname $lastname `
                -DisplayName $username `
                -AccountPassword $password `
                -Office $_.Office `
                -Title $_.Title `
                -EmployeeID $username `
                -PasswordNeverExpires $true `
                -Enabled $true `
                -Path "OU=_TESTUSER,$(([ADSI]`"").distinguishedName)"
}

#-- For test purposes, otherwise use ChangePasswordAtLogon --#
#-- For future use splatting instead of line continuation --#