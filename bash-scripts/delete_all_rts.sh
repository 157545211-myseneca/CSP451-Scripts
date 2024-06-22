source ./network_config.sh
source ./backend_config.sh
echo -e "Loaded variabes without error"

echo 
echo -e "---------------------------------------------------"
echo -e "Deleting Routes"
echo -e "---------------------------------------------------"
echo
for route_name in "${Routes_list[@]}"
do
echo -e "Route: $route_name "
echo -e "Check if it  exists ---"
status="$(az network route-table route list -g $RG_NAME \
        --route-table-name $RT_Name \
        -o tsv --query "[?name=='$route_name']"  2> /dev/null)"

if [[ "$status" ]];then
    echo
    echo -e "exists!"
    echo -e "Deleting Route: $route_name ... \n"
    az network route-table show -g $RG_NAME --name $RT_Name -o tsv --query id 
    az network route-table route delete -g $RG_NAME \
        --route-table-name $RT_Name \
        -n $route_name
else
    echo
    echo -e "Doesn't exist! Nothing to do ...\n"
fi
done

echo 
echo -e "---------------------------------------------------"
echo -e "Deleting Subnet Associations"
echo -e "---------------------------------------------------"
echo
association=$Client_Subnet_association
echo
echo -e "Deleting Route table Associatin for: $association"
az network vnet subnet update -n $association \
        --vnet-name $Student_vnet_name \
        -g $RG_NAME --remove routeTable \
        > /dev/null 2>/dev/null
        
association=$Server_Subnet_association
echo
echo -e "Deleting Route table Associatin for: $association"
az network vnet subnet update -n  $association\
        --vnet-name $Server_vnet_name \
        -g $RG_NAME --remove routeTable \
        > /dev/null 2>/dev/null
       
echo 
echo -e "---------------------------------------------------"
echo -e "Deleting Route Table: $RT_Name"
echo -e "---------------------------------------------------"
echo
echo -e "Route Table: $route_name "
echo -e "Check if it  exists ---"
status="$(az network route-table list -g $RG_NAME \
        -o tsv --query "[?name=='$RT_Name']" 2> /dev/null)"
if [[ "$status" ]];then
    echo
    echo -e "exists!"
    az network route-table show -g $RG_NAME --name $RT_Name -o tsv --query id 
    az network route-table delete -g $RG_NAME --name $RT_Name
else
    echo
    echo -e "Doesn't exist! Nothing to do ...\n"
fi

echo
echo -e "---------------------------------------------------"
echo -e "DONE!"
echo -e "---------------------------------------------------"
echo