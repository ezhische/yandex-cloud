#cloud-config
ssh_pwauth: no
package_update: true
write_files:
- path: /root/.config/rclone/rclone.conf
  content: |
    [s3]
    type = s3
    provider = Other
    access_key_id = ${S3_KEY_ID}
    secret_access_key = ${S3_KEY}
    hard_delete = true
    endpoint = ${S3_ENDPOINT}
packages:
  - rclone
  - pv
  - zstd
  - jq
runcmd:
  - dd if=/dev/vdb bs=4M |pv|zstd -1 |rclone --s3-chunk-size=1GB --s3-upload-concurrency 8 --s3-max-upload-parts 1000000 rcat s3:${BUCKET_NAME}/$(date '+%Y%m%d%H%M%S').zst
  - sleep 60
  - 'IAM_TOKEN=$(curl --connect-timeout 1 -s -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token | jq ".access_token" -r)'
  - 'INSTANCE_ID=$(curl --connect-timeout 1 -s -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/id)'
  - 'curl -X DELETE https://compute.api.cloud.yandex.net/compute/v1/instances/$INSTANCE_ID -H "Authorization: Bearer ${$IAM_TOKEN}" -H "Content-type: application/json"'
disk_setup: false
mounts: false