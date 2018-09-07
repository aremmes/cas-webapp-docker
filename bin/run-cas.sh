#!/bin/bash
# Config variables from RC env settings
export JAVA_HOME=/opt/jre-home
export PATH=$PATH:$JAVA_HOME/bin:.
export JVM_OPTS="${JVM_OPTS:=-server -Xms2048m -Xmx2048m -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m -XX:MinHeapFreeRatio=35 -XX:MaxHeapFreeRatio=80 -XX:NewRatio=8 -XX:SurvivorRatio=32 -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC}"

# Parameters going into CAS config
declare -A cas_opts
cas_opts=( \
    ["cdllc.hostname"]="${HOSTNAME:=dev-sso.dev.coredial.com}" \
    ["cdllc.registry.db.host"]="${REGISTRY_DB_HOST:=localhost}" \
    ["cdllc.registry.db.port"]="${REGISTRY_DB_PORT:=3306}" \
    ["cdllc.registry.db.name"]="${REGISTRY_DB_NAME:=portalsso}" \
    ["cdllc.registry.db.user"]="${REGISTRY_DB_USER:=cas}" \
    ["cdllc.registry.db.pass"]="${REGISTRY_DB_PASS:=c4s1sb3tt3r}" \
    ["cdllc.mysql.voiceaxis.host"]="${MYSQL_VOICEAXIS_HOST:=qa6-box.dev.coredial.com}" \
    ["cdllc.mysql.voiceaxis.port"]="${MYSQL_VOICEAXIS_PORT:=3306}" \
    ["cdllc.mysql.voiceaxis.user"]="${MYSQL_VOICEAXIS_USER:=voiceaxis}" \
    ["cdllc.mysql.voiceaxis.password"]="${MYSQL_VOICEAXIS_PASSWORD:=dr0az3eh}" \
    ["cdllc.mysql.voiceaxis.db"]="${MYSQL_VOICEAXIS_DB:=voiceaxis}" \
    ["cdllc.token.signing.key"]="${TOKEN_SIGNING_KEY:=x_4kw3fmDDSNcGbaqIcKapRcCP_akE1Dkqjfo9UO38VJ2yeeCoecqdPlEinTiE9svt3PjzWPg0EyW0bc4Pf4Xw}" \
    ["cdllc.token.encrypt.key"]="${TOKEN_ENCRYPT_KEY:=BCz7gJh_t2nDDZRwZLbREdhlx0oy1_qZFFnZn4IVto8}" \
    ["cdllc.webflow.signing.key"]="${WEBFLOW_SIGNING_KEY:=W1u4-NpCKZHhrqsHPmG-VsN4uAj9NvMlJs-UNGJbmORJZhe8BqSQWtNdlltTARIKlYakxwPla6OIRY_-rYU7hw}" \
    ["cdllc.webflow.encrypt.key"]="${WEBFLOW_ENCRYPT_KEY:=enlWcWxtZk9GQnhheXJRdg==}" \
    ["cdllc.tgc.signing.key"]="${TGC_SIGNING_KEY:=djfLEJaeLV-YeULLPi7AkogQOvNCGxLOXw_j_VVZiehCFqTSpb6uoSjN8hNN5Oey0Dmnbm0uUctgv5zvhvn21g}" \
    ["cdllc.tgc.encrypt.key"]="${TGC_ENCRYPT_KEY:=7g6FtyWaVU3IQdhgOu9pUz7IZmkNGsJ1vixBzxz0FOg}" \
    ["cdllc.registry.signing.key"]="${REGISTRY_SIGNING_KEY:=ai7I046C_RbCclExXhW44lUs8Byl0pVMOnCvi2WZvdOKGYb3z5Hm1aBspKkdXj5EK9A0VYNrOMcBNULoVfIYng}" \
    ["cdllc.registry.encrypt.key"]="${REGISTRY_ENCRYPT_KEY:=RVFzdW5vcVhXZ2d3eGVmUQ==}" \
    ["cdllc.tomcat.keystore.file"]="${TOMCAT_KEYSTORE_FILE:=file:///etc/cas/ssl/star.dev.coredial.com.p12}" \
    ["cdllc.tomcat.keystore.type"]="${TOMCAT_KEYSTORE_TYPE:=PKCS12}" \
    ["cdllc.tomcat.keystore.pass"]="${TOMCAT_KEYSTORE_PASS:=k3y5t0r3}" \
    ["cdllc.tomcat.key.pass"]="${TOMCAT_KEY_PASS:=k3y5t0r3}" \
    ["cdllc.tomcat.key.alias"]="${TOMCAT_KEY_ALIAS:=1}" \
)

# Build CAS config parameters
CAS_OPTS=""
for k in ${!cas_opts[@]}; do
    CAS_OPTS+="-D${k}=${cas_opts[${k}]} "
done

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
echo -e "Executing command: exec java ${JVM_OPTS} ${CAS_OPTS} -jar target/cas.war"
exec java ${JVM_OPTS} ${CAS_OPTS} -jar target/cas.war
