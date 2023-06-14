#!/bin/bash
touch '~/myfile.txt'
yum update -y
yum install docker -y
systemctl enable --now docker
sudo chmod 777 /var/run/docker.sock 