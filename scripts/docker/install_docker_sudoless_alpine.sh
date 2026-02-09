#!/bin/bash

apk add docker
apk add docker-rootless-extras
sed -i "s/#rc_cgroup_mode=\"unified\"/rc_cgroup_mode=\"unified\"/g" /etc/rc.conf
rc-update add cgroups default
apk add docker-cli-compose
