#!/bin/bash

export NODE_HOME=/usr/local

export IDM_USER=demo
export IDM_PASS=demo
export IDM_HOST=localhost:8082

export IDS_FOLDER=IDs
export SOS_FOLDER=SOs
export DPPS_FOLDER=DPPs
export SUBS_FOLDER=SUBs
export SODATA_FOLDER=SOdata
export ACCESS_TOKEN_FILENAME=access_token.id
export RANDOM_ACCESS_TOKEN_FILENAME=random_access_token.id
export SUBSCRIPTION_FILENAME=subscription.json
export SAMPLE_STREAM=position
export SAMPLE_DPP_AGG_STREAM=aggregate
export SAMPLE_DPP_FILT_STREAM=inLocation

export API_PUB_NODES=localhost
export API_PUB_SEC_PORT=8080

export ROOT=`pwd`
export SCRIPTS=$ROOT/scripts
export TMPDIR=$ROOT/tmp
export PUSH_DATA_DELAY=5
