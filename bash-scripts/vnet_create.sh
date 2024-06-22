echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "Loaded variabes without error"

vnet=$Router_vnet_name
address_prefix=$Router_vnet_address
subnet_list=( "${Router_Subnets_list[@]}" )
echo 
echo "---------------------------------------------------"
echo "VNET: $vnet: $address_prefix"
echo "---------------------------------------------------"
echo
echo "Check if it already exists ---"
if [[ $(az network vnet list -g $RG_NAME -o tsv --query "[?name=='$vnet']") ]]
then
      echo "exists!"
      az network vnet show -g $RG_NAME --name $vnet --query id 
else
   echo "doesn't exist!"
   echo "Do you want to create $vnet: $address_prefix? (yes/no)"
   read -r answer
   if [[ "$answer" == "yes" ]]; then
      echo "Creating VNET ---"
      az network vnet create -g $RG_NAME \
            --name $vnet \
            --location $LOCATION \
            --address-prefix $address_prefix
      if [[ $(az network vnet list -g $RG_NAME -o tsv --query "[?name=='$vnet']") ]]
      then
         echo "Completed!"
         echo "Created with id:"
         az network vnet show -g $RG_NAME --name $vnet --query id
      else
         echo "Failed resource creation, program will abort now!!"
         exit 3
      fi
   fi
fi
echo
echo "---------------------------------------------------"
echo "Subnets: $vnet: $address_prefix"
echo "---------------------------------------------------"
echo
for item in "${subnet_list[@]}"
   do
      if [[ ${item:0:2} == "SN" ]]
      then
         subnet_name=$item
      else
         subnet_prefix=$item
         echo "Check if subnet $subnet_name: $subnet_prefix already exists ---"
         if [[ $(az network vnet subnet list -g $RG_NAME --vnet-name $vnet -o tsv --query "[?name=='$subnet_name']") ]]
         then
            echo "exists!"
            az network vnet subnet show -g $RG_NAME --vnet-name $vnet --name $subnet_name -o tsv --query id 
         else
            echo "doesn't exist!"
            echo "Do you want to create subnets for $vnet: $subnet_prefix? (yes/no)"
            read -r answer
            if [[ "$answer" == "yes" ]]; then
               echo
               echo "Creating Subnet ---"
               az network vnet subnet create --name $subnet_name \
                     -g $RG_NAME \
                     --vnet-name $vnet \
                     --address-prefix $subnet_prefix
               if [[ $(az network vnet subnet list -g $RG_NAME --vnet-name $vnet -o tsv --query "[?name=='$subnet_name']") ]]
                     then
                        echo "Completed!"
                        echo "Created with id:"
                        az network vnet subnet show -g $RG_NAME --vnet-name $vnet --name $subnet_name --query id
                     else
                        echo "Failed resource creation, program will abort now!!"
                        exit 3
               fi
            fi
         fi
      fi
done

vnet=$Server_vnet_name
address_prefix=$Server_vnet_address
subnet_list=( "${Server_Subnets_list[@]}" )
echo 
echo "---------------------------------------------------"
echo "VNET: $vnet: $address_prefix"
echo "---------------------------------------------------"
echo
echo "Check if it already exists ---"
if [[ $(az network vnet list -g $RG_NAME -o tsv --query "[?name=='$vnet']") ]]
then
      echo "exists!"
      az network vnet show -g $RG_NAME --name $vnet --query id 
else
   echo "doesn't exist!"
   echo "Do you want to create $vnet: $address_prefix? (yes/no)"
   read -r answer
   if [[ "$answer" == "yes" ]]; then
      echo "Creating VNET ---"
      az network vnet create -g $RG_NAME \
            --name $vnet \
            --location $LOCATION \
            --address-prefix $address_prefix
      if [[ $(az network vnet list -g $RG_NAME -o tsv --query "[?name=='$vnet']") ]]
      then
         echo "Completed!"
         echo "Created with id:"
         az network vnet show -g $RG_NAME --name $vnet --query id
      else
         echo "Failed resource creation, program will abort now!!"
         exit 3
      fi
   fi
fi
echo
echo "---------------------------------------------------"
echo "Subnets: $vnet: $address_prefix"
echo "---------------------------------------------------"
echo
for item in "${subnet_list[@]}"
   do
      if [[ ${item:0:2} == "SN" ]]
      then
         subnet_name=$item
      else
         subnet_prefix=$item
         echo "Check if subnet $subnet_name: $subnet_prefix already exists ---"
         if [[ $(az network vnet subnet list -g $RG_NAME --vnet-name $vnet -o tsv --query "[?name=='$subnet_name']") ]]
         then
            echo "exists!"
            az network vnet subnet show -g $RG_NAME --vnet-name $vnet --name $subnet_name -o tsv --query id 
         else
            echo "doesn't exist!"
            echo "Do you want to create subnets for $vnet: $subnet_prefix? (yes/no)"
            read -r answer
            if [[ "$answer" == "yes" ]]; then
               echo
               echo "Creating Subnet ---"
               az network vnet subnet create --name $subnet_name \
                     -g $RG_NAME \
                     --vnet-name $vnet \
                     --address-prefix $subnet_prefix
               if [[ $(az network vnet subnet list -g $RG_NAME --vnet-name $vnet -o tsv --query "[?name=='$subnet_name']") ]]
                     then
                        echo "Completed!"
                        echo "Created with id:"
                        az network vnet subnet show -g $RG_NAME --vnet-name $vnet --name $subnet_name --query id
                     else
                        echo "Failed resource creation, program will abort now!!"
                        exit 3
               fi
            fi
         fi
      fi
done

echo
echo "---------------------------------------------------"
echo "VNET Peering requires VNET ID for peering"
echo "Query all VNET ID before peering"
echo "---------------------------------------------------"
echo 
echo "Query Student VNET ID ---"
stuid=$(az network vnet show -g $RG_NAME --name  $Student_vnet_name --query id --out tsv) 
echo "$stuid"
echo 
echo "Query Router VNET ID ---"
rtrid=$(az network vnet show -g $RG_NAME --name  $Router_vnet_name --query id --out tsv) 
echo "$stuid"
echo 
echo "Query Server VNET ID ---"
srvid=$(az network vnet show -g $RG_NAME --name  $Server_vnet_name --query id --out tsv) 
echo "$stuid"

echo "Check if any of the NET IDs is NULL"
if [ -z "$rtrid" -o -z "$srvid" -o -z "$stuid" ] ; then
        echo "One of the IDs: rtrid or srvid or stuid is null "
        echo "program will abort now!!"
        exit 2
fi

echo
echo "---------------------------------------------------"
echo "Do you want to create VNET Peerings? (yes/no)"
read -r answer
   if [[ "$answer" == "yes" ]]; then
      echo "Creating VNET Peering using IDs"
      echo
      az network vnet peering create -g $RG_NAME \
            --name $Peer_RT \
            --vnet-name $Router_vnet_name \
            --remote-vnet $stuid \
            --allow-vnet-access --allow-forwarded-traffic 

      az network vnet peering create -g $RG_NAME \
            --name $Peer_TR \
            --vnet-name $Student_vnet_name \
            --remote-vnet $rtrid \
            --allow-vnet-access --allow-forwarded-traffic

      az network vnet peering create -g $RG_NAME \
            --name $Peer_RS \
            --vnet-name $Router_vnet_name \
            --remote-vnet $srvid \
            --allow-vnet-access --allow-forwarded-traffic 

      az network vnet peering create -g $RG_NAME \
            --name $Peer_SR \
            --vnet-name $Server_vnet_name \
            --remote-vnet $rtrid \
            --allow-vnet-access --allow-forwarded-traffic

      echo "Netwrok Peerings created!"
      echo "peerings for: $Router_vnet_name" 
      az network vnet peering list -g $RG_NAME --vnet-name $Router_vnet_name -o table 

      echo "peerings for: $Student_vnet_name" 
      az network vnet peering list -g $RG_NAME --vnet-name $Router_vnet_name -o table 

      echo "peerings for: $Server_vnet_name" 
      az network vnet peering list -g $RG_NAME --vnet-name $Router_vnet_name -o table 
   fi

echo
echo "---------------------------------------------------"
echo "Networking backend created without error!"
echo "END!"
echo "---------------------------------------------------"
echo
