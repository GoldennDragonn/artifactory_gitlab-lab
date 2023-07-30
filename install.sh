#!/bin/bash

docker load -i ./setupfolder/httpd.tar
docker load -i ./setupfolder/artifactory.tar
docker load -i ./setupfolder/gitlab.tar
mkdir -p ./jcr/var
chown -R 1030:1030 ./jcr/var
openssl genrsa -out ca.key 4096
openssl req -new -x509 -days 3650 -subj "/C=CN/ST=Israel/L=Haifa/O=YakovBeder" -key ca.key -out ca.crt
openssl req -newkey rsa:2048 -nodes -keyout $1.key -subj "/C=CN/ST=Israel/L=Haifa/O=YakovBeder/OU=<OU>/CN=www.yb.local" -out $1.csr
openssl x509 -req -extfile <(printf "subjectAltName=DNS:yb.local,DNS:www.yb.local") -days 3650 -in $1.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out $1.crt
cp $1.crt ./setupfolder/$1.crt
cp $1.key ./setupfolder/$1.key
chmod 777 ./setupfolder/$1.crt 
chmod 777 ./setupfolder/$1.key
cp ./setupfolder/httpd.conf ./jcr/httpd.conf
sed -i "s/replaceHost/$1/gi" ./jcr/httpd.conf
cp ./setupfolder/$1.key ./jcr/$1.key
cp ./setupfolder/$1.crt ./jcr/$1.cert
cp ./setupfolder/docker-compose.yml ./docker-compose.yml
sed -i "s/replaceHost/$1/gi" ./docker-compose.yml

mkdir -p ./gitlab
chown -R 1030:1030 ./gitlab
mkdir -p ./gitlab/data
mkdir -p ./gitlab/logs
mkdir -p ./gitlab/config
cp ./setupfolder/root_password.txt ./gitlab/
cp ./setupfolder/gitlab.rb ./gitlab/



docker stack deploy -c docker-compose.yml $1 
echo "setup completed"
