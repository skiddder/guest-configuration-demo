# Create a package that will audit and apply the configuration (Set)
$params = @{
    Name          = 'Demo01'
    Configuration = './Demo01/Demo01.mof'
    Type          = 'AuditAndSet'
    Force         = $true
}
New-GuestConfigurationPackage @params