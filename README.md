# SWARM
swarm-master
```
ansible-playbook /vagrant/ansible/swarm.yml  -i /vagrant/ansible/hosts/swarm
```
https://docs.projectcalico.org/v2.5/getting-started/docker/installation/requirements

## Reference
### Test etcd
```
 1.check version
 curl -L http://10.100.193.201:2379/version
 curl -L http://10.100.193.202:2379/version
 curl -L http://10.100.193.203:2379/version
 curl -L http://10.100.193.204:2379/version
 curl -L http://10.100.193.205:2379/version
 
 2.add value
 curl http://10.100.193.201:2379/v2/keys/test  -X  PUT  -d  value="works"  | jq  '.'
 
 3.check value
 curl http://10.100.193.202:2379/v2/keys/test    | jq  '.'
 curl http://10.100.193.203:2379/v2/keys/test    | jq  '.'
 curl http://10.100.193.204:2379/v2/keys/test    | jq  '.'
 curl http://10.100.193.205:2379/v2/keys/test    | jq  '.'
  
```

### etcd startup on swarm-1 (10.100.193.201)
```
nohup   etcd --name swarm-1 --initial-advertise-peer-urls http://10.100.193.201:2380 --listen-peer-urls http://10.100.193.201:2380 --listen-client-urls http://10.100.193.201:2379,http://127.0.0.1:2379 --advertise-client-urls http://10.100.193.201:2379 --initial-cluster-token serv-disc-cluster --initial-cluster swarm-1=http://10.100.193.201:2380,swarm-2=http://10.100.193.202:2380,swarm-3=http://10.100.193.203:2380,swarm-4=http://10.100.193.204:2380,swarm-5=http://10.100.193.205:2380 --initial-cluster-state new >/var/log/etcd.log 2>&1 &
```

### Installation of Calico Information
#### Reference
https://docs.projectcalico.org/v2.5/getting-started/docker/tutorials/security-using-calico-profiles <br/>

https://docs.projectcalico.org/v2.5/getting-started/docker/tutorials/security-using-docker-labels-and-calico-policy <br/>

https://docs.projectcalico.org/v2.5/usage/configuration/as-service <br/>

#### calico.env - the EnvironmentFile
```
ETCD_ENDPOINTS=http://localhost:2379
ETCD_CA_FILE=""
ETCD_CERT_FILE=""
ETCD_KEY_FILE=""
CALICO_NODENAME=""
CALICO_NO_DEFAULT_POOLS=""
CALICO_IP=""
CALICO_IP6=""
CALICO_AS=""
CALICO_LIBNETWORK_ENABLED=true
CALICO_NETWORKING_BACKEND=bird
```

#### Systemd Service Example
calico-node.service - the Systemd service:
```
[Unit]
Description=calico-node
After=docker.service
Requires=docker.service

[Service]
EnvironmentFile=/etc/calico/calico.env
ExecStartPre=-/usr/bin/docker rm -f calico-node
ExecStart=/usr/bin/docker run --net=host --privileged \
 --name=calico-node \
 -e NODENAME=${CALICO_NODENAME} \
 -e IP=${CALICO_IP} \
 -e IP6=${CALICO_IP6} \
 -e CALICO_NETWORKING_BACKEND=${CALICO_NETWORKING_BACKEND} \
 -e AS=${CALICO_AS} \
 -e NO_DEFAULT_POOLS=${CALICO_NO_DEFAULT_POOLS} \
 -e CALICO_LIBNETWORK_ENABLED=${CALICO_LIBNETWORK_ENABLED} \
 -e ETCD_ENDPOINTS=${ETCD_ENDPOINTS} \
 -e ETCD_CA_CERT_FILE=${ETCD_CA_CERT_FILE} \
 -e ETCD_CERT_FILE=${ETCD_CERT_FILE} \
 -e ETCD_KEY_FILE=${ETCD_KEY_FILE} \
 -v /var/log/calico:/var/log/calico \
 -v /run/docker/plugins:/run/docker/plugins \
 -v /lib/modules:/lib/modules \
 -v /var/run/calico:/var/run/calico \
 quay.io/calico/node:v2.5.1

ExecStop=-/usr/bin/docker stop calico-node

[Install]
WantedBy=multi-user.target
```
###  Create the Docker network
```
docker network create --driver calico --ipam-driver calico-ipam net1
```

###  Create the Labeled Workload
```
docker run --label org.projectcalico.label.role=frontend --net net1 --name frontend-A -tid busybox

docker run --label org.projectcalico.label.role=database --net net1 --name database-A -tid busybox
```

# Conclusion
https://docs.docker.com/engine/extend/plugins_network/

## Network driver plugins and swarm mode
Docker 1.12 adds support for cluster management and orchestration called swarm mode. Docker Engine running in swarm mode currently <strong> only supports the built-in overlay driver for networking </strong> . Therefore existing networking plugins will not work in swarm mode.

When you run Docker Engine outside of swarm mode, all networking plugins that worked in Docker 1.11 will continue to function normally. They do not require any modification.

## Reference
http://chunqi.li/2015/11/09/docker-multi-host-networking/

