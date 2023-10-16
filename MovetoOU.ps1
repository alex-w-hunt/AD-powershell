#-- Get the initial list of information needed to make the OU swaps --#
$officelist = Get-ADUser -Filter * -Properties * | where Office -ne $null | Select Name, Office, ObjectGUID

#-- Iterate through the list checking to see if an OU for the selected parameter exists --#
foreach ($n in $officelist) {
    $OUcheck = "OU=" + $n.Office + ",DC=mylab,DC=com"
    if (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$OUcheck'") {
        Write-Host Adding $n.Name to $n.Office OU -BackgroundColor Black -ForegroundColor Green
        Move-ADObject -Identity $n.ObjectGUID -TargetPath $OUcheck
    } 
    else {
        Write-Host Creating new OU: $n.Office -BackgroundColor Black -ForegroundColor Yellow
        New-ADOrganizationalUnit -Name $n.Office -ProtectedFromAccidentalDeletion $false
        Write-Host Adding $n.Name to $n.Office OU -BackgroundColor Black -ForegroundColor Green
        Move-ADObject -Identity $n.ObjectGUID -TargetPath $OUcheck
    }
}