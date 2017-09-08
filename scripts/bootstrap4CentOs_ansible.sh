#!/bin/bash

#set -e

echo "Installing Ansible  on CentOS..." 

A=`yum info ansible`

testing=`[[ $A =~ 'Ansible' ]]`

echo $testing

echo  "############# ${testing} ##############"
 
if [[ $testing != ""  ]]; then
     echo "Ansible is already installed."
else
      echo "Ansible is not installed."      
      rpm -ivh  http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm
      
fi

yum  install -y ansible 

cp /vagrant/ansible/ansible.cfg /etc/ansible/ansible.cfg


yum update -y
