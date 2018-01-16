# get the VMSS model

$vmss = Get-AzureRmVmss -ResourceGroupName resource_group_name -VMScaleSetName VM_scale_set_name

# set the new version in the model data

$vmss.virtualMachineProfile.storageProfile.osDisk.image.uri="$(bakedImageUrl)"

# update the virtual machine scale set model

Update-AzureRmVmss -ResourceGroupName resource_group_name -Name resource_group_name -VirtualMachineScaleSet $vmss