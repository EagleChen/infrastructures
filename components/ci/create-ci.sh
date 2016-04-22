#!/bin/bash

docker-compose -f ci-compose.yml --host <swarm_manager_addr> --verbose up -d

# when 'use_tls'
# docker-compose -f ci-compose.yml --host <swarm_manager_addr> --tlsverify --tlscacert ca.pem --tlscert client.pem --tlskey client-key.pem up -d
