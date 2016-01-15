#! /bin/bash

echo "[Shell: Setting up Subscription]"
set -e

#echo -n "Subscription-Manager User Name: "
#read userName
#echo -n "Password: "
#read passwd

#subscription-manager register --username="$userName" --password="$passwd"

subscription-manager list --available | \
   sed -n '/OpenShift Employee Subscription/,/Pool ID/p' | \
   sed -n '/Pool ID/ s/.*\://p' | sed -e 's/^[ \t]*//' | \
   xargs -i{} subscription-manager attach --pool={}
subscription-manager repos --disable="*"
subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-ose-3.1-rpms" 
sudo yum install wget net-tools bind-utils iptables-services bridge-utils \
                 bash-completion git tmux vim gcc python-virtualenv ntp \
                 docker atomic-openshift-utils -y
#sudo sed -i "s#OPTIONS='--selinux-enabled'#OPTIONS='--selinux-disabled'#" /etc/sysconfig/docker
echo "[Shell: Subscription Setup Complete]"
