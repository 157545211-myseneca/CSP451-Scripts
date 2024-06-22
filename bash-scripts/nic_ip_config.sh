echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "backend_config.sh"
source ./backend_config.sh
echo "Loaded variabes without error"


echo "forwarding enable ... "
az network nic update --name  $NIC_LR  \
                    --resource-group $RG_NAME \
                    --ip-forwarding true 
                    # 2>/dev/null