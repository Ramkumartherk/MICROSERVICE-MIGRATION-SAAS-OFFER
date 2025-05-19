# Import Azure PowerShell module
Import-Module Az

# Define your Azure AD client and tenant IDs
$clientId =
$tenantId = 

# Define the client secret
$clientSecret = 

# Authenticate to Azure AD using the service principal
$azureCredential = New-Object PSCredential($clientId, (ConvertTo-SecureString $clientSecret -AsPlainText -Force))
Connect-AzAccount -ServicePrincipal -TenantId $tenantId -Credential $azureCredential

# Set your Azure subscription
$subscriptionId = 
Set-AzContext -SubscriptionId $subscriptionId

# Specify the resource group and virtual machine to delete
$resourceGroupName = "DMAP_SaaS"
$virtualMachineName = "dmapsaasdelete" # Replace with your VM's name
$virtualMachineResourceType = "Microsoft.Compute/virtualMachines"

# Get the specified virtual machine resource
$vmResource = Get-AzResource -ResourceGroupName $resourceGroupName | Where-Object { 
    $_.ResourceType -eq $virtualMachineResourceType -and $_.ResourceName -eq $virtualMachineName 
}

if ($vmResource) {
    $vmIdentifier = "$($vmResource.ResourceType)/$($vmResource.ResourceName)"
    Write-Output "Deleting virtual machine: $vmIdentifier"

    # Try to delete the virtual machine
    Remove-AzResource -ResourceId $vmResource.ResourceId -Force -ErrorAction Stop
    Write-Output "Virtual machine $vmIdentifier deleted successfully."

    # Delete associated resources sequentially

    # Delete network interface
    $nicName = "$virtualMachineName-nic"
    $nic = Get-AzNetworkInterface -ResourceGroupName $resourceGroupName -Name $nicName -ErrorAction SilentlyContinue
    if ($nic) {
        Write-Output "Deleting network interface: $nicName"
        Remove-AzNetworkInterface -Name $nicName -ResourceGroupName $resourceGroupName -Force -ErrorAction Stop
        Write-Output "Network interface $nicName deleted."
    } else {
        Write-Output "Network interface $nicName not found."
    }

    # Delete public IP address
    $publicIpName = "$virtualMachineName-ip"
    $publicIp = Get-AzPublicIpAddress -ResourceGroupName $resourceGroupName -Name $publicIpName -ErrorAction SilentlyContinue
    if ($publicIp) {
        Write-Output "Deleting public IP: $publicIpName"
        Remove-AzPublicIpAddress -Name $publicIpName -ResourceGroupName $resourceGroupName -Force -ErrorAction Stop
        Write-Output "Public IP $publicIpName deleted."
    } else {
        Write-Output "Public IP $publicIpName not found."
    }

    # Delete network security group (NSG)
    $nsgName = "$virtualMachineName-nsg"
    $nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Name $nsgName -ErrorAction SilentlyContinue
    if ($nsg) {
        Write-Output "Deleting NSG: $nsgName"
        Remove-AzNetworkSecurityGroup -Name $nsgName -ResourceGroupName $resourceGroupName -Force -ErrorAction Stop
        Write-Output "NSG $nsgName deleted."
    } else {
        Write-Output "NSG $nsgName not found."
    }

    # Delete virtual network
    $vnetName = "$virtualMachineName-vnet"
    $vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName -ErrorAction SilentlyContinue
    if ($vnet) {
        Write-Output "Deleting virtual network: $vnetName"
        Remove-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName -Force -ErrorAction Stop
        Write-Output "Virtual network $vnetName deleted."
    } else {
        Write-Output "Virtual network $vnetName not found."
    }

    # Delete OS disk
    $osDiskName = "$virtualMachineName-osdisk"
    $osDisk = Get-AzDisk -ResourceGroupName $resourceGroupName -DiskName $osDiskName -ErrorAction SilentlyContinue
    if ($osDisk) {
        Write-Output "Deleting OS disk: $osDiskName"
        Remove-AzDisk -ResourceGroupName $resourceGroupName -DiskName $osDiskName -Force -ErrorAction Stop
        Write-Output "OS disk $osDiskName deleted."
    } else {
        Write-Output "OS disk $osDiskName not found."
    }

} else {
    Write-Output "Virtual machine '$virtualMachineName' not found in resource group '$resourceGroupName'."
}

Write-Output "Virtual machine and associated resources deletion in '$resourceGroupName' completed."
