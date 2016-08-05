Setup to run the Ansible Script for bringup the 16 Node Topology
----------------------------------------------------------------

Ubuntu Operating System with  >= 14.04 version

Install the following:
	1. apt-get install libffi-dev
	2. apt-get install libssl-dev
	3. Update the paramiko version 2.0.0
	4. Ansible 2.1

Do the following on the Ubuntu:
-------------------------------
	1. Flush the iptables
	2. Generate the RSA key locally in the system ( ssh-keygen -t rsa)

Change the following in the Script or in the sytem file
-------------------------------------------------------
	1. Change the ansible host name and user name in the hosts file in script root folder 
	2. Add the host name to resolve in the /etc/hosts

Run the script to the bring up the topology
-------------------------------------------
	1. sudo ansible-playbook utils/setup.yaml --ask-pass --ask-sudo-pass -vvv

To tear down the topology
-------------------------
	2. sudo ansible-playbook utils/teardown.yaml  --ask-pass --ask-sudo-pass -vvvv

By Default BGP will be configured, to disable the BGP configuration, disable the line at the end of the file: site.yaml


