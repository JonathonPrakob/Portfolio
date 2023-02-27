This module will deploy a vnet with a vnet gateway, allowing a local client to access azure resources.

required inputs:
    creator = "name"
    address_space = [x.x.x.x/x]
        Use a private IP address range that does not overlap with the on-premises location that you connect from, or with the VNet that you want to connect to.

REQUIREMENTS:

VPN: 
1. must grant consent for azure vpn to sign in and read user profiles since authentication method is azure ad. this can be done in vnet gateway > point to site configuration, and only needs to be completed once per tenant.

connecting to vpn:
1. download VPN client: azure > virtual network gateway > tf-p2s > point to site configuration > download vpn client
2. unzip the folder
3. open folder "azure VPN"
4. open file "azurevpnconfig.xml"
5. under "</serverlist>", add the following blocks:
        <clientconfig>
        <dnsservers>
        <dnsserver>X.X.X.X</dnsserver>
        </dnsservers>
        </clientconfig>
6. using the output "private_ip_address", replace "X.X.X.X" with the private ip address of the private dns resolver inbound endpoint
7. Download and install azure vpn client:
	-Install using Client Install files: https://aka.ms/azvpnclientdownload.
    -Install directly, when signed in on a client computer: Microsoft Store.
8. Verify that the Azure VPN Client has permission to run in the background: https://support.microsoft.com/en-us/windows/windows-background-apps-and-your-privacy-83f2de44-d2d9-2b29-4649-2afe0913360a#ID0EBD=Windows_11
9. open the vpn client
    -Import
    -select the azurevpnconfig.xml file 
    -Specify the name of the profile and select Save.
    -Select Connect to connect to the VPN.
