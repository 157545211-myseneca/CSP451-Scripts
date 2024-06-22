source ./network_config.sh
source ./backend_config.sh
echo -e "Loaded variabes without error"

echo 
echo -e "---------------------------------------------------"
echo -e "Deleting Network Interface Cards"
echo -e "---------------------------------------------------"
echo
for nic_name in "${nic_list[@]}"
do
echo -e "NIC: $nic_name "
echo -e "Check if it  exists ---"
status="$(az network nic list -g $RG_NAME \
        -o tsv --query "[?name=='$nic_name']"  2> /dev/null)"
if [[ "$status" ]];then
    echo
    echo -e "exists!"
    echo -e "Deleteing NIC: $nic_name"
    az network nic delete -g $RG_NAME --name $nic_name
else
    echo
    echo -e "Doesn't exist! Nothing to do ...\n"    
fi
done
