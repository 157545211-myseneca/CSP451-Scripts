echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "backend_config.sh"
source ./backend_config.sh
echo "Loaded variabes without error"

echo 
echo "---------------------------------------------------"
echo "Netwrok Security Groups"
echo "---------------------------------------------------"
echo
echo "Do you want to create Netwrok Security Groups? (yes/no)"
read -r answer
if [[ "$answer" == "yes" ]] 
then
    for item in "${nsg_list[@]}"
    do
        echo "Creating NSG: $item ---"
        az network nsg create -g $RG_NAME --name $item --location $LOCATION
    done
    echo "Netwrok Security groups created!"
    az network nsg list -g $RG_NAME --out table 
fi

echo
echo "---------------------------------------------------"
echo "Network Security Groups created without error!"
echo "END!"
echo "---------------------------------------------------"
echo
