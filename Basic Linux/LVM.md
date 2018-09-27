## 1. Review
### 1.1. LVM l
- Logical Volume Manager (LVM): là phương pháp cho phép ấn định không gian đĩa cứng thành những logical Volume khiến cho việc thay đổi kích thước trở nên dễ dàng hơn (so với partition). Với kỹ thuật Logical Volume Manager (LVM) bạn có thể thay đổi kích thước mà không cần phải sửa lại table của OS. Điều này thật hữu ich với những trường hợp bạn đã sử dụng hết phần bộ nhớ còn trống của partition và muốn mở rộng dung lượng của nó

### 1.2. Vai trò của LVM
- LVM là kỹ thuật quản lý việc thay đổi kích thước lưu trữ của ổ cứng
- Không để hệ thống bị gián đoạn hoạt động
- Không làm hỏng dịch vụ
- Có thể kết hợp Hot Swapping (thao tác thay thế nóng các thành phần bên trong máy tính)
## 2. Thành phần và cấu trúc
### 2.1  Các thành phần trong LVM

* Physical Volume : có thể là một ổ cứng, hoặc partion trong đó ( /dev/sda, /dev/sdc1 ) 
* Volume Group : tập hợp các physical Volume. Có có thể xem Volume Group như 1 ổ đĩa ảo
* Logical Volume : có thể xem như là các “phân vùng ảo” trên “ổ đĩa ảo” bạn có thể thêm vào, gỡ bỏ và thay đổi kích thước một cách nhanh chóng.
  
### 2.1  Cấu trúc trong LVM
Partitions là các phân vùng của Hard drives, mỗi Hard drives chia được nhiều partition, trong đó partition bao gồm 2 loại là primary partition và extended partition
* Primary partition: là phân vùng chính, có thể khởi động, mỗi đĩa cứng có thể có tối đa 4 phân vùng này

* Extended partition: Phân vùng mở rộng, có thể tạo ra những vùng luân lý

Physical Volume: Là một cách gọi khác của partition trong kỹ thuật LVM, nó là những thành phần cơ bản được sử dụng bởi LVM. Một Physical Volume không thể mở rộng ra ngoài phạm vi một ổ đĩa.

Logical Volume Group: Nhiều Physical Volume trên những ổ đĩa khác nhau được kết hợp lại thành một Logical Volume Group, với LVM Logical Volume Group được xem như một ổ đĩa ảo.

Logical Volumes: Logical Volume Group được chia nhỏ thành nhiều Logical Volume, mỗi Logical Volume có ý nghĩa tương tự như partition. Nó được dùng cho các mount point và được format với những định dạng khác nhau như ext2, ext3 … Khi dung lượng của Logical Volume được sử dụng hết ta có thể đưa thêm ổ đĩa mới bổ sung cho Logical Volume Group và do đó tăng được dung lượng của Logical Volume.

Physical Extent: là một đại lượng thể hiện một khối dữ liệu dùng làm đơn vị tính dung lượng của Logical Volume

## 3. Ưu nhược điểm của LVM
