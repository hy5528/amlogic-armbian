function extension_prepare_config__docker() {
	display_alert "Extension: ${EXTENSION}: Target image will have Docker preinstalled" "${EXTENSION}" "info"
}

function pre_install_kernel_debs__install_docker_packages(){

	run_host_command_logged curl --max-time 60 -4 -fsSL "https://download.docker.com/linux/ubuntu/gpg" "|" gpg --dearmor -o "${SDCARD}"/usr/share/keyrings/docker.gpg

	# Add sources.list
	if [[ "${DISTRIBUTION}" == "Debian" ]]; then
		run_host_command_logged echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian ${RELEASE} stable" "|" tee "${SDCARD}"/etc/apt/sources.list.d/docker.list
	elif [[ "${DISTRIBUTION}" == "Ubuntu" ]]; then
		run_host_command_logged echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${RELEASE} stable" "|" tee "${SDCARD}"/etc/apt/sources.list.d/docker.list
	else
		exit_with_error "Unknown distribution: ${DISTRIBUTION}"
	fi

	do_with_retries 3 chroot_sdcard_apt_get_update

	display_alert "Extension: ${EXTENSION}: Adding extra packages" "docker-ce docker-ce-cli containerd.io docker-compose-plugin" "info"
	chroot_sdcard_apt_get_install docker-ce docker-ce-cli containerd.io docker-compose-plugin
        sudo docker network create --subnet 172.19.0.0/16 --gateway 172.19.0.1 --driver bridge film_network
        sudo docker run -d --name cms --restart=always -p 3306:3306 -v /www/mysql:/var/lib/mysql -e MYSQL_DATABASE=cms -e MYSQL_USER=cms -e MYSQL_PASSWORD=123456 -e MYSQL_ROOT_PASSWORD=123456 --network=film_network --ip=172.19.0.3 yobasystems/alpine-mariadb:10.11
        sudo docker run -d --name film  --restart=always --user $(id -u):$(id -g) -v /www/cms:/var/www/html  -p 80:80 -e ND_LOGLEVEL=info --network=film_network --ip=172.19.0.2 shinsenter/phpfpm-apache:dev-php7.4 
        sudo docker run -d --restart=always --privileged=true -p 35455:35455 --name allinone youshandefeiyang/allinone
        sudo docker run -d --name=kms --restart=always -p 1688:1688 -p 1689:80   johngong/kms:latest
        sudo docker run -d --name=xteve --restart=always -p 34400:34400 --log-opt max-size=10m --log-opt max-file=5 -e TZ="Asia/Shanghai" -v /home/docker/xteve:/etc/xteve senexcrenshaw/xteve
        sudo docker run -d --name music --restart=always -v /home/docker/music/cache:/var/www/html/cache -v /home/docker/music/temp:/var/www/html/temp -p 264:264 bloodstar/music-player
        sudo docker run -d --name navidrome --restart=always --user $(id -u):$(id -g) -v /media:/music -v /home/docker/navidrome/data:/data -p 4533:4533 -e ND_LOGLEVEL=info deluan/navidrome:latest
}
