echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "backend_config.sh"
source ./backend_config.sh
echo "Loaded variabes without error"

echo 
echo "---------------------------------------------------"
echo "Deleting Vistual Machines"
echo "---------------------------------------------------"
echo
for vm_name in "${vm_list[@]}"
do
echo "---------------------------------------------------"
echo "Check if exist: $vm_name"
echo "---------------------------------------------------"
if [[ $(az vm list -g $RG_NAME -o tsv --query "[?name=='$vm_name']") ]]
then
    echo "exists!"
    osDisk_id=$(az vm get-instance-view -g $RG_NAME -n $vm_name -o tsv --query storageProfile.osDisk.managedDisk.id)
    echo "osDisk_id: $osDisk_id"
    echo "Deleteing VM: $vm_name"
    az vm delete -g $RG_NAME --name $vm_name --yes
    az disk delete --ids $osDisk_id --yes
fi
done
