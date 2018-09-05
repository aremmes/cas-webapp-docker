#!/bin/bash
# Config variables from RC env settings
export JAVA_HOME=/opt/jre-home
export PATH=$PATH:$JAVA_HOME/bin:.
export JVM_OPTS="${JVM_OPTS:=-server -Xms2048m -Xmx2048m -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m -XX:MinHeapFreeRatio=35 -XX:MaxHeapFreeRatio=80 -XX:NewRatio=8 -XX:SurvivorRatio=32 -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC}"
export HOSTNAME=${HOSTNAME:=dev-sso.dev.coredial.com}
export REGISTRY_DB_HOST=${REGISTRY_DB_HOST:=localhost}
export REGISTRY_DB_PORT=${REGISTRY_DB_PORT:=3306}
export REGISTRY_DB_NAME=${REGISTRY_DB_NAME:=portalsso}
export REGISTRY_DB_USER=${REGISTRY_DB_USER:=cas}
export REGISTRY_DB_PASS=${REGISTRY_DB_PASS:=c4s1sb3tt3r}
export MYSQL_VOICEAXIS_HOST=${MYSQL_VOICEAXIS_HOST:=qa6-box.dev.coredial.com}
export MYSQL_VOICEAXIS_PORT=${MYSQL_VOICEAXIS_PORT:=3306}
export MYSQL_VOICEAXIS_USER=${MYSQL_VOICEAXIS_USER:=voiceaxis}
export MYSQL_VOICEAXIS_PASSWORD=${MYSQL_VOICEAXIS_PASSWORD:=dr0az3eh}
export MYSQL_VOICEAXIS_DB=${MYSQL_VOICEAXIS_DB:=voiceaxis}
export TOKEN_SIGNING_KEY=${TOKEN_SIGNING_KEY:=x_4kw3fmDDSNcGbaqIcKapRcCP_akE1Dkqjfo9UO38VJ2yeeCoecqdPlEinTiE9svt3PjzWPg0EyW0bc4Pf4Xw}
export TOKEN_ENCRYPT_KEY=${TOKEN_ENCRYPT_KEY:=BCz7gJh_t2nDDZRwZLbREdhlx0oy1_qZFFnZn4IVto8}
export WEBFLOW_SIGNING_KEY=${WEBFLOW_SIGNING_KEY:=W1u4-NpCKZHhrqsHPmG-VsN4uAj9NvMlJs-UNGJbmORJZhe8BqSQWtNdlltTARIKlYakxwPla6OIRY_-rYU7hw}
export WEBFLOW_ENCRYPT_KEY=${WEBFLOW_ENCRYPT_KEY:=enlWcWxtZk9GQnhheXJRdg==}
export TGC_SIGNING_KEY=${TGC_SIGNING_KEY:=djfLEJaeLV-YeULLPi7AkogQOvNCGxLOXw_j_VVZiehCFqTSpb6uoSjN8hNN5Oey0Dmnbm0uUctgv5zvhvn21g}
export TGC_ENCRYPT_KEY=${TGC_ENCRYPT_KEY:=7g6FtyWaVU3IQdhgOu9pUz7IZmkNGsJ1vixBzxz0FOg}
export REGISTRY_SIGNING_KEY=${REGISTRY_SIGNING_KEY:=ai7I046C_RbCclExXhW44lUs8Byl0pVMOnCvi2WZvdOKGYb3z5Hm1aBspKkdXj5EK9A0VYNrOMcBNULoVfIYng}
export REGISTRY_ENCRYPT_KEY=${REGISTRY_ENCRYPT_KEY:=RVFzdW5vcVhXZ2d3eGVmUQ==}
export TOMCAT_KEYSTORE_FILE="${TOMCAT_KEYSTORE_FILE:=file:///etc/cas/ssl/star.dev.coredial.com.p12}"
export TOMCAT_KEYSTORE_TYPE="${TOMCAT_KEYSTORE_TYPE:=PKCS12}"
export TOMCAT_KEYSTORE_PASS="${TOMCAT_KEYSTORE_PASS:=k3y5t0r3}"
export TOMCAT_KEY_PASS="${TOMCAT_KEY_PASS:=k3y5t0r3}"
export TOMCAT_KEY_ALIAS="${TOMCAT_KEY_ALIAS:=1}"

# Build CAS config file
source /cas-overlay/bin/write-cas-properties.sh

# Write IDP keys/certs and metadata -- only if set in the config
# If we don't set this, CAS will automatically create new keys/certs
# and metadata file, useful for dev environments
if [ -r /etc/cas/saml/idp-signing.key \
  -a -r /etc/cas/saml/idp-signing.crt \
  -a -r /etc/cas/saml/idp-encryption.key \
  -a -r  /etc/cas/saml/idp-encryption.crt ]; then
  source /cas-overlay/bin/write-idp-metadata.sh
fi

# echo "Use of this image/container constitutes acceptence of the Oracle Binary Code License Agreement for Java SE."
cd /cas-overlay/
env |sort
echo -e "Executing build from directory: $(pwd)"
echo -e "Executing command: exec java ${JVM_OPTS} -jar target/cas.war"
exec java ${JVM_OPTS} -jar target/cas.war
