# variable declaration
# already declared in another file, this line is redundant
# source ./network_config.sh

# //////////////////////////////////////////////////////////////
# Update the lines that are specific to your network 
# /////////////////////////////////////////////////////////////
# ---------------------------------------------------
# Windows VM Credentials

USER_NAME=""
ADMIN_PW=""

# ---------------------------------------------------
# sshkey pair names
sshkey_name="sshkey-$ID"
public_sshkey_file="./sshkey.pub"

# ---------------------------------------------------
# VM names
VM_WC="WC-$ID"
VM_LR="LR-$ID"
VM_WS="WS-$ID"
VM_LS="LS-$ID"

# ---------------------------------------------------
#  Network Interface Card (NIC) names
NIC_WC="wc-$ID"
NIC_LR="lr-$ID"
NIC_WS="ws-$ID"
NIC_LS="ls-$ID"

# ---------------------------------------------------
#  Subnets used for VM creation
Subnet_WC="Virtual-Desktop-Client"
Subnet_LR="SN1"
Subnet_WS="SN1"
Subnet_LS="SN1"

# ---------------------------------------------------
# Networking - Netwoork Security Groups
WC_NSG_name="WC-NSG-$ID"
LR_NSG_name="LR-NSG-$ID"
LS_NSG_name="LS-NSG-$ID"
WS_NSG_name="WS-NSG-$ID"

# ---------------------------------------------------
# VM Image, Machine Size, Disk Settings
VM_IMG_WC="MicrosoftWindowsDesktop:Windows-10:win10-22h2-pro:latest"
VM_IMG_LR="RedHat:RHEL:8-lvm:latest"
VM_IMG_WS="MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest"
VM_IMG_LS="RedHat:RHEL:8-lvm:latest"

VM_SIZE="Standard_B2s"
OS_DISK_SKU="StandardSSD_LRS"
SECURITY_TYPE="Standard"

# ---------------------------------------------------
# Static IP setting
Static_IP_LR="192.168.$ID.4"
Static__IP_WS="172.17.$ID.4"
Static_IP_LS="172.17.$ID.5"
dummy_IP_1="172.17.$ID.10"
dummy_IP_2="172.17.$ID.11"

# ---------------------------------------------------
# DNS Configuration 
Azure_Default_DNS="168.63.129.16"

declare -a vm_list=("$VM_WC" "$VM_LR" "$VM_WS" "$VM_LS")
declare -a nic_list=("$NIC_WC" "$NIC_LR" "$NIC_WS"  "$NIC_LS")
declare -a nsg_list=("$WC_NSG_name" "$LR_NSG_name" "$LS_NSG_name" "$WS_NSG_name")

# ---------------------------------------------------
# configure auto shut down parameters

sleep_time=3
shutdown_time="0500"
