#!/bin/bash

read -p "Enter Your New Resource Group Name: " rgrp 

echo "Creating New Resource Group : jt-$rgrp"
start=`date +%s`
startdate=`date`
echo "Deployment Started at ====> $startdate"
az group create --name jt-$rgrp --location eastus
az group update -n jt-$rgrp --set tags.CreatedBy=Jacob

#az group deployment create --resource-group jt-$rgrp --template-uri  https://raw.githubusercontent.com/wls-eng/arm-oraclelinux-wls/master-backup/olvmdeploy.json  --parameters @olvmdeploy.parameters.json dnsLabelPrefix=jt-$rgrp
az group deployment create --resource-group jt-$rgrp --template-file  ddazuredeploy.json  --parameters @azuredeploy.parameters.json 


end=`date +%s`
enddate=`date`
runtime=$((end-start))
echo "Deployment ended at =====> $enddate"
echo "Total time taken for provisioning============> $((runtime/60)) minutes"
