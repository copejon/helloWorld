#! /bin/bash
set -e
echo [Begin Cluster Setup]
./init_ose-3.1.sh
./init_gluster.sh
echo [Finished Cluster Setup]

