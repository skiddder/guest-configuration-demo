# Guest Configuration Demo for arc-enabled Windows machines

Please note: In order to apply a guest configuration, you need Azure VM guest configuration extension version 1.26.24 or later, or Arc agent 1.10.0 or later on the target machine.

## Assign a built-in Azure Guest Configuration Policy to your arc-enabled VM

As a demo we are using the built-in Guest Configuration Policy 'Audit Windows machines missing any of specified members in the Administrators group' to automatically add the user 'FrodoBaggins' to the local administrators group.

1. In the Azure Portal navigate to Policy. In section Authoring select Definitions. 
2. Set the scope to the tenant root group.

![img-01](resources/img-01-policy-definition.png)

3. Optionally, filter for Category == Guest Configuration
4. Search for 'Audit Windows machines missing any of specified members in the Administrators group'
5. Click the name of the policy and then Assign policy

![img-02](resources/img-02-policy-assign-scope.png)

6. Change the scope to the resource group where your arc-enabled VM is located
7. In Parameters tab check the box 'Include Arc connected servers' and type 'FrodoBaggins' in the 'Members to include' field.

![img-03](resources/img-03-policy-assign-params.png)

8. In Remediation tab check the box 'Create a Managed Identity'
9. Click Review and Create and then Assign

## Create a custom Guest Configuration Policy and assign it

In this section, we are going to built a custom guest configuration from scratch.

### Prerequisites
- Windows computer with PowerShell (min version 7.1.3)
```
$PSVersionTable.PSVersion
```
- Az PowerShell module
```
Install-Module -Name Az -Repository PSGallery -Force
```
- GuestConfiguration module
```  
# Install the machine configuration DSC resource module from PowerShell Gallery
Install-Module -Name GuestConfiguration
```
- PSDesiredStateConfiguration (min version 2.0.7)
```
# Install PSDesiredStateConfiguration version 2.0.7 (the stable release)
Install-Module -Name PSDesiredStateConfiguration -RequiredVersion 2.0.7
```
### Build a custom configuration
First thing we need is a configuration we want to apply. In this demo we will use an environment variable as example. The guest configuration will ensure that the environment variable 'MC_ENV_Demo01' is present and set to the value 'This was set by machine configuration'. This is achieved by the PowerShell script 01_authorConfig.ps1. The script creates a mof file as output which defines the configuration we want to apply.
Review the script and execute it:
```
.\01_authorConfigs.ps1
```

Now, we need to create an assignable package which can be used by a guest configuration policy. This is achieved using the script 02_createDemoPackage.ps1. The script uses the mof file from the previous step to create a zip package - in this case 'Demo01.zip'.

```
.\02_createDemoPackage.ps1
```

Before you deploy the package you can test your configuration package. The arc agent is executed with Local System, therefore you should exeucte the test scripts also as Local System to ensure it's behaving the same as on your target machines.

```
.\03_testConfigurationPackage.ps!
```

### Create a custom guest configuration policy
In order to create a custom guest configuration policy, the target machines must be able to access the configuration defintion package (.zip file). In a production scenario you would probably use an Azure storage account with appropriate access control for this. In this demo, we are just using the public url of the zip file in this repository to keep focus on writing the policy.

The followin script creates a custom policy named 'AddEnvVarDemo Policy' at the tenant root group. This scope is standard for policy definitions, because you can only assign this policy at the same or lower scope as the definition is located. So using tenent root scope ensures that you can assign the policy anywhere you need it.

Before you run the following script, you need to login to Azure using the tenant parameter. Else the script is not able to authenticate, due to interactive MFA required on the tenant root level.

```
.\04_createPolicy.ps1
```

### Assign the policy
Now that the policy definition is published you can assign the policy in the same fashion as the built-in policies:
1. In the Azure Portal navigate to Policy. In section Authoring select Definitions. 
2. Set the scope to the tenant root group.
3. Optionally, filter for Category == Guest Configuration
4. Search for 'AddEnvVarDemo Policy'
5. Click the name of the policy and then Assign policy
6. Change the scope to the resource group where your arc-enabled VM is located
7. In Parameters tab check the box 'Include Arc connected servers'.
8. In Remediation tab check the box 'Create a Managed Identity'
9. Click Review and Create and then Assign

### Remediation
Please note, that the policy will not remediate VMs that already existed before you apply new polices. This behavior is per default. In order to AutoCorrect the desired configuration, you need to create a remediation task.
