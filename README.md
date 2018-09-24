# Cài đặt và cấu hình Openstack Mitaka

### Mục tiêu
-Cài đặt Openstack Mitaka multi node trên ubuntu 16.04 bằng script
### Chuẩn bị môi trường
- Có thể sử dụng VMware Workstation hoặc Virtualbox ... 

### Mô hình mạng
- Hệ thống gồm 2 node: CONTROLLER & COMPUTE
```sh
10.10.10.0+-------------------------------------------------------------------------------------------------------+
+-----------------------------------+ +-------------------------------------+ +-----------------------------------+
                                    | |                                     | |
                                    | |                                     | |
                                    | |                                     | |
                       +------------+ +--------------+         +------------+ +-----------+
                       |                             |         |                          |
                       |    ens33: 10.10.10.110      |         |    ens33: 10.10.10.11    |
                       |                             |         |                          |
                       |                             |         |                          |
                       |        CONTROLLER           |         |         COMPUTE          |
                       |                             |         |                          |
                       |                             |         |                          |
                       |    ens38: 192.168.10.10     |         |  ens38: 192.168.10.11    |
                       |                             |         |                          |
                       |                             |         |                          |
                       +------------+ +--------------+         +------------+ +-----------+
                                    | |                                     | |
                                    | |                                     | |
 192.168.10.0+----------------------+ +-------------------------------------+ +-----------------------------------+
 +----------------------------------------------------------------------------------------------------------------+

```

#### Cấu hình CONTROLLER NODE
```sh
OS: Ubuntu Server 16.04 64 bit
RAM: 4GB
CPU: 1x1,  VT supported
NIC1: eth0: 10.10.10.0/24 (Dải mạng trong)
NIC2: eth1: 192.168.10.0/24 (Dải mạng ngoài)
HDD: +20GB
```


#### Cấu hình COMPUTE NODE
```sh
OS: Ubuntu Server 16.04 64 bit
RAM: 4GB
CPU: 1x2, VT supported
NIC1: eth0: 10.10.10.0/24 (Dải mạng trong)
NIC2: eth1: 172.16.69.0/24, (Dải mạng ngoài)
HDD: +100GB
```

### Cài đặt khoải tạo trên cả hai máy
- Cài đặt git từ repo và tải script về máy
```sh
su -
apt-get update
apt-get -y install git 

git clone https://github.com/vietstacker/OpenStack-Mitaka-Scripts.git
mv /root/OpenStack-Mitaka-Scripts/OPS-Mitaka-LB-Ubuntu/scripts/ /root/
rm -rf OpenStack-Mitaka-Scripts/
cd scripts/
chmod +x *.sh
```
-Chỉnh sửa lại IP và dải mạng tùy vào dải mạng đang sử dụng trong file config.cfg

## Cài đặt trên CONTROLLER NODE
### install IP establishment script and repos for mitaka
- Edit file `config.cfg` in dicrectory with IP that you want to use.
 
```sh
bash ctl-1-ipadd.sh
```

### Install NTP, MariaDB packages
```sh
bash ctl-2-prepare.sh
```

### Install KEYSTONE
- Install Keystone
```sh
bash ctl-3.keystone.sh
```

- Declare enviroment parameter
```sh
source admin-openrc
```

### Install GLANCE
```sh
bash ctl-4-glance.sh
```

### Install NOVA
```sh
bash ctl-5-nova.sh
```

### Install NEUTRON
```sh
bash ctl-6-neutron.sh
```
- Khởi động lại hệ thống.

### Install HORIZON
```sh
bash ctl-horizon.sh
```

## Cài đặt trên COMPUTE NODE
### Establish IP and hostname
```sh
bash com1-ipdd.sh
```
### Cài đặt Nova
```sh
su -
cd scripts/
bash com1-prepare.sh
```

## Sử dụng dashboard tiếp tục cài đặt các network, VM, rules.
Đăng nhập vào dashboard với tài khoản admin hoặc demo với mật khẩu Kma123
### Initialize network
#### Initialize external network range
#### Initialize internal network range
#### Initialize Router for project admin
## Initialize virtual machine (Instance ciros)
## Check virtual machine (Instance cirros)
Login vào máy cirros vừa tạo với tài khoản mặc đinh:
```sh
user: cirros
password: cubsin:)
```





