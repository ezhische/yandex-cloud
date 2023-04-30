#!/bin/bash
terraform init
ID=$(yc compute snapshot list --format json| jq -r 'sort_by(.created_at) | reverse | map(select(.source_disk_id == "<ID диска>")) | .[0].id')
terraform apply -var="snapshot_id=$ID"