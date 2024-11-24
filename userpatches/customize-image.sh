#!/bin/bash

# arguments: $RELEASE $LINUXFAMILY $BOARD $BUILD_DESKTOP
#
# This is the image customization script

# NOTE: It is copied to /tmp directory inside the image
# and executed there inside chroot environment
# so don't reference any files that are not already installed

# NOTE: If you want to transfer files between chroot and host
# userpatches/overlay directory on host is bind-mounted to /tmp/overlay in chroot
# The sd card's root path is accessible via $SDCARD variable.

# 安装 Docker
apt-get update
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
# 安装 squeezelite
sudo apt-get install squeezelite -y
# 安装解压软件 unzip
sudo apt install unzip
# 安装常用镜像
sudo mkdir -p /home/docker
sudo chmod -R 777 /home/docker
sudo mkdir -p /www 
sudo mkdir -p /www/mysql
sudo mkdir -p /www/cms && cd /www/cms
wget https://gh.con.sh/https://raw.githubusercontent.com/magicblack/maccms_down/master/maccms10.zip
sudo unzip maccms10.zip
sudo chmod -R 777 /www
sudo docker network create --subnet 172.19.0.0/16 --gateway 172.19.0.1 --driver bridge film_network
sudo docker run -d --name cms --restart=always -p 3306:3306 -v /www/mysql:/var/lib/mysql -e MYSQL_DATABASE=cms -e MYSQL_USER=cms -e MYSQL_PASSWORD=123456 -e MYSQL_ROOT_PASSWORD=123456 --network=film_network --ip=172.19.0.3 yobasystems/alpine-mariadb:10.11
sudo docker run -d --name film  --restart=always --user $(id -u):$(id -g) -v /www/cms:/var/www/html  -p 80:80 -e ND_LOGLEVEL=info --network=film_network --ip=172.19.0.2 shinsenter/phpfpm-apache:dev-php7.4 
docker run -d --restart=always --privileged=true -p 35455:35455 --name allinone youshandefeiyang/allinone
docker run -d --name=kms --restart=always -p 1688:1688 -p 1689:80   johngong/kms:latest
docker run -d --name=xteve --restart=always -p 34400:34400 --log-opt max-size=10m --log-opt max-file=5 -e TZ="Asia/Shanghai" -v /home/docker/xteve:/etc/xteve senexcrenshaw/xteve
docker run -d --name music --restart=always -v /home/docker/music/cache:/var/www/html/cache -v /home/docker/music/temp:/var/www/html/temp -p 264:264 bloodstar/music-player
docker run -d --name navidrome --restart=always --user $(id -u):$(id -g) -v /media:/music -v /home/docker/navidrome/data:/data -p 4533:4533 -e ND_LOGLEVEL=info deluan/navidrome:latest
# 清理缓存
apt autoremove -y && apt autoclean && apt remove -y && apt clean
