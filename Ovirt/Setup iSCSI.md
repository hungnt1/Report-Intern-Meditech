ovirt
ovirt
## 3. Cấu hình Storage trên Ovirt
### 3.1 : Khởi tạo đĩa LVM trên Ovirt Host

![](https://i.imgur.com/XWDDE5Z.png)

## 3.2 : Cài  đặt iSCSI Target trên Ovirt Host

```
yum install targetcli -y
                    
```
- Truy cập `targetcli`
![](https://i.imgur.com/8oEkr5t.png)

- Khởi tạo một block storage
```
[root@localhost ~]# targetcli
targetcli shell version 2.1.fb46
Copyright 2011-2013 by Datera, Inc and others.
For help on commands, type 'help'.

/backstores/block> create iscsi_disk1_ovirt /dev/lvm_ovirt/lv_iscsi 
Created block storage object iscsi_disk1_ovirt using /dev/lvm_ovirt/lv_iscsi.
```
- Khởi tạo một iSCSI Target
```
/iscsi> create iqn.2018-10.com.meditech.server30:disk1
Created target iqn.2018-10.com.meditech.server30:disk1.
Created TPG 1.
Global pref auto_add_default_portal=true
Created default portal listening on all IPs (0.0.0.0), port 3260.
```
- Thêm LUN vào cho Target vừa tạo
```
/iscsi> cd iqn.2018-10.com.meditech.server30:disk1/tpg1/luns 
/iscsi> cd iqn.2018-10.com.meditech.server30:disk1/tpg1/luns 

````


- Khởi tạo ACL cho Target vừa tạo (  là IQN cho initiator kết nối đến) 
Ví dụ `host30` sẽ connect đến Target
Để tìm IQN của host30 
```
[bash] :cat /etc/iscsi/initiatorname.iscsi 
InitiatorName=iqn.1994-05.com.redhat:b9fe79c5f0bb
```
Tạo ACL cho IQN initiator
```
iscsi> cd iqn.2018-10.com.meditech.server30:disk1/tpg1/acls 
/iscsi/iqn.20...30:disk1/acls> create iqn.1994-05.com.redhat:b9fe79c5f0bb

```

- Khởi động lại dịch vụ
```
systemctl enable target.service
systemctl restart target.service
```
- Cấu hình Firewall
```
firewall-cmd --permanent --add-port=3260/tcp
firewall-cmd --reload
```

## 3.3 . Cấu hình Domain Storage trên Engine

- Cấu hình iSCSI cho Domain Storag tại `Storage -> Domain -> New Domain` cho host 30
![](https://i.imgur.com/EuCGu9p.png)

- Sau khi kết nối 
![](https://i.imgur.com/iHauHaC.png)
