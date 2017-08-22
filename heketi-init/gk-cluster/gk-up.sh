#! /bin/bash

#debug 
set -x

set -e
set -u

source ./gk-common.sh


# Dependencies
DOCKER_DEP="docker-1.12.6"
FUSE_DEP="glusterfs-fuse"
UNZIP_DEP="unzip"
KUBECTL_DEP="https://storage.googleapis.com/kubernetes-release/release/v.1.7.4/bin/linux/amd64/kubectl"
KUBEADM_REPO="
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF"
KUBELET_DEP="kubelet"
KUBEADM_DEP="kubeadm"
HEKETI_DEP="https://github.com/heketi/heketi/releases/download/v4.0.0/heketi-client-v4.0.0.linux.amd64.tar.gz"
GK_S3_DEP="https://github.com/jarrpa/gluster-kubernetes/archive/block-and-s3.tar.gz"
S3_CURL_DEP="http://s3.amazonaws.com/doc/s3-example-code/s3-curl.zip"
KUBEADM_CONFIG_FLANNELD="--pod-network-cidr=10.244.0.0/16"
KUBE_FLANNEL="https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"
KBUE_FLANNEL_RBAC="https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml"

############ main  ###############
echo "-- Gluster-Kubernetes Create --"
echo \
"This script will deploy a 4 node kubernetes cluster with dependencies for
testing glsuter-kubernetes and object storage."

# Start Up Script
STARTUP_SCRIPT="$(dirname '${BASH_SOURCE}')/../startup-basic.sh"
# Create Instance Template
GCP_TEMPLATE_NAME="${GCP_USER}-gluster-kubernetes"
${GCLOUD} compute instance-templates create "$GCP_TEMPLATE_NAME" \
	--image=$CLUSTER_OS_IMAGE --image-project=$CLUSTER_OS_IMAGE_PROJECT	\
	--machine-type=$MACHINE_TYPE --network=$GCP_NETWORK \
	--subnet=$GCP_NETWORK --region=$GCP_REGION  \
	--boot-disk-auto-delete --boot-disk-size=$NODE_BOOT_DISK_SIZE \
	--boot-disk-type=$NODE_BOOT_DISK_TYPE --metadata-from-file="startup-script"=$STARTUP_SCRIPT
# Create node Instance Group
${GCLOUD} compute instance-groups managed create "$GCP_USER-gk-node"  \
	--template=$GCP_TEMPLATE_NAME --size=$GK_NUM_NODES --zone=$GCP_ZONE
# Create master Instance
${GCLOUD} compute instances create "$GCP_USER-gk-master" --boot-disk-auto-delete \
	--boot-disk-size=$NODE_BOOT_DISK_SIZE --boot-disk-type=$NODE_BOOT_DISK_TYPE \
	--image-project=$CLUSTER_OS_IMAGE_PROJECT --machine-type=$MASTER_MACHINE_TYPE \
	--network=$GCP_NETWORK --zone=$GCP_ZONE --image=$CLUSTER_OS_IMAGE \
	--metadata-from-file="startup-script"=$STARTUP_SCRIPT

#TODO create GFS block devices
#TODO attach GFS block devices to nodes

#TODO Poll VMs for status RUNNING
#TODO Poll via SSH kubelet for Ready
#TODO Poll master for kube node READY
#TODO Get via ssh kube master IP, kubeadm token
#TODO Do via ssh kube join from nodes
#TODO Once all nodes READY/RUNNING, do gk-deploy
