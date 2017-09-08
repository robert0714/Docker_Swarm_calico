#!/bin/bash

#!/bin/bash

set -e

echo "Installing Repository..."
apt-get install -y software-properties-common  python-software-properties 
apt-add-repository  -y  ppa:ansible/ansible
 
echo "Updating Ubuntu ..."
apt-get update -y

echo "Installing Ansible..."
apt-get install -y   ansible

echo "Copying Ansible Configuration..."
cp /vagrant/ansible/ansible.cfg /etc/ansible/ansible.cfg
 

echo "Script  Endbootstrap_ansible.sh..."




 
