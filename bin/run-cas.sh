#!/bin/bash
export JAVA_HOME=/opt/jre-home
export PATH=$PATH:$JAVA_HOME/bin:.
export JVM_OPTS="-server -Xms2048m -Xmx2048m -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m -XX:MinHeapFreeRatio=35 -XX:MaxHeapFreeRatio=80 -XX:NewRatio=8 -XX:SurvivorRatio=32 -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC"
export HOSTNAME=${HOSTNAME:=dev-sso.dev.coredial.com}
export REGISTRY_DB_HOST=${REGISTRY_DB_HOST:=localhost}
export REGISTRY_DB_PORT=${REGISTRY_DB_HOST:=3306}
export REGISTRY_DB_NAME=${REGISTRY_DB_HOST:=portalsso}
export REGISTRY_DB_USER=${REGISTRY_DB_HOST:=cas}
export REGISTRY_DB_PASS=${REGISTRY_DB_HOST:=c4s1sb3tt3r}
export MYSQL_VOICEAXIS_HOST=${MYSQL_VOICEAXIS_HOST:=qa6-box.dev.coredial.com}
export MYSQL_VOICEAXIS_PORT=${MYSQL_VOICEAXIS_PORT:=3306}
export MYSQL_VOICEAXIS_USER=${MYSQL_VOICEAXIS_USER:=voiceaxis}
export MYSQL_VOICEAXIS_PASSWORD=${MYSQL_VOICEAXIS_PASSWORD:=dr0az3eh}
export MYSQL_VOICEAXIS_DB=${MYSQL_VOICEAXIS_DB:=voiceaxis}

export CAS_PROPS="-Dcas.server.name='https://${HOSTNAME}' \
-Dcas.server.prefix='https://${HOSTNAME}/cas' \
-Dcas.ticket.registry.jpa.url='jdbc:mysql://${REGISTRY_DB_HOST}:${REGISTRY_DB_PORT}/${REGISTRY_DB_NAME}?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false&useSSL=false' \
-Dcas.ticket.registry.jpa.user='${REGISTRY_DB_USER}' \
-Dcas.ticket.registry.jpa.password='${REGISTRY_DB_PASS}' \
-Dcas.serviceRegistry.jpa.url='jdbc:mysql://${REGISTRY_DB_HOST}:${REGISTRY_DB_PORT}/${REGISTRY_DB_NAME}?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false&useSSL=false' \
-Dcas.serviceRegistry.jpa.user='${REGISTRY_DB_USER}' \
-Dcas.serviceRegistry.jpa.password='${REGISTRY_DB_PASS}' \
-Dcas.audit.jdbc.url='jdbc:mysql://${REGISTRY_DB_HOST}:${REGISTRY_DB_PORT}/${REGISTRY_DB_NAME}?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false&useSSL=false' \
-Dcas.audit.jdbc.user='${REGISTRY_DB_USER}' \
-Dcas.audit.jdbc.password='${REGISTRY_DB_PASS}' \
-Dcas.authn.jdbc.query[0].url='jdbc:mysql://${MYSQL_VOICEAXIS_HOST}:${MYSQL_VOICEAXIS_PORT}/${MYSQL_VOICEAXIS_DB}?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false&useSSL=false&serverTimezone=US/Eastern&zeroDateTimeBehavior=CONVERT_TO_NULL' \
-Dcas.authn.jdbc.query[0].user='${MYSQL_VOICEAXIS_USER}' \
-Dcas.authn.jdbc.query[0].password='${MYSQL_VOICEAXIS_PASSWORD}' \
-Dcas.authn.samlIdp.entityId='https://${HOSTNAME}/cas/idp' \
-Dcas.authn.samlIdp.scope='${HOSTNAME}' "

# echo "Use of this image/container constitutes acceptence of the Oracle Binary Code License Agreement for Java SE."
cd /cas-overlay/
echo -e "Executing build from directory:" && pwd
exec java ${JVM_OPTS} ${CAS_PROPS} -jar target/cas.war
