#!/bin/bash

jar cfmv branding.jar META-INF/MANIFEST.MF guac-manifest.json css images translations META-INF
sudo mv branding.jar /etc/guacamole/extensions 
sudo chmod 664 /etc/guacamole/extensions/branding.jar 
TOMCAT=$(ls /etc/ | grep tomcat)
sudo systemctl restart guacd && sudo systemctl restart ${TOMCAT}
