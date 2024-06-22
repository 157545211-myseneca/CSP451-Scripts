source ./network_config.sh
source ./backend_config.sh
echo -e "Loaded variabes without error"

echo 
echo -e "---------------------------------------------------"
echo -e "Delting Netwrok Security Groups"
echo -e "---------------------------------------------------"
echo
for nsg_name in "${nsg_list[@]}"
do
echo -e "NSG: $nsg_name "
echo -e "Check if it  exists ---"
status="$(az network nsg list -g $RG_NAME \
        -o tsv --query "[?name=='$nsg_name']"  2> /dev/null)"
if [[ "$status" ]];then
    echo
    echo -e "exists!"
    echo -e "Deleteing NSG: $nsg_name"
    az network nsg delete -g $RG_NAME --name $nsg_name
else
    echo
    echo -e "Doesn't exist! Nothing to do ...\n"    
fi

done
