#!/bin/bash

# you should put all your servers here
export SERVER_ADDR=""

mkdir -p ~/certs
cp *.json ~/certs
cd ~/certs

# generate server ca files
export NAME=server
mkdir -p $NAME
echo '{"CN":"'$NAME'","hosts":[""],"key":{"algo":"ecdsa","size":256}}' | cfssl gencert -ca=ca/ca.pem -ca-key=ca/ca-key.pem -config=ca-config.json -profile=server -hostname="$SERVER_ADDR" - | cfssljson -bare $NAME
chmod 0600 $NAME-key.pem
mv $NAME.csr  $NAME-key.pem  $NAME.pem $NAME/
