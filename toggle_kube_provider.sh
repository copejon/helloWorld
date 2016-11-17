#! /bin/bash

# Kubernetes config toggler.  A lazy little script to make it easy to
# jump between kubernetes providers.  Useful for swapping between kube
# clusters hosted in GCE and local.
KUBE_CONFIG="/root/.kube/config"
KUBE_CONFIG_GCE="$KUBE_CONFIG.gce"
KUBE_CONFIG_LOC="$KUBE_CONFIG.local"
HEADER="[Kube-Provider-Toggle]"

if [ -r $KUBE_CONFIG ]; then
	if egrep -q '(current-context:) [a-z]+\-gce' $KUBE_CONFIG; then
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
	elif  egrep -q '(current-context:) local' $KUBE_CONFIG; then
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
	else
		echo "$HEADER cannot determine provider from $KUBE_CONFIG"		
	fi
else
	echo "$HEADER $KUBE_CONFIG not found"
fi
