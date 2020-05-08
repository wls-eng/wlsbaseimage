#!/bin/bash

read -p "Enter Your New Resource Group Name: " rgrp 
vmname='BaseImageVM'


echo "Creating New Resource Group : jt-$rgrp"
myPubIP=$(curl https://ifconfig.co)
echo "Your Public IP is "$myPubIP


start=`date +%s`
startdate=`date`
echo "Deployment Started at ====> $startdate"
az group create --name jt-$rgrp --location eastus
az group update -n jt-$rgrp --set tags.CreatedBy=Jacob

#az group deployment create --resource-group jt-$rgrp --template-uri  https://raw.githubusercontent.com/wls-eng/arm-oraclelinux-wls/master-backup/olvmdeploy.json  --parameters @olvmdeploy.parameters.json dnsLabelPrefix=jt-$rgrp
az group deployment create --resource-group jt-$rgrp --template-file  olvmdeploy.json  --parameters @olvmdeploy.parameters.json  dnsLabelPrefix=jt-$rgrp vmName=$vmname 

#echo "Deployment complete - now adding client public IP to NSG rule"
#az network nsg rule update --nsg-name Subnet-nsg -g jt-$rgrp -n Cleanuptool-Allow-100 --add sourceAddressPrefixes $myPubIP

end=`date +%s`
enddate=`date`
runtime=$((end-start))
echo "Deployment ended at =====> $enddate"
echo "Total time taken for provisioning============> $((runtime/60)) minutes"
echo "Run this command to add public IP"
echo "az network nsg rule update --nsg-name Subnet-nsg -g" jt-$rgrp "-n Cleanuptool-Allow-100 --add sourceAddressPrefixes" $myPubIP

echo " =========================== "
echo " After deployment is complete, ssh into the provisioned VM"
echo " Delete all sensitive files that you don't want in image"
echo "   sudo waagent -deprovision+user -force"
echo "   exit"
echo " Deallocated VM"
echo "   az vm deallocate --resource-group jt-$rgrp --name $vmname"
echo " Generalized VM"
echo "   az vm generalize --resource-group jt-$rgrp --name $vmname"
echo " =========================== "

#az vm extension set --resource-group jt-image --vm-name BaseImageVM --name CustomScript --publisher  Microsoft.Azure.Extensions --version 2.0 --settings '{"commandToExecute": "sudo waagent -deprovision+user -force"}'
