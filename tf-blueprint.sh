#!/bin/bash
source setup-env.sh
cat objects.yaml.env | envsubst > objects.yaml
cat TF_blueprint.yaml.env | envsubst > TF_blueprint.yaml
cd ..
export PATH=$PATH:$PWD/api-server/scripts
cd tf/
rc_loaddata -H $RC_HOST -u $RC_USER -p $RC_PW -A objects.yaml
rc_cli -H $RC_HOST -u $RC_USER -p $RC_PW blueprint create TF_blueprint.yaml
export ESID=$(rc_cli -H $RC_HOST -u $RC_USER -p $RC_PW edgesite list | awk 'NR==3 {print $1}')
export BPID=$(rc_cli -H $RC_HOST -u $RC_USER -p $RC_PW blueprint list | awk 'NR==3 {print $1}')
echo "ESID = $ESID"
echo "BPID = $BPID"
cat POD.yaml.env | envsubst > POD.yaml
rc_cli -H $RC_HOST -u $RC_USER -p $RC_PW pod create POD.yaml
