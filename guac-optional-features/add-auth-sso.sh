#!/bin/bash
#######################################################################################################################
# Add OpenID Connect (SSO) support for Guacamole
# For Ubuntu / Debian / Raspbian
# Richard Dawson
# November 2025
#######################################################################################################################

# If run as standalone and not from the main installer script, check the below variables are correct.

# Prepare text output colours
GREY='\033[0;37m'
DGREY='\033[0;90m'
GREYB='\033[1;37m'
LRED='\033[0;91m'
LGREEN='\033[0;92m'
LYELLOW='\033[0;93m'
NC='\033[0m' #No Colour

clear

if ! [[ $(id -u) = 0 ]]; then
    echo
    echo -e "${LRED}Please run this script as sudo or root${NC}" 1>&2
    exit 1
fi

TOMCAT_VERSION=$(ls /etc/ | grep tomcat)
GUAC_VERSION=$(grep -oP 'Guacamole.API_VERSION = "\K[0-9\.]+' /var/lib/${TOMCAT_VERSION}/webapps/guacamole/guacamole-common-js/modules/Version.js)
GUAC_SOURCE_LINK="http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/${GUAC_VERSION}"

echo
echo -e "${GREYB}Installing OpenID Connect (SSO) authentication for Guacamole${NC}"
echo

# Download the SSO extensions package (contains OpenID, SAML, etc.)
echo -e "${GREY}Downloading guacamole-auth-sso-${GUAC_VERSION}...${GREY}"
wget -q --show-progress -O guacamole-auth-sso-${GUAC_VERSION}.tar.gz ${GUAC_SOURCE_LINK}/binary/guacamole-auth-sso-${GUAC_VERSION}.tar.gz
if [[ $? -ne 0 ]]; then
    echo -e "${LRED}Failed to download guacamole-auth-sso-${GUAC_VERSION}.tar.gz${GREY}" 1>&2
    echo -e "${GUAC_SOURCE_LINK}/binary/guacamole-auth-sso-${GUAC_VERSION}.tar.gz${GREY}"
    exit 1
fi

# Extract the SSO package
echo -e "${GREY}Extracting guacamole-auth-sso-${GUAC_VERSION}...${GREY}"
tar -xzf guacamole-auth-sso-${GUAC_VERSION}.tar.gz
if [[ $? -ne 0 ]]; then
    echo -e "${LRED}Failed to extract guacamole-auth-sso-${GUAC_VERSION}.tar.gz${GREY}" 1>&2
    exit 1
fi

# Install the OpenID Connect extension
echo -e "${GREY}Installing guacamole-auth-sso-openid-${GUAC_VERSION}.jar...${GREY}"
if [[ -f "guacamole-auth-sso-${GUAC_VERSION}/openid/guacamole-auth-sso-openid-${GUAC_VERSION}.jar" ]]; then
    mv -f guacamole-auth-sso-${GUAC_VERSION}/openid/guacamole-auth-sso-openid-${GUAC_VERSION}.jar /etc/guacamole/extensions/
    chmod 664 /etc/guacamole/extensions/guacamole-auth-sso-openid-${GUAC_VERSION}.jar
    echo -e "${LGREEN}Installed guacamole-auth-sso-openid-${GUAC_VERSION}.jar${GREY}"
else
    echo -e "${LRED}OpenID extension JAR not found in extracted package${GREY}" 1>&2
    exit 1
fi

# Add OpenID configuration template to guacamole.properties
echo
echo -e "${GREY}Adding OpenID configuration template to /etc/guacamole/guacamole.properties...${GREY}"
cat <<EOF | tee -a /etc/guacamole/guacamole.properties

# OpenID Connect (SSO) Authentication Configuration
# See https://guacamole.apache.org/doc/gug/openid-auth.html for detailed documentation
# Uncomment and configure the following properties for your OpenID provider:

# Required OpenID properties:
#openid-authorization-endpoint: https://your-provider.com/authorize
#openid-jwks-endpoint: https://your-provider.com/.well-known/jwks.json
#openid-issuer: https://your-provider.com
#openid-client-id: your-client-id
#openid-redirect-uri: http://your-guacamole-server:8080/guacamole/

# Optional OpenID properties:
#openid-username-claim-type: preferred_username
#openid-scope: openid email profile
#openid-allowed-clock-skew: 300

# Note: After configuring these properties, restart Tomcat and guacd services.
EOF

echo
echo -e "${LGREEN}OpenID Connect extension installed successfully!${GREY}"
echo
echo -e "${LYELLOW}IMPORTANT: You must configure OpenID properties in /etc/guacamole/guacamole.properties${NC}"
echo -e "${LYELLOW}See the commented configuration above or visit:${NC}"
echo -e "${LYELLOW}https://guacamole.apache.org/doc/gug/openid-auth.html${NC}"
echo

# Restart services
echo -e "${GREY}Restarting Guacamole services...${GREY}"
systemctl restart ${TOMCAT_VERSION}
systemctl restart guacd

if [[ $? -ne 0 ]]; then
    echo -e "${LRED}Failed to restart services${GREY}" 1>&2
    exit 1
else
    echo -e "${LGREEN}Services restarted successfully${GREY}"
fi

# Cleanup
rm -rf guacamole-auth-sso-*

echo
echo -e "${LGREEN}Done!${NC}"
echo -e ${NC}
