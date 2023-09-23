#!/usr/bin/sh

echo -n "Enter the name(also username) for the container: "
read username
echo -n "Enter the start port for the range of ports(first port is also used for ssh): "
read start_port
echo -n "Enter the last port for the range of ports: "
read end_port
password=$(head -c 30 /dev/urandom | sha256sum | cut -f 1 -d " ")
docker volume create -d local -o size=1g $username
docker run -d \
	--name=$username \
	--hostname=$username `#optional` \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/NewYork \
  -e SUDO_ACCESS=true `#optional` \
  -e PASSWORD_ACCESS=true `#optional` \
  -e USER_PASSWORD=$password \
  -e USER_NAME=$username `#optional` \
  --cpuset-cpus="0" \
  --memory=512M \
  --pids-limit=20000 \
  --restart=unless-stopped \
  --storage-opt size=5g \
  -v $username:/config \
  --domainname=$username \
  -p $start_port:2222 \
  -p $((start_port+1))-$end_port:$((start_port+1))-$end_port \
  --restart unless-stopped \
	lscr.io/linuxserver/openssh-server:latest

echo "Docker SSH created successfully copy password below to login into your ssh session"
echo $password
