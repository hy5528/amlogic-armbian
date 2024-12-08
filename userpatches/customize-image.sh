#!/bin/bash
# 备份原有的sources.list文件
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup
 
# 更新sources.list文件
sudo tee /etc/apt/sources.list <<EOF
deb http://ports.ubuntu.com/ jammy main restricted universe multiverse
#deb-src http://ports.ubuntu.com/ jammy main restricted universe multiverse
deb http://ports.ubuntu.com/ jammy-security main restricted universe multiverse
#deb-src http://ports.ubuntu.com/ jammy-security main restricted universe multi>
deb http://ports.ubuntu.com/ jammy-updates main restricted universe multiverse
#deb-src http://ports.ubuntu.com/ jammy-updates main restricted universe multiv>
deb http://ports.ubuntu.com/ jammy-backports main restricted universe multiverse
#deb-src http://ports.ubuntu.com/ jammy-backports main restricted universe mult>
EOF
# 更新软件包
sudo apt-get update

# 安装 Docker
sudo apt-get install -y ca-certificates curl gnupg lsb-release alsa-utils 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io 
sudo systemctl start docker

# 清理缓存
apt autoremove -y && apt autoclean && apt remove -y && apt clean

