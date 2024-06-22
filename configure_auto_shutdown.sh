
echo "Loading variables:"
echo "network_config.sh"
source ./network_config.sh
echo "backend_config.sh"
source ./backend_config.sh
echo "Loaded variabes without error"

echo "======================================================================"
echo
echo "vm auto-shutdown uses UTC, must convert to Eastern Standard Time (EST)"
echo "This script will configure: 12:00 midnight EST"
echo
echo "======================================================================"

shutdown_time="0500"

for vm_name in "${vm_list[@]}"
do
echo "---------------------------------------------------------------------"
echo "Creating auto-shutdown schedule for: $vm_name"
echo "---------------------------------------------------------------------"
# read -r answer
# if [[ "$answer" == "yes" ]]; then
    az vm auto-shutdown -g $RG_NAME -n $vm_name --time $shutdown_time
# fi
done

