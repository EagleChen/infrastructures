# infrastructures

ansible and bash scripts for bringing up etcd cluster, docker engine, swarm cluster and so on. TLS supported.

## Prerequisites
* [ansible](http://docs.ansible.com/ansible/intro_installation.html) ( version >= 2.0)
* [cfssl](https://github.com/cloudflare/cfssl) tools (cfssl and cfssljson) if you need tls. Here are the [binaries](https://pkg.cfssl.org/)

## Usage
* __set your hosts in `hosts.yml` and set credentials in `group_vars/all`. If you have different usernames, passwords for different hosts, please refer to the official Ansible documents on how to do this.__

	Here is a sample `hosts.yml`:
	```
[etcd_servers]
host10 ansible_host=192.168.0.10
host11 ansible_host=192.168.0.11
host12 ansible_host=192.168.0.12

[docker_servers]
host10 ansible_host=192.168.0.10
host11 ansible_host=192.168.0.11
host12 ansible_host=192.168.0.12

[swarm_managers]
host10 ansible_host=192.168.0.10
	```
	and a sample `group_vars\all`
	```
---
ansible_user: ubuntu
ansible_ssh_pass: 111111
	```

* __generate certificates for tls.__ if you don't need tls, skip this step.
Set all your server ips in  `certs/generate_server.sh` and your etcd ips in `certs/generate_c_s.sh`.
All the certs will be generated in `~/certs`, you may want to check them after this generation.
Run the following command to generate them:
	```
certs/generate_certs.sh
	```

* __bring up etcd, docker, swarm node and swarm manager.__ If you don't need to bring up everything, please change `infra.yml` to execlude some components.
Note: if you don't need tls, please set `use_tls` to `false` in `infra.yml`.
Here is the command to bring up every thing:
	```
ansible-playbook -i hosts infra.yml
	```

## Notes
1. If tls is enabled, please refer to [docker official document](https://docs.docker.com/swarm/configure-tls/#step-8-test-the-swarm-manager-configuration) on how to test your cluster.
If not, use the following command to check:
	```
	docker -H <swarm manager ip>:<swarm manager port> info
	```
2. These scripts can help to bring up a cluster of etcd, docker and swarm. But you can also bring up a test env by setting only one host for each group. For example:
    ```
	[etcd_servers]
	host10 ansible_host=192.168.0.10

	[docker_servers]
	host10 ansible_host=192.168.0.10

	[swarm_managers]
	host10 ansible_host=192.168.0.10
    ```
