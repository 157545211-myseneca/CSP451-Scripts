source ./logo_csp451.sh
source ./setup_config.sh
echo -e "Loaded variabels & functions without error"

function host_vm_from_custom_image () {
vm_name=$1
nic_name=$2
hyperv_gen=$3

echo -e "---------------------------------------------------"
echo -e "Create VM from Custom Image: $vm_name"
echo -e "---------------------------------------------------"
echo -e "Check if it already exists ---"
if [[ $(az vm list -g $RG_NAME -o tsv --query "[?name=='$vm_name']") ]]
then
    echo
    echo -e "exists!"
    az vm show -g $RG_NAME --name $vm_name --query id 
else
    echo -e "doesn't exist!"
    base_name=$(echo -e "$vm_name" | tr '[:upper:]' '[:lower:]')
    image_name="$base_name-ver-$target_version"
    echo -e "Imaage Name: $image_name"
    echo
    echo -e "Check if custom image exists ---"
    image_id=$(az image show -g $RG_NAME --name $image_name -o tsv --query id)
    if [[ "$image_id" ]];then
        echo
        echo -e "exists!\n"
        echo -e "Creating VM ..."
        echo -e "$image_id \n"
        az vm create --name $vm_name -g $RG_NAME  \
            --location $LOCATION \
            --admin-password $ADMIN_PW --admin-username $USER_NAME \
            --image  $image_name \
            --size  $VM_SIZE \
            --storage-sku $OS_DISK_SKU \
            --security-type $SECURITY_TYPE \
            --data-disk-delete-option Delete \
            --nics  $nic_name \
            --no-wait

    echo
    echo -e "VM created!\n"
    fi
fi 
echo
echo -e "---------------------------------------------------"
echo -e "DONE!"
echo -e "---------------------------------------------------"
echo
}

vm_name="$Host_VM_name"
nic_name="$Host_NIC_name"
hyperv_gen="V1"
windows_vm_from_custom_image $vm_name $nic_name $hyperv_gen