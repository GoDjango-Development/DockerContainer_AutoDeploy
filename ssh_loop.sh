#!/bin/sh

service ssh restart

while :
do
    pkill -SIGSTOP ssh_loop.sh
done

exit 0
