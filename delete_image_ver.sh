echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "backend_config.sh"
source ./backend_config.sh
echo "Loaded variabes without error"


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

echo 
echo "---------------------------------------------------"
echo "Deleting Older Image Versions"
echo "---------------------------------------------------"
echo

for vm_name in "${vm_list[@]}"
do
    if [[ "$vm_name" == "$VM_WS"  ]]; then
        hyperv_gen="V1"
    else    
        hyperv_gen="V2"
    fi

    base_name=$(echo "$vm_name" | tr '[:upper:]' '[:lower:]')
    image_name="$base_name-ver-$target_version"

    echo "---------------------------------------------------"
    echo "Check if image exist: $image_name"
    echo "---------------------------------------------------"
    if [[ $(az image list -g $RG_NAME -o tsv --query "[?name=='$image_name']") ]]
    then
        echo "exists!"
        # echo "Do you want to delete image: $image_name? (yes/no)"
        # read -r answer
        # if [[ "$answer" == "yes" ]]; then
            echo "Deleting Image: $image_name"
            az image delete -g $RG_NAME --name $image_name 
        # fi
    fi
done

echo "Iamge List"
az image list -g $RG_NAME --out table
