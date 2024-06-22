echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "backend_config.sh"
source ./backend_config.sh
echo "Loaded image variabes without error"


if [[ -z $1 ]]; then
    echo
    echo "---------------------------------------------------"
    echo "target_version parameter not provided"
    echo "Usage: ./image_create.sh <target_version>"
    echo "---------------------------------------------------"
    echo
    exit 1
fi

target_version=$1

function windows_vm_from_custom_image () {
vm_name=$1
nic_name=$2
hyperv_gen=$3

base_name=$(echo "$vm_name" | tr '[:upper:]' '[:lower:]')
image_name="$base_name-ver-$target_version"
echo $image_name

image_id=$(az image show -g $RG_NAME --name $image_name -o tsv --query id)
echo $image_id

echo "---------------------------------------------------"
echo "VM: $vm_name from image: $image_name"
echo "---------------------------------------------------"
echo "Check if it already exists ---"
if [[ $(az vm list -g $RG_NAME -o tsv --query "[?name=='$vm_name']") ]]
then
    echo "exists!"
    az vm show -g $RG_NAME --name $vm_name --query id 
else
    echo "doesn't exist!"
    echo "Do you want to create VM: $vm_name? (yes/no)"
    read -r answer
    if [[ "$answer" == "yes" ]]; then

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
        # if [ $? ]; then echo "Returned Error! Aborting!"; exit 2; fi
    fi
fi
}

echo 
echo "---------------------------------------------------"
echo "Virtual Machines from Custom Images"
echo "---------------------------------------------------"
echo

vm="$VM_WC"
nic_name="$NIC_WC"
hyperv_gen="V1"
windows_vm_from_custom_image $vm $nic_name $hyperv_gen

vm="$VM_WS"
nic_name="$NIC_WS"
hyperv_gen="V1"
windows_vm_from_custom_image $vm $nic_name $hyperv_gen

vm="$VM_LR"
nic_name="$NIC_LR"
hyperv_gen="V1"
windows_vm_from_custom_image $vm $nic_name $hyperv_gen

vm="$VM_LS"
nic_name="$NIC_LS"
hyperv_gen="V1"
windows_vm_from_custom_image $vm $nic_name $hyperv_gen

echo
echo "---------------------------------------------------------------------------------"
echo "Wait until all vm are created successfully before configuring auto-shutdown"
echo "---------------------------------------------------------------------------------"
echo

vm_status_flag="false"

while [ $vm_status_flag != "true" ]
do
    echo "Waits for $sleep_time seconds before checking VM statu ---"
    sleep $sleep_time
    echo "Checking VM status now ---"
    echo ""
    if [[ $(az vm list -g $RG_NAME -o tsv --query "[?name=='$VM_WC']") \
        && $(az vm list -g $RG_NAME -o tsv --query "[?name=='$VM_WS']") \
        && $(az vm list -g $RG_NAME -o tsv --query "[?name=='$VM_LR']") \
        && $(az vm list -g $RG_NAME -o tsv --query "[?name=='$VM_LS']") ]]
    then
        vm_status_flag="true"
    else
        vm_status_flag="false"
    fi
    if [ $vm_status_flag == "true" ];  then 
        echo "All VMs created without error!"
        echo "Script will continue to configure auto-shutdown for all VMs"
        break
    else
        echo "Script is unable to query all VM successfully, this may be due to VM creation error!"
        echo "You can exit at this stage, but this will be risky"
        echo "You are about to exit without configuring auto-shutdown configuration"
        echo "Do you want to exit? (yes/no)"
        read -r answer
        if [ "$answer" == "yes" ]; then
            echo "You must run configure_auto_shutdown.sh script to configure auto-shutdown for all VMs"
            echo "Exiting!" 
            exit 2
        fi
    fi
done

echo
echo "---------------------------------------------------"
echo "Configuring Auto shutdown for all VMs at $shutdown_time UTC"
echo "---------------------------------------------------"
echo

shutdown_time=$shutdown_time

for vm_name in "${vm_list[@]}"
do
echo "---------------------------------------------------------------------"
echo "Creating auto-shutdown schedule for: $vm_name"
echo "---------------------------------------------------------------------"
# read -r answer
# if [[ "$answer" == "yes" ]]; then
    az vm auto-shutdown -g $RG_NAME -n $vm_name --location $LOCATION --time $shutdown_time
# fi
done

echo
echo "---------------------------------------------------"
echo "VMs created without error!"
echo "END!"
echo "---------------------------------------------------"
echo
