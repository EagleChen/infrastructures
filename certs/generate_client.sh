#!/bin/bash

mkdir -p ~/certs
cp *.json ~/certs
cd ~/certs

# generate client ca files
export NAME=client
mkdir -p $NAME
echo '{"CN":"$NAME","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca=ca/ca.pem -ca-key=ca/ca-key.pem -config=ca-config.json -profile=client - | cfssljson -bare $NAME
chmod 0600 $NAME-key.pem
mv $NAME.csr  $NAME-key.pem  $NAME.pem $NAME/
