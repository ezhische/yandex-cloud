#!/bin/bash
DATE=$(date '+%Y%m%d')
IMAGENAME=backup-$DATE
rclone cat s3:<Имя бакета>/<файл образа>.zst|zstd -d -o image.img
qemu-img convert -p -O qcow2 -o cluster_size=2M image.img $IMAGENAME.qcow2
rm image.img