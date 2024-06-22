echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "Loaded variabes without error"

echo 
echo "---------------------------------------------------"
echo "Route Table: $RT_Name"
echo "---------------------------------------------------"
echo
echo "Check if it already exists ---"
if [[ $(az network route-table list -g $RG_NAME -o tsv --query "[?name=='$RT_Name']") ]]
then
    echo "exists!"
    az network route-table show -g $RG_NAME --name $RT_Name -o tsv --query id 
else
    echo "doesn't exist!"
    echo "Do you want to create Route Table: $RT_Name? (yes/no)"
    read -r answer
    if [[ "$answer" == "yes" ]]; then
        echo "Creating Route Table ---"
        az network route-table create -g $RG_NAME --name $RT_Name --location $LOCATION
        if [[ $(az network route-table list -g $RG_NAME -o tsv --query "[?name=='$RT_Name']") ]]
        then
            echo "Completed!"
            echo "Created with id:"
            az network route-table show -g $RG_NAME --name $RT_Name -o tsv --query id
        else
            echo "Failed resource creation, program will abort now!!"
            exit 3
        fi
    fi
fi

echo
echo "---------------------------------------------------"
echo "Do you want to create Routes? (yes/no)"
read -r answer
   if [[ "$answer" == "yes" ]]; then
    echo "Creating Routes in Route Table: $RT_NAME"
    echo

    az network route-table route create -g $RG_NAME \
            --route-table-name $RT_Name \
            -n $Route_to_Server \
            --next-hop-type VirtualAppliance \
            --address-prefix $Server_Route_Address \
            --next-hop-ip-address $Virtual_Appliance

    az network route-table route create -g $RG_NAME \
            --route-table-name $RT_Name \
            -n $Route_to_Client \
            --next-hop-type VirtualAppliance \
            --address-prefix $Client_Route_address \
            --next-hop-ip-address $Virtual_Appliance
          echo "Netwrok Peerings created!"
    
    echo "Routes Created!"
    echo "Route List"
    az network route-table route list -g $RG_NAME --route-table-name $RT_Name -o table
    fi

echo
echo "---------------------------------------------------"
echo "Do you want to create Ruote Table Associations? (yes/no)"
read -r answer
   if [[ "$answer" == "yes" ]]; then
    echo "Creating Subnet Associations to Route Table: $RT_NAME"
    echo

    az network vnet subnet update -n $Server_Subnet_association \
            --vnet-name $Server_vnet_name \
            -g $RG_NAME \
            --route-table $RT_Name

    az network vnet subnet update -n $Client_Subnet_association \
            --vnet-name $Student_vnet_name \
            -g $RG_NAME --route-table $RT_Name

    echo "Associations Created!"
    fi

echo
echo "---------------------------------------------------"
echo "Route Table and Routes created without error!"
echo "END!"
echo "---------------------------------------------------"
echo

