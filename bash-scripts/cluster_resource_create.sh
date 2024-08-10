source ./logo_csp451.sh
source ./setup_config.sh
source ./network_functions.sh
source ./vm_functions.sh
echo -e "Loaded variabels & functions without error"

echo
echo "---------------------------------------------------"
echo "Do you want to create networking resources? (yes/no)"
read -r answer
if [[ "$answer" == "yes" ]];then
    create_networking_resources
fi

echo
echo "---------------------------------------------------"
echo "Do you want to create VMs? (yes/no)"
read -r answer
if [[ "$answer" == "yes" ]]; then
    client_vm_create "$Client_VM_name" "$Client_IMG" "$Client_NIC_name"
    host_vm_create "$Host_VM_name" "$Host_IMG" "$Host_NIC_name"

    configure_auto_shutdown "$Client_VM_name"
    configure_auto_shutdown "$Host_VM_name"
fi

echo
echo "---------------------------------------------------"
echo "Do you want to destroy networking resources? (yes/no)"
read -r answer
if [[ "$answer" == "yes" ]];then
    destroy_networking_resources
fi
