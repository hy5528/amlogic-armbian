#!/bin/bash

# 安装 Docker
curl -fsSL https://get.docker.com -o get-docker.sh
# 安装 squeezelite
sudo apt-get install squeezelite -y
# 安装常用镜像
sudo mkdir /home/docker
sudo chmod -R 777 /home/docker
sudo mkdir /www 
sudo mkdir /www/mysql
sudo mkdir /www/cms && cd /www/cms
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

