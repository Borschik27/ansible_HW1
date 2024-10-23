# ansible_HW1

1. Запуск тестового playbook
```
ansible-playbook -i playbook/inventory/test.yml playbook/site.yml

PLAY [Print os facts] **************************************************************************************

TASK [Gathering Facts] *************************************************************************************
ok: [localhost]

TASK [Print OS] ********************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ******************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

2. Изменение some_fact
```
sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base$ cat playbook/group_vars/all/examp.yml

  some_fact: 12

 ansible-playbook -i playbook/inventory/test.yml playbook/site.yml

PLAY [Print os facts] **************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
ok: [localhost]

TASK [Print OS] ********************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ******************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP *************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

3. Запуск prom и изменение some_fact
```
docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS     NAMES
f7236498eb34   centos7:latest   "sh -c 'sleep 1000'"     3 seconds ago    Up 3 seconds              centos7
ccf776515c68   ubuntu:latest    "bash -c 'sleep 1000'"   10 minutes ago   Up 10 minutes             ubuntu

sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook/answer$ ansible-playbook -i inventory/prod.yml site.yml
ERROR! the playbook: site.yml could not be found
sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook/answer$ cd ..
sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] **************************************************************************************

TASK [Gathering Facts] *************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ********************************************************************************************
ok: [centos7] => {
    "msg": "Alpine"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ******************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP *************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] **************************************************************************************

TASK [Gathering Facts] *************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ********************************************************************************************
ok: [centos7] => {
    "msg": "Alpine"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ******************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

7. Шифрование group_vars
```
sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook$ ansible-vault encrypt group_vars/deb/examp.yml --vault-password-file <(echo "netology")
Encryption successful
sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook$ ansible-vault encrypt group_vars/el/examp.yml --vault-password-file <(echo "netology")
Encryption successful

sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml --vault-password-file <(echo "netology")

PLAY [Print os facts] **************************************************************************************

TASK [Gathering Facts] *************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ********************************************************************************************
ok: [centos7] => {
    "msg": "Alpine"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ******************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP *************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

9. Ansible-doc
```
sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook$ ansible-doc -t connection -l
ansible.builtin.local          execute on controller
ansible.builtin.paramiko_ssh   Run tasks via python ssh (paramiko)
ansible.builtin.psrp           Run tasks over Microsoft PowerShell Remoting Protocol
ansible.builtin.ssh            connect via SSH client binary
ansible.builtin.winrm          Run tasks over Microsoft's WinRM
ansible.netcommon.grpc         Provides a persistent connection using the gRPC protocol
ansible.netcommon.httpapi      Use httpapi to run command on network appliances
ansible.netcommon.libssh       Run tasks using libssh for ssh connection
ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol
ansible.netcommon.network_cli  Use network_cli to run command on network appliances
ansible.netcommon.persistent   Use a persistent unix socket for connection
community.aws.aws_ssm          connect to EC2 instances via AWS Systems Manager
community.docker.docker        Run tasks in docker containers
community.docker.docker_api    Run tasks in docker containers
community.docker.nsenter       execute on host running controller container
community.general.chroot       Interact with local chroot
community.general.funcd        Use funcd to connect to target
community.general.iocage       Run tasks in iocage jails
community.general.jail         Run tasks in jails
community.general.lxc          Run tasks in lxc containers via lxc python library
community.general.lxd          Run tasks in lxc containers via lxc CLI
community.general.qubes        Interact with an existing QubesOS AppVM
community.general.saltstack    Allow ansible to piggyback on salt minions
community.general.zone         Run tasks in a zone instance
community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt
community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines
community.okd.oc               Execute tasks in pods running on OpenShift
community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools
containers.podman.buildah      Interact with an existing buildah container
containers.podman.podman       Interact with an existing podman container
kubernetes.core.kubectl        Execute tasks in pods running on Kubernetes
```


Задача 2
Расшифровываем group_vars
```
sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook$ ansible-vault decrypt group_vars/deb/examp.yml --vault-password-file <(echo "netology")
Decryption successful

sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook$ ansible-vault decrypt group_vars/el/examp.yml --vault-password-file <(echo "netology")
Decryption successful
```


Шифруем значение PaSSw0rd меняем some_fact и запускаем playbook:

```
sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook$ ansible-vault encrypt_string 'PaSSw0rd' --name 'some_fact'
New Vault password:
Confirm New Vault password:
Encryption successful
some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          63353235316434333935616636393530636138363737346335366532663063663932333237643638
          3530613836643037656665643864386664396132643663620a616336643164376530353266366261
          33363363663533313061376535656435393434653737376463663538663237616534643439366335
          6361306363636130380a616539653862353864613333623463613833613363653139643234343361
          3836

    
    Поменяли значение в group_vars и запустили playbook
sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook$ ansible-playbook -i inventory/test.yml site.yml --ask-vault-pass

PLAY [Print os facts] *****************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [localhost]

TASK [Print OS] ***********************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *********************************************************************************************************************
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP ****************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Создание скрипта bash-скрипта для запуска и остановки контейнера
```
sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook$ /bin/bash ansible_start.sh
20baf5cdcb0ce5988774fadeac4cc2e32347b8f6273be28d13cf069f9f675a30
4b7c478ac9471f119f3c1306db8b3fb3c7e8da408bb249381f06619886133474

PLAY [Print os facts] *****************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [ubuntu]
[WARNING]: Platform linux on host centos7 is using the discovered Python interpreter at /usr/bin/python3, but future installation of
another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-
core/2.15/reference_appendices/interpreter_discovery.html for more information.
ok: [centos7]

TASK [Print OS] ***********************************************************************************************************************
ok: [centos7] => {
    "msg": "Alpine"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *********************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ****************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ubuntu
centos7
ubuntu
centos7
sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
sypchik@Mirror:/mnt/c/Users/Sypchik/Desktop/home work/ansible/mnt-homeworks/08-ansible-01-base/playbook$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
