#! /bin/bash

GCE_NODES=""
function startup {
	if [[ $KUBE_GCE_INSTANCE_PREFIX  ]]; then
                echo "Discovering nodes prefixed $KUBE_GCE_INSTANCE_PREFIX"
		GCE_NODES=`gcloud compute instances list | grep $KUBE_GCE_INSTANCE_PREFIX`
		printf "%s Nodes %s\n" '-----' '-----'
		IFS=$'\n'
		for i in $GCE_NODES; do
			echo $i
		done
		IFS=$' '
		printf "%s\n" '---------------------------'
		
		read -e -p "Start these nodes? [Y/n]: " -i "y" input

		case "$input" in
			[yY])	
				doStartUp
				return 0 
				;;
			[nN]) 
				echo "Aborting shutdown"
				return 2 
				;;	
			*)
				echo "Illegal input";
				return 1 
				;;
		esac

	fi
}

function doStartUp {
	IFS=$'\n'
	for i in $(echo $GCE_NODES | awk '{print $1}'); do
		echo " $i"
		`gcloud compute instances start $i`
	done
}

startup
