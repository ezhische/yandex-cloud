#!/bin/bash
export IAM_TOKEN="IAM_TOKEN"
export INSTANCE_ID="\$INSTANCE_ID"
source ./env.sh
cat cloudconfig.yaml.tpl |envsubst>cloudconfig.yaml
ID=$(yc compute snapshot list --format json| jq -r 'sort_by(.created_at) | reverse | map(select(.source_disk_id == "'$INSTANCE_DISK_ID'")) | .[0].id')
yc compute instance create \
  --name backup \
  --metadata-from-file user-data=cloudconfig.yaml \
  --metadata serial-port-enable=1 \
  --zone ru-central1-b \
  --create-boot-disk snapshot-id=$ID,type=network-nvme \
  --memory 16 --cores 4 --core-fraction 100 \
  --network-interface subnet-id=$SUBNET_ID,nat-ip-version=ipv4 \
  --service-account-id=$SA_ID \
  --async