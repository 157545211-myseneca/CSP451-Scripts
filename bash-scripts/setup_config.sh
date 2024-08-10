# //////////////////////////////////////////////////////////////
# Update the lines that are specific to you
# /////////////////////////////////////////////////////////////

# Client VM Credentials

USER_NAME="atoosanasiri"
ADMIN_PW="@atoosanasiri123"

RG_NAME=""     # your student group
LOCATION=""    # your location
ID=""          #unique ID assigned to you

Student_vnet_name=""
Student_vnet_address=""
Client_Subnet_name=""

RG_NAME="Student-RG-1202761"     # your student group
LOCATION="canadacentral"    # your location
ID="99"          #unique ID assigned to you

Student_vnet_name="Student-1202761-vnet"
Student_vnet_address="10.19.119.0/24"
Client_Subnet_name="Virtual-Desktop-Client"

# ---------------------------------------------------
# Networking - Virtual Networks
Host_vnet_name="Host-vnet-$ID"
Client_vnet_name="$Student_vnet_name"
Host_subnet_name="Host_Subnet"
Client_subnet_name="$Client_Subnet_name"

Host_vnet_address="192.168.$ID.0/24"
Host_subnet_address="$Host_vnet_address"
Client_vnet_address="$Student_vnet_address"
Client_subnet_address="$Student_vnet_address"

# ---------------------------------------------------
# Networking - Virtual Networks - Network Peerings
Peer_HC="HosttoClient"
Peer_CH="ClienttoHost"
declare -a Peerings_list=("$Peer_HC" "$Peer_CH")

# ---------------------------------------------------
# sshkey pair names
sshkey_name="app-host-sshkey-$ID"
public_sshkey_file="./app-host-sshkey.pub"

# ---------------------------------------------------
# VM names
Host_VM_name="Host-VM-$ID"
Client_VM_name="Client-VM-$ID"

# ---------------------------------------------------
#  Network Interface Card (NIC) names
Client_NIC_name="client-$ID"
Host_NIC_name="host-$ID"

# ---------------------------------------------------
# Networking - Netwoork Security Groups
Host_NSG_name="HOST-VM-NSG-$ID"
Client_NSG_name="CLIENT-VM-NSG-$ID"

# ---------------------------------------------------
# VM Image, Machine Size, Disk Settings
Host_IMG="Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest"
Client_IMG="MicrosoftWindowsDesktop:Windows-10:win10-22h2-pro:latest"

VM_SIZE="Standard_B2s"
OS_DISK_SKU="StandardSSD_LRS"
SECURITY_TYPE="Standard"

# ---------------------------------------------------
# DNS Configuration 
Azure_Default_DNS="168.63.129.16"

# ---------------------------------------------------
# configure auto shut down parameters

sleep_time=3
shutdown_time="0500"
