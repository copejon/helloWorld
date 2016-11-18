#! /bin/bash

# Kubernetes config toggler.  A lazy little script to make it easy to
# jump between kubernetes providers.  Useful for swapping between kube
# clusters hosted in GCE and local.
KCFG="/root/.kube/config"
KCFG_GCE="$KCFG.gce"
KCFG_LOC="$KCFG.local"
HEADER="[Kube-Provider-Toggle]"

if [ -r $KCFG ]; then
	if egrep -q '(current-context:) [a-z]+\-gce' $KCFG; then
		# .kube/config is GCE
		echo "$HEADER Toggle GCE OFF"
		mv -f $KCFG $KCFG_GCE

		# Toggled local config
		if [ -r $KCFG_LOC ]; then
			echo "Toggle LOCAL ON"
			mv $KCFG_LOC $KCFG
			export KUBERNETES_PROVIDER="local"
		else
			echo "$HEADER $KCFG_LOC not found"
		fi
	elif  egrep -q '(current-context:) local' $KCFG; then
		# .kube/config is local
		echo "$HEADER Toggle LOCAL OFF"
		mv -f $KCFG $KCFG_LOC
		
		# Toggle GCE config
		if [ -r $KCFG_GCE ]; then
			echo "Toggle GCE ON"
			mv -f $KCFG_GCE $KCFG
			export KUBERNETES_PROVIDER="gce"
		else
			echo "$HEADER $KCFG_GCE not found"
		fi
	else
		echo "$HEADER cannot determine provider from $KCFG"		
	fi
else
	if [[ -r $KCFG_GCE && ! -r $KCFG_LOC ]]; then
		echo "Toggle GCE ON"
		mv $KCFG_GCE $KCFG
	elif [[ -r $KCFG_LOC && ! -r $KCFG_GCE ]]; then
		echo "Toggle LOCAL ON"
		mv $KCFG_LOC $KCFG
	elif [[ -r $KCFG_LOC && -r $KCFG_GCE  ]]; then
		echo "Choose Config: "
		echo "1. $KCFG_GCE"
	       	echo "2. $KCFG_LOC"
		read -p "Choice: " -n 1 cfg
		case $cfg in
			"1")
				echo "Toggle GCE ON"
				mv $KCFG_GCE $KCFG
				;;
			"2")
				echo "Toggle LOCAL ON "
				mv $KCFG_LOC $KCFG
				;;
			*)
				echo "Invalid choice"
				;;
		esac
	fi
fi	
