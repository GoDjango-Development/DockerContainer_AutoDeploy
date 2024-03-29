#!/usr/bin/sh

echo -n "Enter the name(also username) for the container: "
read username
echo -n "Enter the start port for the range of ports(first port is also used for ssh): "
read start_port
echo -n "Enter the last port for the range of ports: "
read end_port
echo -n "Enter container image name: "
read img_name
echo -n "Enter container CPUs (i.e 0 or 0,1,2): "
read cpus
echo -n "Enter container RAM (i.e 500M or 1.5G): "
read ramsz
echo -n "Enter storage size (i.e 5g): "
read stgsize
password=$(head -c 30 /dev/urandom | sha256sum | cut -f 1 -d " ")
docker volume create -d local -o size=1g $username
docker run -d -it \
	--name=$username \
	--hostname=$username `#optional` \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/NewYork \
  -e SUDO_ACCESS=true `#optional` \
  -e PASSWORD_ACCESS=true `#optional` \
  -e USER_PASSWORD=$password \
  -e USER_NAME=$username `#optional` \
  --cpuset-cpus=$cpus \
  --memory=$ramsz \
  --pids-limit=20000 \
  --storage-opt size=$stgsize \
  --domainname=$username \
  -p $start_port:22 \
  -p $((start_port+1))-$end_port:$((start_port+1))-$end_port \
  --restart unless-stopped \
	$img_name /etc/init.d/ssh_loop.sh

docker exec $username bash -c "echo "root:$password" | chpasswd"

echo "Docker SSH created successfully copy password below to login into your ssh session"
echo $password
