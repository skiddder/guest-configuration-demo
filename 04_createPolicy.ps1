### Attention: Ensure you have run 'Connect-AzAccount -TenantId $tenantId' before executing this script, because else it will fail with an error.

#Set parameters according to your environment
$contentUri = "https://github.com/skiddder/guest-configuration-demo/raw/refs/heads/main/Demo01.zip" 

$name = "AddEnvVarDemo Policy"
# retrieve tenant Id from Azure CLI
$tenantId = az account show --query tenantId -o tsv

#Define Policy Parameters
$PolicyConfig      = @{
    PolicyId      = (New-Guid).guid
    ContentUri    = $contentUri
    DisplayName   = $name
    Description   = $name
    Path          = '.\policies\'
    Platform      = 'Windows'
    PolicyVersion = "1.0.0"
    Mode          = 'ApplyAndAutoCorrect'
}

# Create the policy definition file
$configurationPolicy = New-GuestConfigurationPolicy @PolicyConfig

# Publish new policy from definition file
New-AzPolicyDefinition -Name $name -Policy $configurationPolicy.Path -ManagementGroupName $tenantID 