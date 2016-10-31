#! /bin/bash

GCE_NODES=""
function shutdown {
	if [[ $KUBE_GCE_INSTANCE_PREFIX  ]]; then
                GCE_NODES=`gcloud compute instances list | grep $KUBE_GCE_INSTANCE_PREFIX`
		printf "%s Matching Nodes %s\n" '-----' '-----'
		IFS=$'\n'
		for i in $GCE_NODES; do
			echo $i
		done
		IFS=$' '
		printf "%s\n" '---------------------------'
		
		read -p "Shutdown these nodes? [Y/n]: " -i y input

		case "$input" in
			[yY]) 
				doShutdown 
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

function doShutdown {
	NODES=$(echo $GCE_NODES | awk '{print $1}' | tr '\n' ' ')
	for i in $NODES; do
		echo "Shutting down $i"
		`gcloud compute instances stop $i`
	done
}

shutdown
