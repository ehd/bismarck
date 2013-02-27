#!/bin/sh

set -e

# tmux
apt-get install -y tmux

# htop
apt-get install -y htop

# swap
sudo dd if=/dev/zero of=/swapfile bs=1M count=1k
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
chown root:root /swapfile 
chmod 0600 /swapfile

# sshd
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# java
apt-get install -y software-properties-common
apt-add-repository -y ppa:webupd8team/java
apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | \
  debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | \
  debconf-set-selections
apt-get install -y oracle-java7-installer

# minecraft
adduser -q --disabled-password --gecos '' minecraft
mkdir ~minecraft/server
curl https://s3.amazonaws.com/MinecraftDownload/launcher/minecraft_server.jar \
  -o ~minecraft/server/minecraft_server.jar
chown -R minecraft:minecraft ~minecraft/server
tmux new-session -d -s minecraft \
"su minecraft -c 'cd ~minecraft/server && java -jar minecraft_server.jar nogui'"
