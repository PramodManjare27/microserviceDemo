#!/bin/bash
#author : Pramod Manjare
#Purpose : Deploying war or jar on given environment

export DEPLOY_TO=${1}
echo "Deploying to ${DEPLOY_TO} environment"
echo "host is `hostname`"
echo "Pulling the war file from nexus"
#curl command here
echo "Moving the files to deployment location"

echo "Restarting nginx"

echo "Deployment completed !!!"
