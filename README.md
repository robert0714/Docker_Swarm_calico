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
