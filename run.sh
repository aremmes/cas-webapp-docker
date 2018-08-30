#!/bin/bash
docker stop cas &>/dev/null
docker rm cas -f &>/dev/null

export REGISTRY_DB_HOST=${REGISTRY_DB_HOST:=172.16.127.248}
export REGISTRY_DB_PORT=${REGISTRY_DB_HOST:=3306}
export REGISTRY_DB_NAME=${REGISTRY_DB_HOST:=portalsso}
export REGISTRY_DB_USER=${REGISTRY_DB_HOST:=cas}
export REGISTRY_DB_PASS=${REGISTRY_DB_HOST:=c4s1sb3tt3r}
export MYSQL_VOICEAXIS_HOST=${MYSQL_VOICEAXIS_HOST:=qa6-box.dev.coredial.com}
export MYSQL_VOICEAXIS_PORT=${MYSQL_VOICEAXIS_PORT:=3306}
export MYSQL_VOICEAXIS_USER=${MYSQL_VOICEAXIS_USER:=voiceaxis}
export MYSQL_VOICEAXIS_PASSWORD=${MYSQL_VOICEAXIS_PASSWORD:=dr0az3eh}
export MYSQL_VOICEAXIS_DB=${MYSQL_VOICEAXIS_DB:=portal}

cas_version=$1

if [ $# -eq 0 ] || [ -z "$cas_version" ]
  then
    echo "No CAS version is specified."
    read -p "Provide a tag for the CAS image you are about to run (i.e. 5.0.0): " cas_version;
fi

if [ ! -z "$cas_version" ]
  then
	docker run -d -p 8080:8080 -p 8443:8443 --name="cas" apereo/cas:v$cas_version
	docker logs -f cas
  else
  	echo "No image tag is provided."	
fi
