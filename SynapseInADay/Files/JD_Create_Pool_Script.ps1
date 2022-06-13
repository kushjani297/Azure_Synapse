# Pre-requisites
#1-	You need to have an Azure Subscription.
#2-	Latest Version of the PowerShell Az Module  .
#3-	Latest version of the Az.Synapse PowerShell Module.


#Variable setup:

Connect-AzAccount
#Set-AzSubscription - replace this with your subscription
Set-AzContext -SubscriptionName "PFE Subscription"

# The data center and resource name for your resources
$resourcegroupname = "jdrgps"
$location = "North Central US"

#Azure Data Lake Storage Gen2 Storage Account name - letters/numbers only, 3-24 characters, no dashes; change this 
$storageaccountname = "jdadls2ps"

# Setup a Azure Synapse Workspace name and Filesystem
$SynapseWorkSpacename = "jdsynworkspaceps"
$StorageaccountFS = "jdadlsfileps"

# Set an admin name and password for your database
# The sign-in information for the server
$adminlogin = "jdsqladmin"
$password = "P@ssw0rd1"

$password = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($adminlogin, $password)

# The ip address range that you want to allow to access your server - add your ip address here
$startip = "0.0.0.0"
$endip = "255.255.255.255"

# The SQL Pool database name  MUST BE 15 characters at the most - change this
$dwdatabasename = "syninadaydwol"
$PerfLevelSLO = "DW500c"

#Create the Azure Resource Group
New-AzResourceGroup -Name $resourcegroupname -Location $location


# Create the ADLS gen2 Storage
New-AzStorageAccount -ResourceGroupName $resourcegroupname `
  -Name $storageaccountname `
  -Location $location `
  -SkuName Standard_RAGRS `
  -Kind StorageV2 `
  -EnableHierarchicalNamespace $True

# Create the Azure Synapse Workspace
New-AzSynapseWorkspace -ResourceGroupName $resourcegroupname `
 -Name $SynapseWorkSpacename `
 -Location $location `
 -DefaultDataLakeStorageAccountName $storageaccountname `
 -DefaultDataLakeStorageFilesystem $StorageaccountFS `
 -SqlAdministratorLoginCredential $creds `

# Create Firewall rule to give access
New-AzSynapseFirewallRule -WorkspaceName $SynapseWorkSpacename -AllowAllAzureIP `

# Create the Azure SQL Pool
New-AzSynapseSqlPool -WorkspaceName $SynapseWorkSpacename -Name $dwdatabasename -PerformanceLevel $PerfLevelSLO
 