#!/bin/bash

# Write SAML metadata using installed keys/certs
export IDP_SIGNING_CERT=$(sed -e '1d' -e '$d' /etc/cas/saml/idp-signing.crt)
export IDP_ENCRYPT_CERT=$(sed -e '1d' -e '$d' /etc/cas/saml/idp-encryption.crt)
cat > /etc/cas/saml/idp-metadata.xml <<__EOF__
<?xml version="1.0" encoding="UTF-8"?>
<EntityDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:shibmd="urn:mace:shibboleth:metadata:1.0" xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns:mdui="urn:oasis:names:tc:SAML:metadata:ui" entityID="https://${HOSTNAME}/cas/idp">
    <IDPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol urn:oasis:names:tc:SAML:1.1:protocol urn:mace:shibboleth:1.0">
        <Extensions>
            <shibmd:Scope regexp="false">${HOSTNAME}</shibmd:Scope>
        </Extensions>
        <KeyDescriptor use="signing">
            <ds:KeyInfo>
                <ds:X509Data>
                    <ds:X509Certificate>${IDP_SIGNING_CERT}</ds:X509Certificate>
                </ds:X509Data>
            </ds:KeyInfo>
        </KeyDescriptor>
        <KeyDescriptor use="encryption">
            <ds:KeyInfo>
                <ds:X509Data>
                    <ds:X509Certificate>${IDP_ENCRYPT_CERT}</ds:X509Certificate>
                </ds:X509Data>
            </ds:KeyInfo>
        </KeyDescriptor>

        <ArtifactResolutionService Binding="urn:oasis:names:tc:SAML:1.0:bindings:SOAP-binding"
                                   Location="https://${HOSTNAME}/cas/idp/profile/SAML1/SOAP/ArtifactResolution" index="1"/>

        <SingleLogoutService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://${HOSTNAME}/cas/idp/profile/SAML2/POST/SLO"/>

        <NameIDFormat>urn:mace:shibboleth:1.0:nameIdentifier</NameIDFormat>
        <NameIDFormat>urn:oasis:names:tc:SAML:2.0:nameid-format:transient</NameIDFormat>

        <SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" Location="https://${HOSTNAME}/cas/idp/profile/SAML2/POST/SSO"/>
        <SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST-SimpleSign" Location="https://${HOSTNAME}/cas/idp/profile/SAML2/POST-SimpleSign/SSO"/>
        <SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" Location="https://${HOSTNAME}/cas/idp/profile/SAML2/Redirect/SSO"/>
        <SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:SOAP" Location="https://${HOSTNAME}/cas/idp/profile/SAML2/SOAP/ECP"/>
    </IDPSSODescriptor>

    <AttributeAuthorityDescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:1.1:protocol urn:oasis:names:tc:SAML:2.0:protocol">
        <Extensions>
            <shibmd:Scope regexp="false">${HOSTNAME}</shibmd:Scope>
        </Extensions>
        <KeyDescriptor use="signing">
            <ds:KeyInfo>
                <ds:X509Data>
                    <ds:X509Certificate>${IDP_SIGNING_CERT}</ds:X509Certificate>
                </ds:X509Data>
            </ds:KeyInfo>
        </KeyDescriptor>
        <AttributeService Binding="urn:oasis:names:tc:SAML:1.0:bindings:SOAP-binding" Location="https://${HOSTNAME}/cas/idp/profile/SAML1/SOAP/AttributeQuery"/>
        <AttributeService Binding="urn:oasis:names:tc:SAML:2.0:bindings:SOAP" Location="https://${HOSTNAME}/cas/idp/profile/SAML2/SOAP/AttributeQuery"/>
    </AttributeAuthorityDescriptor>

    <Organization>
        <OrganizationName xml:lang="en">CoreDial, LLC</OrganizationName>
        <OrganizationDisplayName xml:lang="en">CoreDial</OrganizationDisplayName>
        <OrganizationURL xml:lang="en">https://www.coredial.com/</OrganizationURL>
    </Organization>
    <ContactPerson contactType="administrative">
        <GivenName>CoreDial Engineering</GivenName>
        <EmailAddress>cd-eng@coredial.com</EmailAddress>
    </ContactPerson>
    <ContactPerson contactType="technical">
        <GivenName>CoreDial Engineering</GivenName>
        <EmailAddress>cd-eng@coredial.com</EmailAddress>
    </ContactPerson>
    <ContactPerson contactType="support">
        <GivenName>CoreDial Support</GivenName>
        <EmailAddress>support@coredial.com</EmailAddress>
    </ContactPerson>
</EntityDescriptor>
__EOF__
