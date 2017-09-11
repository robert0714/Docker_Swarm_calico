# SWARM
swarm-master
```
ansible-playbook /vagrant/ansible/swarm.yml  -i /vagrant/ansible/hosts/swarm
```
https://docs.projectcalico.org/v2.5/getting-started/docker/installation/requirements

## Reference
### Test etcd
```
 add value
 curl http://10.100.193.201:2379/v2/keys/test  -X  PUT  -d  value="works"  | jq  '.'
 
 check value
 curl http://10.100.193.202:2379/v2/keys/test    | jq  '.'
 curl http://10.100.193.203:2379/v2/keys/test    | jq  '.'
 curl http://10.100.193.204:2379/v2/keys/test    | jq  '.'
 curl http://10.100.193.205:2379/v2/keys/test    | jq  '.'
 
 
```

etcd startup on swarm-1 (10.100.193.201)
```
nohup   etcd --name swarm-1 --initial-advertise-peer-urls http://10.100.193.201:2380 --listen-peer-urls http://10.100.193.201:2380 --listen-client-urls http://10.100.193.201:2379,http://127.0.0.1:2379 --advertise-client-urls http://10.100.193.201:2379 --initial-cluster-token serv-disc-cluster --initial-cluster swarm-1=http://10.100.193.201:2380,swarm-2=http://10.100.193.202:2380,swarm-3=http://10.100.193.203:2380,swarm-4=http://10.100.193.204:2380,swarm-5=http://10.100.193.205:2380 --initial-cluster-state new >/var/log/etcd.log 2>&1 &
```
