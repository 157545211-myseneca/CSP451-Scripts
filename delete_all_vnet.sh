source ./network_config.sh
source ./backend_config.sh
echo -e "Loaded variabes without error"

echo 
echo -e "---------------------------------------------------"
echo -e "Deleting VNET Peering"
echo -e "---------------------------------------------------"
echo
for peering in "${Peerings_list[@]}"
do
if [[ "$peering" == "$Peer_RT" ]];then
    vnet="$Router_vnet_name"
elif [[ "$peering" == "$Peer_RS" ]];then
    vnet="$Router_vnet_name"
elif [[ "$peering" == "$Peer_SR" ]];then
    vnet="$Server_vnet_name"
elif [[ "$peering" == "$Peer_TR" ]];then
    vnet="$Student_vnet_name"
fi
echo
echo -e "$peering in VNET: $vnet ...\n"
echo -e "Check if it exists ---"
status="$(az network vnet peering list -g $RG_NAME \
        --vnet-name $vnet \
        -o tsv --query "[?name=='$peering']" 2> /dev/null)"
if [[ "$status" ]]; then
    echo
    echo -e "exists!"
    echo -e "Deleteing Peering: $peering\n"
    az network vnet peering delete -g $RG_NAME \
        --name $peering \
        --vnet-name $vnet 
else
    echo
    echo -e "Doesn't exist! Nothing to do ...\n"
fi
done


echo 
echo -e "---------------------------------------------------"
echo -e "Deleting Sunbets and VNETs"
echo -e "---------------------------------------------------"
echo
for vnet in "${VNET_List[@]}"
do 
    echo -e "---------------------------------------------------"
    echo -e "VNET: $vnet"
    echo -e "---------------------------------------------------"
    for subnet in "${Subnet_List[@]}"
    do
        echo
        echo "Subnet: $subnet"
        echo -e "Check if it exists ---"
        status="$(az network vnet subnet list -g $RG_NAME \
                --vnet-name $vnet \
                -o tsv --query "[?name=='$subnet'].["id"]" 2> /dev/null)"
        if [[ "$status" ]];then
            echo
            echo "exists!"
            az network vnet subnet show -g $RG_NAME --vnet-name $vnet --name $subnet -o tsv --query id 
            echo
            echo -e "Deleting Subnet: $subnet in VNET: $vnet ..."
            az network vnet subnet delete --name $subnet \
                -g $RG_NAME \
                --vnet-name $vnet 
        else
            echo
            echo -e "Doesn't exist! Nothing to do ...\n"
        fi
    done
    echo
    echo "VNET: $vnet"
    echo -e "Check if it exists ---"
    status="$(az network vnet list -g $RG_NAME \
        -o tsv --query "[?name=='$vnet'].["id"]" 2> /dev/null)"
    if [[ "$status" ]];then
        echo
        echo "exists!"
        az network vnet show -g $RG_NAME --name $vnet -o tsv --query id 
        echo
        echo -e "Deleting VNET: $vnet ..."
        az network vnet delete --name $vnet -g $RG_NAME 
    else
        echo
        echo -e "Doesn't exist! Nothing to do ...\n"
    fi
done

echo
echo -e "---------------------------------------------------"
echo -e "DONE!"
echo -e "---------------------------------------------------"
echo