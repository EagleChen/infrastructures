#!/bin/bash

# etcd servers should be seperated by space
export ETCD_ADDR=""

mkdir -p ~/certs
cp *.json ~/certs
cd ~/certs

for etcd_host in $ETCD_ADDR; do
    export NAME=$etcd_client
    mkdir -p $etcd_host
    echo '{"CN":"NAME","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca=ca/ca.pem -ca-key=ca/ca-key.pem -config=ca-config.json -profile=client-server -hostname="$etcd_host" - | cfssljson -bare member
    chmod 0600 member-key.pem
    mv member.csr  member-key.pem member.pem $etcd_host/
done
