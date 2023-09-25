##This is an automation script for deploy an ssh ready container.

The next steps should be only do once:

- docker run -d -it --name exm debian:latest bash
# could be any other distro you want.
- docker exec -it exm bash
- apt-get update
- apt-get install ssh
- apt-get install nano
- nano /etc/ssh/sshd_config
# change this line #PermitRootLogin prohibit-password by
 PermitRootLogin yes */
- service ssh restart
#Install any other software you need in your automated predefined container image.
- exit
- docker commit exm name_you_want

Now on, every time you need to deploy the image you only need to execute the script and 
follow the instructions. Feel free to change any config inside the script to fit your
own needs.

Rememeber that the first mapped port for external access will be the ssh port.
