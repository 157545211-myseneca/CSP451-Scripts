function client_vm_create () {
vm_name=$1
image_name=$2
nic_name=$3

echo -e "---------------------------------------------------"
echo -e "VM: $vm_name"
echo -e "---------------------------------------------------"
echo -e "Check if it already exists ---"
if [[ $(az vm list -g $RG_NAME -o tsv --query "[?name=='$vm_name']") ]]
then
    echo
    echo -e "exists!"
    az vm show -g $RG_NAME --name $vm_name --query id 
else
    echo -e "doesn't exist!"
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
    az vm list -g $RG_NAME -o tsv --query "[?name=='$vm_name']"
fi
echo
echo -e "---------------------------------------------------"
echo -e "DONE!"
echo -e "---------------------------------------------------"
echo
}

function host_vm_create () {
vm_name=$1
image_name=$2
nic_name=$3

echo -e "---------------------------------------------------"
echo -e "VM: $vm_name"
echo -e "---------------------------------------------------"
echo -e "Check if it already exists ---"
if [[ $(az vm list -g $RG_NAME -o tsv --query "[?name=='$vm_name']") ]]
then
    echo
    echo -e "exists!"
    az vm show -g $RG_NAME --name $vm_name -o tsv --query id 
else
    echo -e "doesn't exist!"
    az vm create --name $vm_name -g $RG_NAME  \
            --location $LOCATION \
            --admin-password $ADMIN_PW --admin-username $USER_NAME \
            --image  $image_name \
            --size  $VM_SIZE \
            --storage-sku $OS_DISK_SKU \
            --security-type "Standard" \
            --data-disk-delete-option Delete \
            --security-type $SECURITY_TYPE \
            --nics  $nic_name \
            --ssh-key-values $public_sshkey_file \
            --no-wait
    echo
    echo -e "VM created!\n"
    az vm list -g $RG_NAME -o tsv --query "[?name=='$vm_name']"
fi
echo
echo -e "---------------------------------------------------"
echo -e "DONE!"
echo -e "---------------------------------------------------"
echo
}

function configure_auto_shutdown(){

vm_name=$1

echo 
echo -e "---------------------------------------------------------------------------------"
echo -e "Configure Auto Shutdown $shutdown_time UTC for VM: $vm_name"
echo -e "---------------------------------------------------------------------------------"
echo 
echo "Wait $sleep_time seconds before configuring auto-shutdown"
echo
sleep $sleep_time

echo -e "Checking VM status ---"
if [[ $(az vm list -g $RG_NAME -o tsv --query "[?name=='$vm_name']") ]];then
    echo "Script is unable to query $vm_name successfully, this may be due to VM creation error!"
    echo "You are about to exit without configuring auto-shutdown configuration"
else
    echo -e "Creating auto-shutdown schedule for: $vm_name"
    result="$(az vm auto-shutdown -g $RG_NAME -n $vm_name --location $LOCATION --time $shutdown_time)"
fi

echo
echo -e "---------------------------------------------------"
echo -e "DONE!"
echo -e "---------------------------------------------------"
echo
}

echo
echo "---------------------------------------------------"
echo "Do you want to create networking resources? (yes/no)"
read -r answer
if [[ "$answer" == "yes" ]];then
    create_networking_resources
fi

echo
echo "---------------------------------------------------"
echo "Do you want to create VMs? (yes/no)"
read -r answer
if [[ "$answer" == "yes" ]]; then
    client_vm_create "$Client_VM_name" "$Client_IMG" "$Client_NIC_name"
    host_vm_create "$Host_VM_name" "$Host_IMG" "$Host_NIC_name"

    configure_auto_shutdown "$Client_VM_name"
    configure_auto_shutdown "$Host_VM_name"
fi

# echo
# echo "---------------------------------------------------"
# echo "Do you want to create kubernetes control and worker nodes? (yes/no)"
# read -r answer
# if [[ "$answer" == "yes" ]];then
#     kubernetes_cluster_create
# fi

echo
echo "---------------------------------------------------"
echo "Do you want to destroy networking resources? (yes/no)"
read -r answer
if [[ "$answer" == "yes" ]];then
    destroy_networking_resources
fi
