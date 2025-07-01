# Get the current compliance results for the local machine
Get-GuestConfigurationPackageComplianceStatus -Path ./Demo01.zip

# Test applying the configuration to local machine
Start-GuestConfigurationPackageRemediation -Path ./Demo01.zip