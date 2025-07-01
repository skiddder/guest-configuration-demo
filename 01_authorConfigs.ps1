Import-Module -Name PSDscResources

Configuration Demo01 {
    Import-DscResource -ModuleName PSDscResources -Name 'Environment'

    Environment MachineConfigurationDemo {
        Name   = 'MC_ENV_Demo01'
        Value  = 'This was set by machine configuration'
        Ensure = 'Present'
        Target = @('Process', 'Machine')
    }
}

Demo01

# check whether the target file already exists and delete it if it does
if (Test-Path -Path .\Demo01\Demo01.mof) {
    Remove-Item -Path .\Demo01\Demo01.mof -Force
}
Rename-Item -Path .\Demo01\localhost.mof -NewName Demo01.mof -PassThru -Force