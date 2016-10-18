#! /bin/bash

# Kubernetes config toggler.  A lazy little script to make it easy to
# jump between kubernetes providers.  Useful for swapping between kube
# clusters hosted in GCE and local.

cd /root/.kube/
KUBE_CONFIG="$PWD/config"
KUBE_CONFIG_GCE="$KUBE_CONFIG.gce"
KUBE_CONFIG_LOC="$KUBE_CONFIG.local"
HEADER="[Kube-Toggle]"

# the 'name:' field holds the project name, so this isn't very reliable.  It will
# work w/ kube-up.sh && local-cluster-up.sh generated configs.  I'll need to 
# figure out a better way to determine the provider from either the config
# or from kubectl. One alternative might be
#  kubectl get nodes --no-headers | 
#  grep master |
#  awk '{print $1}' | 
#  kubectl get node -o yaml | 
#  grep "provider"
#  Or some other field.  Provider isn't present in local configs

function toggle-kube-config {		
	if [ -r $KUBE_CONFIG ]; then
		if egrep -q '(name:) [a-z]+\-gce' $KUBE_CONFIG; then
			# .kube/config is GCE
			echo "$HEADER Detected config: GCE"
			
			# Toggled local config
			if [ -r $KUBE_CONFIG_LOC ]; then
				mv -f $KUBE_CONFIG $KUBE_CONFIG_GCE
				mv $KUBE_CONFIG_LOC $KUBE_CONFIG
				export KUBERNETES_PROVIDER="local"
				echo "$HEADER New config: Local"
			else
				echo "$HEADER No Local config, don't toggle."
			fi
		elif  egrep -q '(name:) local' $KUBE_CONFIG; then
			# .kube/config is local
			echo "$HEADER Detected config: Local"
			
			# Toggle GCE config
			if [ -r $KUBE_CONFIG_GCE ]; then
				mv -f $KUBE_CONFIG $KUBE_CONFIG_LOC
				mv -f $KUBE_CONFIG_GCE $KUBE_CONFIG
				export KUBERNETES_PROVIDER="gce"
				echo "$HEADER New config: GCE"
			else
				echo "$HEADER No GCE config, don't toggle"
			fi
		fi
	else
		echo "$HEADER $KUBE_CONFIG not found"
	fi
}
