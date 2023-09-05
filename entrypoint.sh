#!/bin/bash

set -euo pipefail


sed -i -e s/__PASSWORD__/${DB_PASSWORD}/ /home/openolat/conf/Catalina/localhost/ROOT.xml
sed -i -e s#__DB_URL__#${DB_URL}# /home/openolat/conf/Catalina/localhost/ROOT.xml

exec /home/openolat/tomcat/bin/catalina.sh run
