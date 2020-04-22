##############################################################################################
# Grant SQL Server account access to Lock Pages in Memory & Perform Volume Maintenance Tasks #
##############################################################################################

# Update following variables to your environment
$TempLocation = "C:\Temp"
$SQLServiceAccount = "sql-packer-vm\SVC_SQLPACKERVM_SQL" #Account used for the SQL Service
$SQLInstance = "MSSQLSERVER"

# Check if temp location exists and create if it doesn't
IF ((Test-Path $TempLocation) -eq $false)
{
  New-Item -ItemType Directory -Force -Path $TempLocation
  Write-Host "Folder $TempLocation created"
}

# Lines to update in the cfg file
$ChangeFrom = "SeManageVolumePrivilege = "
$ChangeTo = "SeManageVolumePrivilege = $SQLServiceAccount, SQLServerSQLAgentUser$" + $env:computername + "`$" + "$SQLInstance,"

$ChangeFrom2 = "SeLockMemoryPrivilege = "
$ChangeTo2 = "SeLockMemoryPrivilege = $SQLServiceAccount,"

# Export current Security Policy config
$fileName = "$TempLocation\SecPolExport.cfg"
Write-Host "Exporting Security Policy to file"
secedit /export /cfg $filename

# Update Perform Volume Maintenance Tasks Settings
(Get-Content $fileName) -replace $ChangeFrom, $ChangeTo | Set-Content $fileName

# Update or Add Lock Pages in Memory Settings
IF ((Get-Content $fileName) | where { $_.Contains("SeLockMemoryPrivilege") }) {
  Write-Host "Appending line containing SeLockMemoryPrivilege with $SQLServiceAccount"
  (Get-Content $fileName) -replace $ChangeFrom2, $ChangeTo2 | Set-Content $fileName
}else {
  Write-Host "Adding new line containing SeLockMemoryPrivilege"
  Add-Content $filename "`nSeLockMemoryPrivilege = $SQLServiceAccount"
}

# Import new Security Policy cfg (using '1> $null' to keep the output quiet)
Write-Host "Importing Security Policy..."
secedit /configure /db secedit.sdb /cfg $fileName 1> $null
Write-Host "Security Policy has been imported"
