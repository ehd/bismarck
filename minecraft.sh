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
curl -L http://dl.bukkit.org/latest-rb/craftbukkit.jar \
  -o ~minecraft/server/craftbukkit.jar
chown -R minecraft:minecraft ~minecraft/server
echo "while true; do java -Xms1024M -Xmx1024M -jar craftbukkit.jar -o true; sleep 10; done" \
  > ~minecraft/server/keep_running.sh
chmod +x ~minecraft/server/keep_running.sh
tmux new-session -d -s minecraft \
"su minecraft -c 'cd ~minecraft/server && ./keep_running.sh'"
