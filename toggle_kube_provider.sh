#! /bin/bash

# Kubernetes config toggler.  A lazy little script to make it easy to
# jump between kubernetes providers.  Useful for swapping between kube
# clusters hosted in GCE and local.
KCFG="/root/.kube/config"
KCFG_GCE="$KCFG.gce"
KCFG_LOC="$KCFG.local"
HEADER="[KubeToggle]"

function pout {
	echo $HEADER $@
}

function toggle_gce_on {
	if [[ -r $KCFG_GCE  ]]; then
		pout "Activating GCE config"
		mv $KCFG_GCE $KCFG
		export KUBERNETES_PROVIDER="gce"
	else
		pout "GCE config not found"
	fi
}

function toggle_local_on {
	if [[ -r $KCFG_LOC  ]]; then
		pout "Activating LOCAL config"
		mv $KCFG_LOC $KCFG
		export KUBERNETES_PROVIDER="local"
	else
		pout "LOCAL config not found"
	fi
}

function toggle_gce_off {
	pout "Deactivatinig GCE config"
	mv $KCFG $KCFG_GCE
	unset KUBERNETES_PROVIDER
}

function toggle_local_off {
	pout "Deactivating LOCAL config"
	mv $KCFG $KCFG_LOC
	unset KUBERNETES_PROVIDER
}

function toggle_active_config {
	if egrep -q '(current-context:) [a-z]+\-gce' $KCFG; then
		toggle_gce_off
		toggle_local_on
	elif  egrep -q '(current-context:) local' $KCFG; then
		toggle_local_off
		toggle_gce_on
	fi
}

function toggle_inactive_config {
	if [[ -r $KCFG_GCE && ! -r $KCFG_LOC ]]; then
		toggle_gce_on
	elif [[ -r $KCFG_LOC && ! -r $KCFG_GCE ]]; then
		toggle_local_on
	elif [[ -r $KCFG_LOC && -r $KCFG_GCE  ]]; then
		echo "Choose Config: "
		echo "1. $KCFG_GCE"
	       	echo "2. $KCFG_LOC"
		read -p "Choice: " -n 1 cfg
		case $cfg in
			"1")
				toggle_gce_on
				;;
			"2")
				toggle_local_on
				;;
			*)
				echo "Invalid choice"
				;;
		esac
	fi
}

function show_provider {
	pout "KUBERNETES_PROVIDER=$KUBERNETES_PROVIDER"
}

if [[ -r $KCFG ]]; then
	toggle_active_config
	show_provider
else
	toggle_inactive_config
	show_provider
fi

