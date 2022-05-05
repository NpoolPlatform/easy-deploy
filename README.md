# Easy deploy

* Prepare environment
```
* source config/environment
```
* Prepare groun_vars
```
* ansible-playbook playbooks/prepare/prepare.yml -i inventories/filecoin/plugin/staging
* ansible-playbook playbooks/prepare/prepare.yml
```
* Run playbook
```
* ansible-playbook playbooks/filecoin/plugin-chain.yml -i inventories/filecoin/plugin/staging
```

# Filecoin role graph

## Plugin example

```
[filecoin-chain]
172.19.16.110 ansible_ssh_user=test ansible_ssh_pass=12345679 ansible_sudo_pass=12345679

[filecoin:children]
filecoin-chain
```

```
ansible-inventory -i inventories/filecoin/plugin/staging/ --graph
@all:
|--@filecoin:
|  |--@filecoin-chain:
|  |  |--172.19.16.110
|--@ungrouped:
```

# 2K cluster example

```
[filecoin-chain]
172.19.16.110 ansible_ssh_user=test ansible_ssh_pass=12345679 ansible_sudo_pass=12345679

[filecoin-2k:children]
filecoin-chain

[filecoin:children]
filecoin-2k
```

```
ansible-inventory -i inventories/filecoin/plugin/2k/ --graph
@all:
|--@filecoin:
|  |--@filecoin-2k:
|  |  |--@filecoin-chain:
|  |  |  |--172.19.16.110
|--@ungrouped:
```

## group_vars与host_vars

```
默认变量全部定义与group_vars。特定主机将在运行时生成特定于主机的变量，存放在host_vars,路径未 host_vars/主机IP.
```
