function vnet_create() {

vnet_name=$1
address_prefix=$2

echo 
echo -e "---------------------------------------------------"
echo -e "Virtual Network (VNet): $vnet_name"
echo -e "---------------------------------------------------"
echo
echo -e "Check if it already exists ---\n"

if [[ $(az network vnet list -g $RG_NAME -o tsv --query "[?name=='$vnet_name']") ]]
then
    echo
    echo -e "exists!\n"
    az network vnet show -g $RG_NAME --name $vnet_name -o tsv --query id 
else
    echo -e "doesn't exist!"
    echo -e "Creating Virtual Network ...\n"
    result="$(az network vnet create -g $RG_NAME \
            --name $vnet_name \
            --location $LOCATION \
            --address-prefix $address_prefix)"
    echo
    echo -e "Virtual Network created!\n"
    az network vnet list -g $RG_NAME -o tsv --query "[?name=='$vnet_name']"
fi
echo
echo -e "---------------------------------------------------"
echo -e "DONE!"
echo -e "---------------------------------------------------"
echo
}

function subnet_create(){

vnet_name=$1
subnet_name=$2
address_prefix=$3

echo 
echo -e "---------------------------------------------------"
echo -e "Virtual Subnets: $subnet_name"
echo -e "---------------------------------------------------"
echo
echo -e "Check if it already exists ---\n"
if [[ $(az network vnet subnet list -g $RG_NAME --vnet-name $vnet_name -o tsv --query "[?name=='$subnet_name']") ]]
then
    echo
    echo -e "exists!\n"
    az network vnet subnet show -g $RG_NAME --vnet-name $vnet_name --name $subnet_name -o tsv --query id 
else
    echo -e "doesn't exist!"
    echo -e "Creating Subnet ...\n"
    result="$(az network vnet subnet create --name $subnet_name \
        -g $RG_NAME \
        --vnet-name $vnet_name \
        --address-prefix $address_prefix)"
    echo
    echo -e "Subnet created!\n"
    az network vnet subnet list -g $RG_NAME --vnet-name $vnet_name -o tsv --query "[?name=='$subnet_name']"
fi
echo
echo -e "---------------------------------------------------"
echo -e "DONE!"
echo -e "---------------------------------------------------"
echo
}

function peering_create(){

host_vnet=$1
client_vnet=$2

echo 
echo -e "---------------------------------------------------"
echo -e "VNet Peerings: $Peer_HC and $Peer_CH"
echo -e "---------------------------------------------------"
echo
echo -e "Check if it already exists ---\n"
client_peer=$(az network vnet peering list -g $RG_NAME --vnet-name $client_vnet -o tsv --query "[?name=='$Peer_CH'].[id]")
host_peer=$(az network vnet peering list -g $RG_NAME --vnet-name $host_vnet -o tsv --query "[?name=='$Peer_HC'].[id]")
if [ "$client_peer" -a "$host_peer" ];then
    echo
    echo -e "exists!\n"
    az network vnet peering show -g $RG_NAME --vnet-name $host_vnet --name $Peer_HC -o tsv --query id 
    az network vnet peering show -g $RG_NAME --vnet-name $client_vnet --name $Peer_CH -o tsv --query id 
else
    echo -e "Creating VNET Peering ... \n"
    echo -e "Query Client VNET ID ---\n"
    clientid=$(az network vnet show -g $RG_NAME --name $client_vnet --query id --out tsv) 
    echo -e "$clientid"
    echo 
    echo -e "Query Host VNET ID ---\n"
    hostid=$(az network vnet show -g $RG_NAME --name $host_vnet --query id --out tsv) 
    echo -e "$hostid"

    echo -e "Check if any of the NET IDs is NULL ...\n"
    if [ -z "$hostid" -o -z "$clientid" ] ; then
            echo -e "One of the IDs: host or client is null "
            echo -e "program will abort now!!"
            exit 2
    fi

    echo -e "Creating VNET Peering using IDs ... \n"
    echo
    result="$(az network vnet peering create -g "$RG_NAME" \
        --name "$Peer_HC" \
        --vnet-name "$host_vnet" \
        --allow-vnet-access \
        --allow-forwarded-traffic \
        --remote-vnet "$clientid")"

    result="$(az network vnet peering create -g "$RG_NAME" \
        --name "$Peer_CH" \
        --vnet-name "$client_vnet" \
        --allow-vnet-access \
        --allow-forwarded-traffic \
        --remote-vnet "$hostid")"
    
    echo
    echo -e "Network Peerings created!\n"
    az network vnet peering list -g $RG_NAME --vnet-name $host_vnet -o tsv --query "[?name=='$Peer_HC'].[id]"
    az network vnet peering list -g $RG_NAME --vnet-name $client_vnet -o tsv --query "[?name=='$Peer_CH'].[id]"
fi

echo
echo -e "---------------------------------------------------"
echo -e "DONE!"
echo -e "---------------------------------------------------"
echo
}

function nsg_create () {

nsg_name=$1

echo 
echo -e "---------------------------------------------------"
echo -e "Network Security Group (NSG): $nsg_name"
echo -e "---------------------------------------------------"
echo
echo -e "Check if it already exists ---\n"
if [[ $(az network nsg list -g $RG_NAME -o tsv --query "[?name=='$nsg_name']") ]]
then
    echo
    echo -e "exists!\n"
    az network nsg show -g $RG_NAME -n $nsg_name --out tsv --query id 
else
    echo -e "doesn't exist!"
    echo -e "Creating Network Security group ...\n"
    result="$(az network nsg create -g "$RG_NAME" --name "$nsg_name" --location "$LOCATION")"
    echo
    echo -e "Network Security groups created!\n"
    az network nsg list -g $RG_NAME -o tsv --query "[?name=='$nsg_name']"
fi
echo
echo -e "---------------------------------------------------"
echo -e "DONE!"
echo -e "---------------------------------------------------"
echo
}

function nic_create () {

nic_name=$1
vnet_name=$2
subnet_name=$3
nsg_name=$4

echo -e "---------------------------------------------------"
echo -e "Network Interface Card (NIC): $nic_name"
echo -e "---------------------------------------------------"
echo -e "Check if it already exists ---\n"
if [[ $(az network nic list -g $RG_NAME -o tsv --query "[?name=='$nic_name']") ]]
then
    echo 
    echo -e "exists!\n"
    az network nic show -g $RG_NAME --name $nic_name --query id 
else
    echo -e "doesn't exist!"
    echo -e "Creating Network Interface Card ...\n"
    result="$(az network nic create --name $nic_name \
        -g $RG_NAME \
        --vnet-name $vnet_name \
        --subnet $subnet_name \
        --network-security-group $nsg_name \
        --location $LOCATION )"
    echo
    echo -e "Network Interface Card Created!"
    az network nic list -g $RG_NAME -o tsv --query "[?name=='$nic_name']"
fi
echo
echo -e "---------------------------------------------------"
echo -e "DONE!"
echo -e "---------------------------------------------------"
echo
}

function create_networking_resources()
{
echo -e "---------------------------------------------------"
echo -e "Create Networking Backend Resources"
echo -e "---------------------------------------------------"

vnet_create "$Host_vnet_name" "$Host_vnet_address"
subnet_create "$Host_vnet_name" "$Host_subnet_name" "$Host_subnet_address"

peering_create "$Host_vnet_name" "$Client_vnet_name"

nsg_create "$Client_NSG_name"
nsg_create "$Host_NSG_name" 

nic_create "$Client_NIC_name" "$Client_vnet_name" "$Client_subnet_name" "$Client_NSG_name"
nic_create "$Host_NIC_name" "$Host_vnet_name" "$Host_subnet_name" "$Host_NSG_name"
}

function destroy_networking_resources()
{
echo -e "---------------------------------------------------"
echo -e "Destroy Networking Backend Resources"
echo -e "---------------------------------------------------"

echo
echo -e "az network nic delete -g $RG_NAME --name $Client_NIC_name"
az network nic delete -g $RG_NAME --name $Client_NIC_name
echo
echo -e "az network nic delete -g $RG_NAME --name $Host_NIC_name " 
az network nic delete -g $RG_NAME --name $Host_NIC_name 

echo
echo -e "az network nsg delete -g $RG_NAME --name $Client_NSG_name "
az network nsg delete -g $RG_NAME --name $Client_NSG_name 

echo
echo -e"az network vnet subnet delete -g $RG_NAME --vnet-name $Host_vnet_name --name $Host_subnet_name "
az network vnet subnet delete -g $RG_NAME --vnet-name $Host_vnet_name --name $Host_subnet_name

echo
echo -e "az network vnet peering delete -g $RG_NAME --name $Peer_HC --vnet-name $Host_vnet_name "
az network vnet peering delete -g $RG_NAME --name $Peer_HC --vnet-name $Host_vnet_name
echo
echo -e "az network vnet peering delete -g $RG_NAME --name $Peer_CH --vnet-name $Client_vnet_name "
az network vnet peering delete -g $RG_NAME --name $Peer_CH --vnet-name $Client_vnet_name

echo
echo -e "az network vnet delete -g $RG_NAME --name $Host_vnet_name"
az network vnet delete -g $RG_NAME --name $Host_vnet_name

echo
echo -e "---------------------------------------------------"
echo -e "DONE!"
echo -e "---------------------------------------------------"
echo
}