# Date: 2021-04-10
source  ./logo_csp451.sh
# variable declaration

# //////////////////////////////////////////////////////////////
# Update the lines that are specific to your network 
# /////////////////////////////////////////////////////////////

RG_NAME=""
LOCATION=""
ID=""

Student_vnet_name=""
Student_vnet_address=""
Client_Subnet_name=""
Client_Subnet_address=""

# ---------------------------------------------------
# Networking - Virtual Networks
Router_vnet_name="Router-$ID"
Server_vnet_name="Server-$ID"

Router_vnet_address="192.168.$ID.0/24"
Server_vnet_address="172.17.$ID.0/24"

# ---------------------------------------------------
# Networking - Virtual Networks - Subnets 
declare -a Client_Subnet_list=("$Client_Subnet_name" "$Client_Subnet_Address")
declare -a Router_Subnets_list=("SN1" "192.168.$ID.0/27")
declare -a Server_Subnets_list=("SN1" "172.17.$ID.0/27")

declare -a VNET_List=("$Router_vnet_name" "$Server_vnet_name")

# ---------------------------------------------------
# Networking - Virtual Networks - Network Peerings
Peer_RT="RoutertoStudent"
Peer_TR="StudenttoRouter"
Peer_RS="RoutertoServer"
Peer_SR="ServertoRouter"
declare -a Peerings_list=("$Peer_RT" "$Peer_TR" "$Peer_RS" "$Peer_SR")

# ---------------------------------------------------
# Networking - Route Tables
RT_Name="RT-$ID"

# ---------------------------------------------------
# Networking - Route Tables - Routes
Route_to_Server="Route-to-Server"
Route_to_Client="Route-to-Client"

declare -a Routes_list=("$Route_to_Server" "$Route_to_Client")

Virtual_Appliance="192.168.$ID.4"
Server_Route_Address="172.17.$ID.0/27"
Client_Route_address="$Client_Subnet_address"

Server_Subnet_association="SN1"
Client_Subnet_association="$Client_Subnet_name"
