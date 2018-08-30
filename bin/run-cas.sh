#!/bin/bash
# Config variables from RC env settings
export JAVA_HOME=/opt/jre-home
export PATH=$PATH:$JAVA_HOME/bin:.
export JVM_OPTS="-server -Xms2048m -Xmx2048m -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m -XX:MinHeapFreeRatio=35 -XX:MaxHeapFreeRatio=80 -XX:NewRatio=8 -XX:SurvivorRatio=32 -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+UseParNewGC"
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

# Build CAS config file
cat > /etc/cas/config/cas.properties <<_EOF_
spring.profiles.active=native

# The configuration directory where CAS should monitor to locate settings.
spring.cloud.config.server.native.searchLocations=file:///etc/cas/config

##
# CAS Server Context Configuration
#
server.context-path=/cas
server.port=8443

server.ssl.key-store=file:/etc/cas/thekeystore
server.ssl.key-store-password=changeit
server.ssl.key-password=changeit
# server.ssl.ciphers=
# server.ssl.client-auth=
# server.ssl.enabled=
# server.ssl.key-alias=
# server.ssl.key-store-provider=
# server.ssl.key-store-type=
# server.ssl.protocol=
# server.ssl.trust-store=
# server.ssl.trust-store-password=
# server.ssl.trust-store-provider=
# server.ssl.trust-store-type=

server.max-http-header-size=2097152
server.use-forward-headers=true
server.connection-timeout=20000
server.error.include-stacktrace=ALWAYS

server.compression.enabled=true
server.compression.mime-types=application/javascript,application/json,application/xml,text/html,text/xml,text/plain

server.tomcat.max-http-post-size=2097152
server.tomcat.basedir=build/tomcat
server.tomcat.accesslog.enabled=true
server.tomcat.accesslog.pattern=%t %a "%r" %s (%D ms)
server.tomcat.accesslog.suffix=.log
server.tomcat.max-threads=10
server.tomcat.port-header=X-Forwarded-Port
server.tomcat.protocol-header=X-Forwarded-Proto
server.tomcat.protocol-header-https-value=https
server.tomcat.remote-ip-header=X-FORWARDED-FOR
server.tomcat.uri-encoding=UTF-8

spring.http.encoding.charset=UTF-8
spring.http.encoding.enabled=true
spring.http.encoding.force=true

##
# CAS Cloud Bus Configuration
#
spring.cloud.bus.enabled=false
# spring.cloud.bus.refresh.enabled=true
# spring.cloud.bus.env.enabled=true
# spring.cloud.bus.destination=CasCloudBus
# spring.cloud.bus.ack.enabled=true

# endpoints.enabled=true
# endpoints.sensitive=true

# endpoints.restart.enabled=false
# endpoints.shutdown.enabled=false

management.security.enabled=true
management.security.roles=ACTUATOR,ADMIN
management.security.sessions=if_required
management.context-path=/status
management.add-application-context-header=false

security.basic.authorize-mode=role
security.basic.enabled=false
security.basic.path=/cas/status/**

##
# CAS Web Application Session Configuration
#
server.session.timeout=300
server.session.cookie.http-only=true
server.session.tracking-modes=COOKIE

##
# CAS Thymeleaf View Configuration
#
spring.thymeleaf.encoding=UTF-8
spring.thymeleaf.cache=true
spring.thymeleaf.mode=HTML
##
# CAS Log4j Configuration
#
logging.config=file:/etc/cas/config/log4j2.xml
server.context-parameters.isLog4jAutoInitializationDisabled=true

##
# CAS AspectJ Configuration
#
spring.aop.auto=true
spring.aop.proxy-target-class=true

##
# CAS Server basic configuration
#
cas.server.name=https://${HOSTNAME}
cas.server.prefix=https://${HOSTNAME}/cas
cas.host.name=${HOSTNAME}

##
# CAS Webflow Configuration
#
cas.webflow.session.lockTimeout=30
cas.webflow.session.compress=false
cas.webflow.session.maxConversations=5
# Enable server-side session management
cas.webflow.session.storage=false

cas.webflow.crypto.enabled=true
cas.webflow.crypto.signing.key=${WEBFLOW_SIGNING_KEY}
cas.webflow.crypto.signing.keySize=512
cas.webflow.crypto.encryption.key=${WEBFLOW_ENCRYPT_KEY}
cas.webflow.crypto.encryption.keySize=16
cas.webflow.crypto.alg=AES

##
# TGT and ST configuration
#
# cas.tgc.path=
# cas.tgc.maxAge=-1
# cas.tgc.domain=
cas.tgc.name=CASTGC
cas.tgc.secure=true
cas.tgc.httpOnly=true
cas.tgc.rememberMeMaxAge=1209600

cas.tgc.crypto.signing.key=${TGC_SIGNING_KEY}
cas.tgc.crypto.encryption.key=${TGC_ENCRYPT_KEY}
cas.tgc.crypto.enabled=true

##
# CAS JPA Ticket Registry Configuration
#
cas.ticket.registry.jpa.ticketLockType=NONE
# cas.ticket.registry.jpa.jpaLockingTimeout=3600

cas.ticket.registry.jpa.healthQuery=select 1+1 two
# cas.ticket.registry.jpa.isolateInternalQueries=false
cas.ticket.registry.jpa.url=jdbc:mysql://${REGISTRY_DB_HOST}:${REGISTRY_DB_PORT}/${REGISTRY_DB_NAME}?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false&useSSL=false
# cas.ticket.registry.jpa.failFastTimeout=1
cas.ticket.registry.jpa.dialect=org.hibernate.dialect.MySQL5InnoDBDialect
# cas.ticket.registry.jpa.leakThreshold=10
cas.ticket.registry.jpa.jpaLockingTgtEnabled=false
# cas.ticket.registry.jpa.batchSize=1
# cas.ticket.registry.jpa.defaultCatalog=
# cas.ticket.registry.jpa.defaultSchema=
cas.ticket.registry.jpa.user=${REGISTRY_DB_USER}
cas.ticket.registry.jpa.ddlAuto=update
cas.ticket.registry.jpa.password=${REGISTRY_DB_PASS}
# cas.ticket.registry.jpa.autocommit=false
cas.ticket.registry.jpa.driverClass=com.mysql.jdbc.Driver
# cas.ticket.registry.jpa.idleTimeout=5000
# cas.ticket.registry.jpa.dataSourceName=java:/comp/env/jdbc/CasDatabase
# cas.ticket.registry.jpa.dataSourceProxy=false
# Hibernate-specific properties (i.e. 'hibernate.globally_quoted_identifiers')
# cas.ticket.registry.jpa.properties.propertyName=propertyValue

# cas.ticket.registry.jpa.pool.suspension=false
# cas.ticket.registry.jpa.pool.minSize=6
# cas.ticket.registry.jpa.pool.maxSize=18
# cas.ticket.registry.jpa.pool.maxWait=2000

cas.ticket.registry.jpa.crypto.enabled=true
cas.ticket.registry.jpa.crypto.signing.key=${REGISTRY_SIGNING_KEY}
cas.ticket.registry.jpa.crypto.signing.keySize=512
cas.ticket.registry.jpa.crypto.encryption.key=${REGISTRY_ENCRYPT_KEY}
cas.ticket.registry.jpa.crypto.encryption.keySize=16
cas.ticket.registry.jpa.crypto.alg=AES

##
# CAS Service Registry Configuration
#
cas.serviceRegistry.watcherEnabled=true
cas.serviceRegistry.schedule.repeatInterval=120000
cas.serviceRegistry.schedule.startDelay=15000
# Auto-initialize the registry from default JSON service definitions
# cas.serviceRegistry.initFromJson=false
cas.serviceRegistry.managementType=DEFAULT

##
# CAS JPA Service Registry Configuration
#
cas.serviceRegistry.jpa.healthQuery=select 1+1 two
# cas.serviceRegistry.jpa.isolateInternalQueries=false
cas.serviceRegistry.jpa.url=jdbc:mysql://${REGISTRY_DB_HOST}:${REGISTRY_DB_PORT}/${REGISTRY_DB_NAME}?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false&useSSL=false
# cas.serviceRegistry.jpa.failFastTimeout=1
cas.serviceRegistry.jpa.dialect=org.hibernate.dialect.MySQL5InnoDBDialect
# cas.serviceRegistry.jpa.leakThreshold=10
# cas.serviceRegistry.jpa.batchSize=1
cas.serviceRegistry.jpa.user=${REGISTRY_DB_USER}
cas.serviceRegistry.jpa.ddlAuto=update
cas.serviceRegistry.jpa.password=${REGISTRY_DB_PASS}
# cas.serviceRegistry.jpa.autocommit=false
cas.serviceRegistry.jpa.driverClass=com.mysql.jdbc.Driver
# cas.serviceRegistry.jpa.idleTimeout=5000
# cas.serviceRegistry.jpa.dataSourceName=java:/comp/env/jdbc/CasDatabase
# cas.serviceRegistry.jpa.dataSourceProxy=false
# Hibernate-specific properties (i.e. 'hibernate.globally_quoted_identifiers')
# cas.serviceRegistry.jpa.properties.propertyName=propertyValue

# cas.serviceRegistry.jpa.pool.suspension=false
# cas.serviceRegistry.jpa.pool.minSize=6
# cas.serviceRegistry.jpa.pool.maxSize=18
# cas.serviceRegistry.jpa.pool.maxWait=2000


##
# CAS Authentication Credentials
#
# cas.authn.accept.users=casuser::Mellon
cas.authn.accept.users=

##
# JWT auth support
#
cas.authn.token.name=token
# cas.authn.token.principalTransformation.pattern=(.+)@example.org
# cas.authn.token.principalTransformation.groovy.location=file:///etc/cas/config/principal.groovy
# cas.authn.token.principalTransformation.suffix=
# cas.authn.token.principalTransformation.caseConversion=NONE|UPPERCASE|LOWERCASE
# cas.authn.token.principalTransformation.prefix=

##
# TGT/ST encryption
#
cas.authn.token.crypto.enabled=true
cas.authn.token.crypto.signing.key=${TOKEN_SIGNING_KEY}
cas.authn.token.crypto.signing.keySize=512
cas.authn.token.crypto.encryption.key=${TOKEN_ENCRYPT_KEY}
cas.authn.token.crypto.encryption.keySize=256
cas.authn.token.crypto.alg=AES

##
# CAS JDBC Authentication Configuration
#
cas.authn.jdbc.query[0].sql=select \\
  u.userId uid,\\
  u.username userName, \\
  u.password password, \\
  u.firstName givenName, \\
  u.lastName sn, \\
  concat(u.firstName, ' ', u.lastName) displayName, \\
  u.email mail, \\
  u.enabled enabled, \\
  if(u.enabled=1,0,1) disabled, \\
  u.failedLogins failedLogins, \\
  u.lockedOut lockedOut, \\
  u.lockouts lockouts, \\
  u.lastLoginTime lastLoginTime, \\
  u.userType userType, \\
  u.isSalesRep isSalesRep, \\
  u.contactType contactType, \\
  u.alias alias, \\
  b.description context, \\
  c.companyName companyName, \\
  o.description organizationName, \\
  r.name roleName \\
from portal.user u \\
left join portal.branch b on u.branchId=b.branchId \\
left join portal.customer c on u.customerId=c.customerId \\
left join portal.organization o on u.organization_id=o.organization_id \\
left join portal.role r on u.role_id=r.role_id \\
where \\
  u.username=?
cas.authn.jdbc.query[0].healthQuery=select 1+1 two
# cas.authn.jdbc.query[0].isolateInternalQueries=false
cas.authn.jdbc.query[0].url=jdbc:mysql://${MYSQL_VOICEAXIS_HOST}:${MYSQL_VOICEAXIS_PORT}/${MYSQL_VOICEAXIS_DB}?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false&useSSL=false&serverTimezone=US/Eastern&zeroDateTimeBehavior=convertToNull
# cas.authn.jdbc.query[0].failFastTimeout=1
# cas.authn.jdbc.query[0].isolationLevelName=ISOLATION_READ_COMMITTED
cas.authn.jdbc.query[0].dialect=org.hibernate.dialect.MySQL5InnoDBDialect
# cas.authn.jdbc.query[0].leakThreshold=10
# cas.authn.jdbc.query[0].propagationBehaviorName=PROPAGATION_REQUIRED
# cas.authn.jdbc.query[0].batchSize=1
cas.authn.jdbc.query[0].user=${MYSQL_VOICEAXIS_USER}
cas.authn.jdbc.query[0].ddlAuto=none
# cas.authn.jdbc.query[0].maxAgeDays=180
cas.authn.jdbc.query[0].password=${MYSQL_VOICEAXIS_PASSWORD}
# cas.authn.jdbc.query[0].autocommit=false
cas.authn.jdbc.query[0].driverClass=com.mysql.jdbc.Driver
# cas.authn.jdbc.query[0].idleTimeout=5000
# cas.authn.jdbc.query[0].credentialCriteria=
cas.authn.jdbc.query[0].name=SwitchConnexPortalDB
cas.authn.jdbc.query[0].order=0
# cas.authn.jdbc.query[0].dataSourceName=java:/comp/env/jdbc/PortalDatabase
# cas.authn.jdbc.query[0].dataSourceProxy=false
# Hibernate-specific properties (i.e. 'hibernate.globally_quoted_identifiers')
# cas.authn.jdbc.query[0].properties.propertyName=propertyValue

cas.authn.jdbc.query[0].fieldPassword=password
#cas.authn.jdbc.query[0].fieldExpired=
cas.authn.jdbc.query[0].fieldDisabled=disabled
cas.authn.jdbc.query[0].principalAttributeList=uid,userName,givenName,sn,displayName,mail,userType,isSalesRep,contactType,alias,context,companyName,organizationName,roleName

cas.authn.jdbc.query[0].passwordEncoder.type=DEFAULT
cas.authn.jdbc.query[0].passwordEncoder.characterEncoding=UTF-8
cas.authn.jdbc.query[0].passwordEncoder.encodingAlgorithm=SHA1
#cas.authn.jdbc.query[0].passwordEncoder.secret=
#cas.authn.jdbc.query[0].passwordEncoder.strength=16

# cas.authn.jdbc.query[0].principalTransformation.pattern=(.+)@example.org
# cas.authn.jdbc.query[0].principalTransformation.groovy.location=file:///etc/cas/config/principal.groovy
# cas.authn.jdbc.query[0].principalTransformation.suffix=
# cas.authn.jdbc.query[0].principalTransformation.caseConversion=NONE|UPPERCASE|LOWERCASE
# cas.authn.jdbc.query[0].principalTransformation.prefix=

##
# CAS SAML Core Configuration
#
# cas.samlCore.ticketidSaml2=false
# cas.samlCore.skewAllowance=5
# cas.samlCore.issueLength=30
# cas.samlCore.attributeNamespace=http://www.ja-sig.org/products/cas/
# cas.samlCore.issuer=localhost
cas.samlCore.securityManager=com.sun.org.apache.xerces.internal.util.SecurityManager

##
# CAS SAML IdP Configuration
#
cas.authn.samlIdp.entityId=https://${HOSTNAME}/cas/idp
cas.authn.samlIdp.scope=${HOSTNAME}
# cas.authn.samlIdp.authenticationContextClassMappings[0]=urn:oasis:names:tc:SAML:2.0:ac:classes:SomeClassName->mfa-duo

# cas.authn.samlIdp.metadata.cacheExpirationMinutes=30
# cas.authn.samlIdp.metadata.failFast=true
# cas.authn.samlIdp.metadata.location=file:/etc/cas/saml
# cas.authn.samlIdp.metadata.privateKeyAlgName=RSA
# cas.authn.samlIdp.metadata.requireValidMetadata=true

# cas.authn.samlIdp.metadata.basicAuthnUsername=
# cas.authn.samlIdp.metadata.basicAuthnPassword=
# cas.authn.samlIdp.metadata.supportedContentTypes=

# cas.authn.samlIdp.attributeQueryProfileEnabled=true

# cas.authn.samlIdp.logout.forceSignedLogoutRequests=true
# cas.authn.samlIdp.logout.singleLogoutCallbacksDisabled=false

# cas.authn.samlIdp.response.defaultAuthenticationContextClass=
# cas.authn.samlIdp.response.defaultAttributeNameFormat=uri
# cas.authn.samlIdp.response.signError=false
# cas.authn.samlIdp.response.signingCredentialType=X509|BASIC
# cas.authn.samlIdp.response.useAttributeFriendlyName=true
# cas.authn.samlIdp.response.attributeNameFormats=attributeName->basic|uri|unspecified|custom-format-etc,...

# cas.authn.samlIdp.algs.overrideSignatureCanonicalizationAlgorithm=
# cas.authn.samlIdp.algs.overrideDataEncryptionAlgorithms=
# cas.authn.samlIdp.algs.overrideKeyEncryptionAlgorithms=
# cas.authn.samlIdp.algs.overrideBlackListedEncryptionAlgorithms=
# cas.authn.samlIdp.algs.overrideWhiteListedAlgorithms=
# cas.authn.samlIdp.algs.overrideSignatureReferenceDigestMethods=
# cas.authn.samlIdp.algs.overrideSignatureAlgorithms=
# cas.authn.samlIdp.algs.overrideBlackListedSignatureSigningAlgorithms=
# cas.authn.samlIdp.algs.overrideWhiteListedSignatureSigningAlgorithms=

##
# SAML MDUI Configuration
#
cas.samlMetadataUi.requireValidMetadata=true
cas.samlMetadataUi.repeatInterval=120000
cas.samlMetadataUi.startDelay=30000
# cas.samlMetadataUi.resources=classpath:/sp-metadata::classpath:/pub.key,http://md.incommon.org/InCommon/InCommon-metadata.xml::classpath:/inc-md-pub.key
cas.samlMetadataUi.resources=
cas.samlMetadataUi.maxValidity=0
cas.samlMetadataUi.requireSignedRoot=false
cas.samlMetadataUi.parameter=entityId

##
# CAS Delegated Authentication configuration
#
# cas.authn.pac4j.typedIdUsed=false
# cas.authn.pac4j.autoRedirect=false
cas.authn.pac4j.name=google
cas.authn.pac4j.google.clientName=Google
cas.authn.pac4j.google.id=461822349939-sqk1fp5au5rts6ef0gvqkkvnurkoqs38.apps.googleusercontent.com
cas.authn.pac4j.google.secret=_eTILd0oM1fEeGH_TrQLd-8K
cas.authn.pac4j.google.scope=EMAIL_AND_PROFILE

##
# Database audit storage configuration
#
cas.audit.jdbc.healthQuery=select 1+1 two
# cas.audit.jdbc.isolateInternalQueries=false
cas.audit.jdbc.url=jdbc:mysql://${REGISTRY_DB_HOST}:${REGISTRY_DB_PORT}/${REGISTRY_DB_NAME}?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false&useSSL=false
# cas.audit.jdbc.failFast=true
# cas.audit.jdbc.isolationLevelName=ISOLATION_READ_COMMITTED
cas.audit.jdbc.dialect=org.hibernate.dialect.MySQL5InnoDBDialect
# cas.audit.jdbc.leakThreshold=10
# cas.audit.jdbc.propagationBehaviorName=PROPAGATION_REQUIRED
# cas.audit.jdbc.batchSize=1
cas.audit.jdbc.user=${REGISTRY_DB_USER}
cas.audit.jdbc.password=${REGISTRY_DB_PASS}
#cas.audit.jdbc.ddlAuto=update
# cas.audit.jdbc.maxAgeDays=180
# cas.audit.jdbc.autocommit=false
cas.audit.jdbc.driverClass=com.mysql.jdbc.Driver
# cas.audit.jdbc.idleTimeout=5000
# cas.audit.jdbc.dataSourceName=java:/comp/env/jdbc/CasDatabase
# cas.audit.jdbc.dataSourceProxy=false

# cas.audit.jdbc.pool.suspension=false
# cas.audit.jdbc.pool.minSize=6
# cas.audit.jdbc.pool.maxSize=18
# cas.audit.jdbc.pool.maxWait=2000

##
# CAS Monitoring Endpoints configuration
#
cas.monitor.endpoints.enabled=true
cas.monitor.endpoints.sensitive=false
cas.monitor.endpoints.dashboard.enabled=true
cas.monitor.endpoints.dashboard.sensitive=false
cas.monitor.endpoints.discovery.enabled=false
cas.monitor.endpoints.discovery.sensitive=false
cas.monitor.endpoints.auditEvents.enabled=true
cas.monitor.endpoints.auditEvents.sensitive=false
cas.monitor.endpoints.authenticationEvents.enabled=true
cas.monitor.endpoints.authenticationEvents.sensitive=false
cas.monitor.endpoints.configurationState.enabled=true
cas.monitor.endpoints.configurationState.sensitive=false
cas.monitor.endpoints.healthCheck.enabled=true
cas.monitor.endpoints.healthCheck.sensitive=false
cas.monitor.endpoints.loggingConfig.enabled=true
cas.monitor.endpoints.loggingConfig.sensitive=false
cas.monitor.endpoints.metrics.enabled=true
cas.monitor.endpoints.metrics.sensitive=false
cas.monitor.endpoints.attributeResolution.enabled=true
cas.monitor.endpoints.attributeResolution.sensitive=false
cas.monitor.endpoints.singleSignOnReport.enabled=true
cas.monitor.endpoints.singleSignOnReport.sensitive=false
cas.monitor.endpoints.statistics.enabled=true
cas.monitor.endpoints.statistics.sensitive=false
cas.monitor.endpoints.trustedDevices.enabled=true
cas.monitor.endpoints.trustedDevices.sensitive=false
cas.monitor.endpoints.status.enabled=true
cas.monitor.endpoints.status.sensitive=false
cas.monitor.endpoints.singleSignOnStatus.enabled=true
cas.monitor.endpoints.singleSignOnStatus.sensitive=false
cas.monitor.endpoints.springWebflowReport.enabled=true
cas.monitor.endpoints.springWebflowReport.sensitive=false
cas.monitor.endpoints.registeredServicesReport.enabled=true
cas.monitor.endpoints.registeredServicesReport.sensitive=false
cas.monitor.endpoints.configurationMetadata.enabled=true
cas.monitor.endpoints.configurationMetadata.sensitive=false

##
# Admin pages configuration
#
endpoints.enabled=true
endpoints.sensitive=false
endpoints.restart.enabled=false
endpoints.shutdown.enabled=false

# IP address may be enough to protect all endpoints.
# If you wish to protect the admin pages via CAS itself, configure the rest.
cas.adminPagesSecurity.ip=127\\.0\\.0\\.1|172\\.16.[0-9]{1,3}\\.[0-9]{1,3}|(8\\.39\\.115\\.[0-9]{1,3}|64\\.94\\.19[67]\\.[0-9]{1,3}|198\\.58\\.4[0-7]\\.[0-9]{1,3})
cas.adminPagesSecurity.alternateIpHeaderName=X-Forwarded-For
# cas.adminPagesSecurity.loginUrl=https://portal-sso.dev.coredial.com/cas/login
# cas.adminPagesSecurity.service=https://portal-sso.dev.coredial.com/cas/status/dashboard
# cas.adminPagesSecurity.users=file:/etc/cas/config/adminusers.properties
# cas.adminPagesSecurity.adminRoles=ROLE_ADMIN

cas.adminPagesSecurity.actuatorEndpointsEnabled=true

##
# Groovy shell configuration
#
# shell.commandRefreshInterval=15
# shell.commandPathPatterns=classpath*:/commands/**
shell.auth.simple.user.name=user
shell.auth.simple.user.password=c4s1sb3tt3r
# shell.ssh.enabled=true
# shell.ssh.port=2000
# shell.telnet.enabled=false
# shell.telnet.port=5000
# shell.ssh.authTimeout=3000
# shell.ssh.idleTimeout=30000
_EOF_

# echo "Use of this image/container constitutes acceptence of the Oracle Binary Code License Agreement for Java SE."
cd /cas-overlay/
env |sort
echo -e "Executing build from directory: $(pwd)"
echo -e "Executing command: exec java ${JVM_OPTS} -jar target/cas.war"
exec java ${JVM_OPTS} -jar target/cas.war
