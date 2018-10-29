
## Packstack - Openstack

# 1. Giới thiệu Packstack
Packstack là một bộ command-line sử dụng Puppet ([http://www.puppetlabs.com/](http://www.puppetlabs.com/)) module để triển khai nhanh Openstack thông qua kết nối SSH.  Packstack rất thích hợp triển khai cho cả single node và multi node. 
Hiện tại Packstack chỉ hỗ trợ `Centos` và `Redhat Enterprise Linux [RHEL]`	. Ưu điểm lớn nhất của Packstack là triển khai hạ tầng nhanh chóng , sử dụng để demo , phát triển chức năng, nhưng ưu điểm của packstack là trong suốt với người dùng, việc triển khai hoàn toàn tự động.


# 2. Triển khai Packstack

## 2.1 . Mô hình, phân bổ IP, môi trường triển khai
![](https://i.imgur.com/Y6sB9zP.png)

Môi trường
- OS : Centos 7.5
- Version : Openstack Queens 

## 2.2 . Yêu cầu phần cứng tối thiểu

- Controller Node 
	-  2GB RAM 
	- 50GB disk avaliable
	- 2 NIC

- Compute Node
	- Kiểm tra extension ảo hóa
	`grep -E 'svm|vmx' /proc/cpuinfo | grep nx`
	Nếu có ouput thì server đã hỗ trợ ảo hóa
	- 2GB RAM
	- 50GB Disk avaliable
	- 2 NIC


## 2.3 . Cấu hình bước đầu cho Compute node

- Login vào Controller Node , thực hiện lệnh sau dưới root account
- Thiết lập hostname , IP trên tất cả Node
```bash
#!/bin/bash -ex

controller_name="controller"

host1_name="host1"

host2_name="hosts2"

controller=("ens192"  "ens224"  "192.168.30.130"  "192.168.30.1"  "192.168.69.130")

host1=("ens192"  "ens224"  "192.168.30.131"  "192.168.30.1"  "192.168.69.131")

host2=("ens192"  "ens224"  "192.168.30.132"  "192.168.30.1"  "192.168.69.132")

echo  "${controller[0]}"

function  set_controller(){

echo  " ${controller[0]} "

nmcli d modify ${controller[0]} ipv4.address ${controller[2]}

nmcli d modify ${controller[0]} ipv4.gateway ${controller[3]}

nmcli d modify ${controller[0]} ipv4.dns 1.1.1.1

nmcli d modify ${controller[0]} ipv4.method manual

nmcli d modify ${controller[0]} down

nmcli d modify ${controller[0]} up

nmcli d modify ${controller[0]} connection.autoconnect yes

echo  "Setup IP Management Card"

nmcli d modify ${controller[1]} ipv4.address ${controller[4]}

nmcli d modify ${controller[1]} ipv4.method manual

nmcli d modify ${controller[1]} down

nmcli d modify ${controller[1]} connection.autoconnect yes

echo  "Done Set IP controller"

}

function  set_host1 {

echo  "Setup IP External Card ${host1_name}"

ip link set  ${host1[1]} up

nmcli d modify ${host1[0]} ipv4.address ${host1[2]}/24

nmcli d modify ${host1[0]} ipv4.gateway ${host1[3]}

nmcli d modify ${host1[0]} ipv4.dns 1.1.1.1

nmcli d modify ${host1[0]} ipv4.method manual

nmcli d modify ${host1[0]} connection.autoconnect yes

echo  "Setup IP Management Card ${host1_name} "

ip link set  ${host1[1]} up

nmcli d modify ${host1[1]} ipv4.address ${host1[4]}/24

nmcli d modify ${host1[1]} ipv4.method manual

nmcli d modify ${host1[1]} connection.autoconnect yes

service network restart

}

function  set_host2 {

echo  "Setup IP External Card ${host2_name}"

ip link set  ${host2[0]} up

nmcli d modify ${host2[0]} ipv4.address ${host2[2]}/24

nmcli d modify ${host2[0]} ipv4.gateway ${host2[3]}

nmcli d modify ${host2[0]} ipv4.dns 1.1.1.1

nmcli d modify ${host2[0]} ipv4.method manual

nmcli d modify ${host2[0]} connection.autoconnect yes

echo  "Setup IP Management Card ${host2_name}"

ip link set  ${host2[0]} up

nmcli d modify ${host2[1]} ipv4.address ${host2[4]}/24

nmcli d modify ${host2[1]} ipv4.method manual

nmcli d modify ${host2[1]} connection.autoconnect yes

service network restart

}

echo  "------------- Connect To Host 1 ------------- "

ssh root@192.168.30.131 -t "$(typeset -f);\

host1_name="host1" ; host1=("ens192" "ens224" "192.168.30.131" "192.168.30.1" "192.168.69.131"); set_host1"

echo  "------------- Done ---------------------------"

echo  "------------- Connect To Host 2 ------------- "

ssh root@192.168.30.132 -t "$(typeset -f);\

host1_name="host1" ; host2=("ens192" "ens224" "192.168.30.132" "192.168.30.1" "192.168.69.132"); set_host2"

echo  "------------- Done ---------------------------"
```


### 2.4.  Cài đặt Packstack

Một số lưu ý khi cài đặt
- Sử dụng tài khoản, tài khoản root để thực hiện
- Thực hiện trên Controller Node
- Trong lúc thực hiện, sẽ yêu cầu password của các  Compute Node. 
- Lệnh sẽ tự động hoàn toàn

- Cài đặt packstack Queens
```bash
yum install -y centos-release-openstack-queens epel-release
yum install -y openstack-packstack python-pip
packstack --gen-answer-file=/root/queens-answer.txt
echo -e "
CONFIG_CONTROLLER_HOST=192.168.69.130
CONFIG_COMPUTE_HOSTS=192.168.69.131,192.168.69.132
CONFIG_PROVISION_DEMO=n
CONFIG_CEILOMETER_INSTALL=n
CONFIG_NTP_SERVERS=0.asia.pool.ntp.org
CONFIG_KEYSTONE_ADMIN_PW=123@123Aa"  >> /root/queens-answer.txt
packstack --answer-file 
```


