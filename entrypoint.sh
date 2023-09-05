#!/bin/bash

set -euo pipefail

mkdir -p "/home/openolat/conf/Catalina/${OLAT_HOST}/"
cp "/home/openolat/tmp-ROOT.xml" "/home/openolat/conf/Catalina/${OLAT_HOST}/ROOT.xml"

sed -i -e "s#__PASSWORD__#${DB_PASSWORD}#" "/home/openolat/conf/Catalina/${OLAT_HOST}/ROOT.xml"
sed -i -e "s#__DB_URL__#${DB_URL}#" "/home/openolat/conf/Catalina/${OLAT_HOST}/ROOT.xml"

sed -i -e "s#__HOST__#${OLAT_HOST}#" "/home/openolat/conf/server.xml"
sed -i -e "s#__HOST__#${OLAT_HOST}#" "/home/openolat/lib/olat.local.properties"

if [ "$EXTRA_PROPERTIES" != "none" ]; then
    cat "$EXTRA_PROPERTIES" >> "/home/openolat/lib/olat.local.properties"
fi

exec /home/openolat/tomcat/bin/catalina.sh run
