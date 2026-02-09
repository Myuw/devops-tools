#!/bin/bash

apk add docker
rc-update add docker default
service docker start
addgroup ${USER} docker
