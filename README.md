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

# Install community module

```
ansible-galaxy collection install community.general
```

# Install posix module

```
ansible-galaxy collection install ansible.posix
```

# Install community.docker

```
ansible-galaxy collection install community.docker
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

## 2K cluster example

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

# group_vars与host_vars

```
默认变量全部定义于group_vars。特定主机将在运行时生成特定于主机的变量，
存放在host_vars,路径未 host_vars/主机IP.
```

# Commands

* 生成主机NVME列表
```
ansible-playbook playbooks/collector/nvme.yml -i inventories/filecoin/plugin/staging
```
* 为主机NVME创建分区并挂载倒指定目录
```
ansible-playbook playbooks/setup/nvmesetup.yml -i inventories/filecoin/plugin/staging
```

# 部署filecoin plugin钱包

```
创建NVME list
ansible-playbook playbooks/collector/nvme.yml -i inventories/filecoin/plugin/staging
卸载所有NVME分区
ansible-playbook playbooks/helper/nvmeumount.yml -i inventories/filecoin/plugin/staging
修改NVME host_vars列表，将待用盘的mount参数修改为chain挂载点，其中，chain挂载点已经定义为chain_mountpoint
路径：inventory文件同级目录下，host_vars中的主机IP路径下的nvmes文件
创建分区（如果需要）并挂载
ansible-playbook playbooks/setup/nvmesetup.yml -i inventories/filecoin/plugin/staging
部署filecoin官方钱包程序
ansible-playbook playbooks/filecoin/plugin-chain.yml -i inventories/filecoin/plugin/staging
```

# 部署bitcoin plugin钱包

```
购买云主机，分配存储
登录云主机
如果存储已经有数据并且已经格式化并且有数据，将所分配存储挂载到/opt/chain
如果存储为新硬盘
cd inventories; git clone https://github.com/NpoolHosts/procyon.git; cd -
ansible-playbook playbooks/prepare/prepare.yml -i inventories/bitcoin/plugin/production
创建vdisk list
ansible-playbook playbooks/collector/vdisk.yml -i inventories/bitcoin/plugin/production
卸载所有vdisk分区
ansible-playbook playbooks/helper/vdiskumount.yml -i inventories/filecoin/plugin/production
修改vdisk host_vars列表，将待用盘的mount参数修改为chain挂载点，其中，chain挂载点已经定义为chain_mountpoint
路径：inventory文件同级目录下，host_vars中的主机IP路径下的vdisks文件
创建分区（如果需要）并挂载
ansible-playbook playbooks/setup/vdisksetup.yml -i inventories/bitcoin/plugin/production
部署bitcoin官方钱包程序
ansible-playbook playbooks/bitcoin/chain.yml -i inventories/bitcoin/plugin/production
```

# 部署procyon钱包预计plugin

```
ansible-playbook playbooks/procyon/wallet.yml -i inventories/procyon/plugin/production
```
