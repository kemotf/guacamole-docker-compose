#!/bin/sh
#
# check if docker is running
if ! (docker ps >/dev/null 2>&1)
then
	echo "docker daemon not running, will exit here!"
	exit
fi
echo "Preparing folder init and creating ./init/initdb.sql"
mkdir -p ./volumes/postgres/init >/dev/null 2>&1
mkdir -p ./volumes/nginx/ssl >/dev/null 2>&1
chmod -R +x ./volumes/postgres/init
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgresql > ./volumes/postgres/init/initdb.sql
echo "done"
echo "Creating SSL certificates"
openssl req -nodes -newkey rsa:2048 -new -x509 -keyout ./volumes/nginx/ssl/self-ssl.key -out ./volumes/nginx/ssl/self.cert -subj '/C=DE/ST=BY/L=Hintertupfing/O=Dorfwirt/OU=Theke/CN=www.h03.local/emailAddress=kemotf@gmail.com'
echo "You can use your own certificates by placing the private key in ./volumes/nginx/ssl/self-ssl.key and the cert in ./volumes/nginx/ssl/self.cert"
