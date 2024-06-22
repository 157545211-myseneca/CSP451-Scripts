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

function custom_image_create () {

vm_name=$1
os_type=$2
hyperv_gen=$3
image_ver=$4

base_name=$(echo "$vm_name" | tr '[:upper:]' '[:lower:]')
image_name="$base_name-ver-$target_version"
osDisk_id=$(az vm get-instance-view -g $RG_NAME -n $vm_name -o tsv --query storageProfile.osDisk.managedDisk.id)

echo 
echo "---------------------------------------------------"
echo "Image Name: $image_name"
echo "---------------------------------------------------"

echo "Check if it already exists ---"
if [[ $(az image list -g $RG_NAME -o tsv --query "[?name=='$image_name']") ]]
then
    echo "exists!"
    az image show -g $RG_NAME --name $image_name -o tsv --query id 
else
    echo "doesn't exist!"
    echo "Do you want to create image: $image_name? (yes/no)"
    read -r answer
    if [[ "$answer" == "yes" ]]; then

        az image create --name $image_name \
                        --resource-group $RG_NAME \
                        --source $osDisk_id \
                        --data-disk-caching None \
                        --hyper-v-generation $hyperv_gen \
                        --location $LOCATION  \
                        --os-disk-caching None \
                        --os-type $os_type \
                        --storage-sku $OS_DISK_SKU

        echo "Iamge Created!"
    fi
fi

}


echo 
echo "---------------------------------------------------"
echo "Custom Managed Image Creation"
echo "---------------------------------------------------"
echo

os_type="Windows"
vm=$VM_WC
hyperv_gen="V1"
custom_image_create "$vm" "$os_type" "$hyperv_gen" "$target_version"
vm=$VM_WS
hyperv_gen="V1"
custom_image_create "$vm" "$os_type" "$hyperv_gen" "$target_version" 

os_type="Linux"
vm=$VM_LR
hyperv_gen="V1"
custom_image_create "$vm" "$os_type" "$hyperv_gen" "$target_version"
vm=$VM_LS
hyperv_gen="V1"
custom_image_create "$vm" "$os_type" "$hyperv_gen" "$target_version"

echo "Image List"
az image list -g $RG_NAME --out table

echo
echo "---------------------------------------------------"
echo "Custom Managed Images created without error!"
echo "END!"
echo "---------------------------------------------------"
echo
