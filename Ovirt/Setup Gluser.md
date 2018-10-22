

# 1. Tìm hiểu cơ bản về GlusterFS

## 1.1 : GlusterFS là gì?
Khi các hệ thống lưu trữ ngày càng trở nên rộng lớn, thách thực được đặt ra là làm sao để nó vận hành được tối ưu và dễ dàng mở rộng thêm hơn nữa. Hãy tưởng tượng giờ ta có khoảng 10TB dung lượng lưu trữ trên một server storage, ở đó các các client kết nối vào, tất cả các hoạt động đọc ghi được thực hiện trên server lưu trữ này. Giả sử đến một thời điểm nào đó, tất cả các hoạt động đọc ghi trên server storage này đều đã quá tải, ta lại có một server tương tự đã chuẩn bị sẵn. Vậy cách nào để ghép thêm server storage mới này vào hoạt động cùng server storage cũ và chia sẻ tải I/O của nó. Đó là lúc ta cần đến GlusterFS.

Glusterfs thực hiện chính xác việc kết hợp nhiều server storage lại thành một khối storage lớn. Ưu điểm của glusterfs đó là:

- Glusterfs là một mã nguồn mở.

-  Glusterfs dễ dàng triển khai trên các server phần cứng thông dụng.

- Gluster tuyến tính hóa giữa dung lượng và hiệu suất, có nghĩa là nếu đã mở rộng dung lượng thì hiệu suất cũng sẽ tăng theo.

 - Glusterfs xử lý dễ dàng vài Petabyte, cung cấp truy nhập cho hàng ngàn server một lúc.


## 1.2: Các dạng Volume khác nhau trong hệ thống Gluserfs

### 1.2.1:  Distributed Volume
Với kỹ thuật này, các files (data) sẽ được phân tán, lưu trữ rời rạc (distributed) trong các bricks khác nhau . Ví dụ, bạn có 100 files: file1, file2, file3…, file100. Thì file1, file2 lưu ở brick1, file3,4lưu ở brick2, etc. Việc phân bố các files trên brick dựa vào thuật toán hash.
![](https://1hosting.com.vn/wp-content/uploads/2017/03/Glusterfs-Distributed-Volume.png)
- Ưu điểm: Mở rộng được dung lượng lưu trữ nhanh chóng và dễ dàng, tổng dung lượng lưu trữ của volume bằng tổng dung lượng của các brick.

- Nhược điểm: Khi một trong các brick bị ngắt kết nối, hoặc bị lỗi thì dữ liệu sẽ bị mất hoặc không truy vấn được.
### 1.2.2. Replicated Volume

Với kỹ thuật này, dữ liệu sẽ được copy sang các bricks trong cùng một volume, được hiểu tương tự như RAID 1
![](https://1hosting.com.vn/wp-content/uploads/2017/03/Glusterfs-Replicated-Volume.png)

### 1.2.3: Striped Volume
Với kỹ thuật này, dữ liệu được chia nhỏ thành những phần khác nhau và lưu trữ ở những brick khác nhau trong volume. Kỹ thuật này tương tự RAID 0.

![](https://1hosting.com.vn/wp-content/uploads/2017/03/Glusterfs-Striped-Volume.png)
Ưu điểm: Phù hợp với việc lưu trữ mà dữ liệu cần truy xuất với hiệu năng cao, đặc biệt là truy cập vào những tệp tin lớn.

Nhược điểm: Khi một trong những brick trong volume bị lỗi, thì volume đó không thể hoạt động được

### 1.2.4: Distributed Replicated Volume

Kỹ thuật này là sự kết hợp giữa kỹ thuật 1 (Distributed Volume) và kỹ thuật 2 (Replicated Volume). Các file sẽ được phân tán tên các Brick ,đồng thời sẽ tạo 1 bản backup ở brick còn lại

![](https://1hosting.com.vn/wp-content/uploads/2017/03/Glusterfs-Distributed-Replicated-Volume.png)

- Ưu điểm là dữ liệu có tính sẵn sàng cao 
- Nhược điểm là khi 1 volume có lỗi thì dữ liệu sẽ bị ảnh hưởng.

### 1.2.5: Distributed Striped Volume
Kết hợp kỹ thuật 1 (Distributed Volume) và kỹ thuật 3 (Striped Volume). Các file được phân tán trên các Brick nằm ở các Volume khác nhau.

![](https://1hosting.com.vn/wp-content/uploads/2017/03/Glusterfs-Distributed-Striped-Volume.png)


# 2. Cài đặt GlusterFS trên Centos 7
Chuẩn bị 2 node để làm GluserFS Server
- Gluser 1 : 192.168.30.135
- Gluser 2 : 192.168.30.136

## 2.1 . Cài đặt GluserFS Server trên Node1 và Node2

- Kiểm tra ổ đĩa . Hiện tại đã có `dev/sda` để chứa OS, `dev/sda` để làm brick GluserFS
![](https://i.imgur.com/JxNcpBU.png)

- Cài đặt Gluster Server và bật service
	```
	yum install centos-release-gluster
	yum install -y glusterfs-server
	systemctl start glusterd
	systemctl status glusterd
	```

- Cấu hình FirewallD
	```
	firewall-cmd --add-service=glusterfs --permanent
	firewall-cmd --reload
	```


## 2.2 . Cấu hình Replication Volume

- Cấu hình probe trên node1 : 192.168.30.135
	```
	[root@gluster1 ~]# gluster peer probe 192.168.30.136
	peer probe: success. 
	[root@gluster1 ~]# gluster peer status
	Number of Peers: 1

	Hostname: 192.168.30.136
	Uuid: 3c4d691a-c97a-40da-8a10-3e4003066850
	State: Accepted peer request (Connected)
	```
-  Tạo partion và mount `dev/sda` theo trên cả node 1 và node 2 :
	```
	(echo n # Add a new partition
	echo p # Primary partition
	echo 1 # Partition number
	echo   # First sector (Accept default: 1)
	echo
	echo w ) | sudo fdisk /dev/sdb
	mkfs.ext3 /dev/sdb1
	mkdir -p /bricks/disk1
	mount /dev/sdb1 /bricks/
	```


- Chạy bash file trên node 1 kết nối
	```
	node1=192.168.30.135
	node2=192.168.30.136
	gluster volume create ovirt_vol replica 2 transport tcp $node1:/bricks/disk1 $node2:/bricks/disk1
	chown 36:36 /bricks/disk1
	echo $node1

	```

- Thông báo kết nối thành công
	```
	[root@gluster1 ~]# bash gluster.sh 
	peer probe: success. Host 192.168.30.136 port 24007 already in peer list
	Replica 2 volumes are prone to split-brain. Use Arbiter or Replica 3 to avoid this. See: 	http://docs.gluster.org/en/latest/Administrator%20Guide/Split%20brain%20and%20ways%20to%20deal%20with%20it/.
	Do you still want to continue?
	 (y/n) y
	volume create: ovrtvol: success: please start the volume to access data
	```

- Sau khi khởi tạo volume, Start Volume bằng `gluster volume start ovrtvol`
![](https://i.imgur.com/AmxEV99.png)

- Xem thông tin của Volume và brick
![](https://i.imgur.com/xm1CXKQ.png)


## 3. Thêm GluserFS Volume vào Ovirt Domain Storage

- Thêm GluseFS tại `Storage -> Domains -> New Domain`
![](https://i.imgur.com/zGvJmfW.png)

- Xem thông tin ổ Gluster
![](https://i.imgur.com/o0Tt283.png)
