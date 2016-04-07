#!/bin/bash

# you should put all your servers here
# empty string means any server
export SERVER_ADDR=""
# etcd servers should be seperated by space
export ETCD_ADDR=""

mkdir ~/certs
cp *.json ~/certs
cd ~/certs

# generate private ca files
mkdir ca
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
chmod 0600 ca-key.pem
mv ca.csr  ca-key.pem  ca.pem ca/

# generate server ca files
export NAME=server
mkdir -p $NAME
echo '{"CN":"'$NAME'","hosts":[""],"key":{"algo":"ecdsa","size":256}}' | cfssl gencert -ca=ca/ca.pem -ca-key=ca/ca-key.pem -config=ca-config.json -profile=server -hostname="$SERVER_ADDR" - | cfssljson -bare $NAME
chmod 0600 $NAME-key.pem
mv $NAME.csr  $NAME-key.pem  $NAME.pem $NAME/

# generate client ca files
export NAME=client
mkdir -p $NAME
echo '{"CN":"$NAME","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca=ca/ca.pem -ca-key=ca/ca-key.pem -config=ca-config.json -profile=client - | cfssljson -bare $NAME
chmod 0600 $NAME-key.pem
mv $NAME.csr  $NAME-key.pem  $NAME.pem $NAME/

for etcd_host in $ETCD_ADDR; do
    export NAME=$etcd_client
    mkdir -p $etcd_host
    echo '{"CN":"NAME","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca=ca/ca.pem -ca-key=ca/ca-key.pem -config=ca-config.json -profile=client-server -hostname="$etcd_host" - | cfssljson -bare member
    chmod 0600 member-key.pem
    mv member.csr  member-key.pem member.pem $etcd_host/
done
