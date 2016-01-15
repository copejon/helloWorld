#!/bin/bash
HOSTNAME=$1
HOSTS=$(cat /etc/hosts)
PRIV_KEY=$(cat /home/jcope/.ssh/vagrant)
PUB_KEY=$(cat /home/jcope/.ssh/vagrant.pub)
ROOT_SSH_DIR="/root/.ssh/"
mkdir -p $ROOT_SSH_DIR
echo $HOSTS &> /etc/hosts 
echo $PRIV_KEY &> /root/.ssh/vagrant
echo $PUB_KEY &> /root/.ssh/vagrant.pub >> /root/.ssh/authorized_keys

if[ -z ${host=$HOSTNAME} ]
        hostame $host
        echo $host > /etc/hostname
fi   
