#!/bin/bash
set -eux

DEVICE="/dev/xvdf"
MOUNT_POINT="/var/lib/jenkins"
while [ ! -b "$DEVICE" ]; do
  echo "Waiting for $DEVICE to be ready..."
  sleep 2
done

if ! blkid $DEVICE; then
  echo "No filesystem found on $DEVICE, formatting..."
  mkfs.ext4 $DEVICE
fi
mkdir -p $MOUNT_POINT
mount $DEVICE $MOUNT_POINT

grep -q "$DEVICE" /etc/fstab || echo "$DEVICE $MOUNT_POINT ext4 defaults,nofail 0 2" >> /etc/fstab

sudo apt update -y
sudo apt install -y fontconfig openjdk-21-jre

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y jenkins

sudo systemctl enable jenkins
sudo systemctl restart jenkins

# allocate swap memory
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
