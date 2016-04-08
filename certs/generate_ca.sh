#!/bin/bash

mkdir -p ~/certs
cp *.json ~/certs
cd ~/certs

# generate private ca files
mkdir ca
cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
chmod 0600 ca-key.pem
mv ca.csr  ca-key.pem  ca.pem ca/
