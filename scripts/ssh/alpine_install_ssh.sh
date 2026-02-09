#!/bin/bash

apk update
apk add openssh
rc-update add sshd
rc-service sshd start
rc-status
