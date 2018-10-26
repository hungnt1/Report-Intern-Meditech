

# Openstack networking - Neutron

## 1. Openstack networking - Neutron

- Trong Openstack, Networking Service cung cấp cho người dùng API cho người dùng có thể cài đặt và định nghĩa các network. Code-name của Openstack Networking là neutron.
- Openstack networking service làm nhiệm vụ  tạo và quản lý hạ tầng mạng ảo,  bao gồm network, switch, subnet, router
- Openstack networking bao gồm : neutron-server, database storage, plug-in agent, cung cấp một số service khác để giao tiếp với Linux, external devices, or SDN controllers.
- Openstack là hoàn toàn độc lập và có triển khai trên 1 host đọc lập
- Openstack Networking tích hợp với một số copoment khác :
	- Openstack Indentify : để xác thực và ủy quyền cho các API Request
	- Openstack Compute : liên hệ với compute để gắn mỗi VNIC đến từng máy ảo riêng
	- Openstack dashboard : người dùng sử dụng để khởi tạo và quản lý các network

-  Openstack networking bao gồm các thành phần:

-   API server:  
    - OpenStack Networking API bao gồm hỗ trợ  **Layer 2 networking**  và  **IP address management (IPAM)**, cũng như 1 phần mở rộng cho  **Layer 3 router**  cho phép routing giữa các  **Layer 2 networking**. OpenStack Networking bao gồm 1 danh sách các plug-in cho phép tương tác với các công nghệ mạng mã nguồn mở khác nhau, bao gồm routers, virtual switches, và software-defined networking (SDN) controllers.
	-   OpenStack Networking plug-in và agents:  
    Plugs và unplugs ports, tạo network hoặc subnets, và cung cấp địa chỉ IP. Plug-in và agents được chọn khác nhau tùy thuộc và nhà cung cấp và công nghệ được sử dụng trong cloud cụ thể. Điều quan trọng cần đề cập là chỉ có thể sử dụng 1 plug-in trong 1 thời điểm.
	-   Messaging queue:  
    Cấp nhận và định tuyến các yêu cầu RPC giữa các agents để hoàn thành các hoạt động API. Message queue là được sử dụng trong  **Ml2 plug-in**  cho RPC giữa neutron server và neutron agents chạy trên mỗi hypervisor,  **ML2 mechanism drivers**  cho  **Open vSwitch**  và  **Linux bridge**.

- Network agent : xử lý các tác vụ khác nhau được sử dụng để triển khai mạng ảo. Các agent bao gồm : neutron-dhcp-agent, neutron-l3-agent, neutron-metering-agent, and neutron-lbaas-agent, among others 
# 2. Các loại network trong Openstack Networking

Trong Openstack có 2 loại network gồm : provider và self-service


## 2.1 : Provider Network

- Provider network cung cấp một network layer 2 tới các instance  với sự hỗ trợ của DHCP và metadata. Nhưng mạng này kết nối hoặc map  tới một network layer 2 có trong datacenter., thường kết hợp với 802.1Q ( VLAN ) 
- Provider network thường cung cấp sự đơn giản, hiệu năng và độ tin cậy. Chỉ có admin mới có thể quản lý các mạng này vì nó yêu cầu cấu hình hạng tầng mạng vật lý. Provider network chỉ có thể xử lý các frame layer-2 cho các kết nối đến instance, , do đó thiếu chức răng định tuyến và IP floating
- Nói chung, các thành phần trong Openstack Networking có thể xử lý các hoạt động layer-3 tác động đến hiệu năng và độ tin tưởng, provider network giúp chuyển các hoạt động layer-3 sang hạ tầng mạng vật lý
- Bao gồm 2 kiểu mạng : VXLAN or VLAN
## 2.2. Self-service network ( tenant )

- Self-service network cho phép các project quản lý các mạng mà không cần quyền admin. Những mạng này hoàn toàn là mạng ảo và yêu cầu một mạng ảo ,sau đó tương tác với provider network và mạng ngoài ( internet ). Self-service thường sử dụng DHCP và meta cho các instance
- Mong nhiều trường hợp, self-service network sử dụng overload protocol bằng VXLAN, GRE vì chúng có thể hỗ trợ nhiều mạng hơn layer-2 khi sử dụng VLAN ( 802.1q) 
- IPv4 trong self-service thường sử dụng IP Private  ( RFC 1918 )  và tương tác với provider network bằng Source NAT sử dụng router ảo. Floating IP address cho phép truy cập instance từ provider network bằng Destination NAT sử dụng Router ảo 
- IPv6 trong self-service sử dụng IP Public và tương tác với provider network sử dụng các static route thông qua các Router ảo
- Trong openstack networking tích hợp một router layer-3 thường nằm ít nhất trên một node network. Trái ngược với provider network kết nối tới các instance thông qua hạ tầng mạng vật lý layer-2
- Người dùng có thể tạo các selt-network theo từng project.  Bởi vậy các kết nối sẽ không được chia sẻ với  các project khác. 

Trong Openstack hỗ trợ các kiểu cô lập và overplay sau :
- Flat : tất cả instance kết nối vào một network chung. Không được tag VLAN_ID vào packet hoặc phân chia vùng mạng 
- VLAN :  cho phép khởi tạo nhiều provider hoặc tenant network2 sử dụng VLAN (801.2q) , tương ứng với VLAN  đang có sẵn trên mạng vật lý. Điều này cho phép instance kết nối tới các thành phần khác trong mạng
- GRE and VXLAN : là mỗi giao thức đóng gói packet , cho phép tạo ra mạng overlay để tạo kết nối giữa các instance.  Một router ảo để kết nối từ tenant network ra external network.  Một router provider sử dụng để kết nối từ external network vào các instance trong tenant network sử dụng floating IP
- Hỗ trợ các kiểu mạng  Segmentation type (flat, VLAN, Geneve, VXLAN, GRE),  Segmentation ID (VLAN ID, tunnel ID)
![](https://docs.openstack.org/mitaka/networking-guide/_images/NetworkTypes.png)

## 2.3 . Một số khái niệm bổ sung 
- **Subnet** : mà một block có thể sử dụng cho host và các địa chỉ liên quan . Subnet được sử dụng để gắn các địa chỉ IP khi một port được khởi tạo
- **Subnet pool** : 
	- enduser có thể tạo các subnet và các địa chỉ IP hợp lý trong subnet đó. Tuy nhiên, mạng tenant nên được cấu hình các subnet trước mà tự gắn vào các port
	- Sử dụng **subnet pools** sẽ hạn chế những địa chỉ nào có thể sử dụng bằng cách yêu cầu mọi subnet phải nằm trong pool được xác định. Sử  dụng nhiều subnet pool trên một subnet
	- Ports : là một điểm kết nối để gắn vào một thiết bị, chẳng hạn từ một Virtual NIC đến một virtual network. Port cũng mô tả các cấu hình liên quan như MAC và IP sử dụng trên node đó
	![](https://aptira.com/wp-content/uploads/2016/03/2.png)
	- Router : cung cấp một thiết bị layer-3 giống như thiết bị định tuyến  sử dụng NAT giữa sefl-service và provider network hoặc giữa các sefl-service network trên nhiều project . Networking service sử dụng layer-3 agent để quản lý router thông qua namespace 
	- **Security Group** : 
		 -   **Security groups** cung cấp vùng lưu trữ cho _virtual firewall rules_ để kiểm soát lưu lượng truy cập ingress (inbound to instance) và egress (outbound from instance) mạng ở mức port. **Security groups** sử dụng default deny policy và chỉ chứa các rules đồng ý phép lưu lượng cụ thể. Firewall driver chuyển các _group rule_ đến cấu hình cùng cơ chế lọc gói tin như `iptables`. 
		 -  Mỗi project có chứa 1  `default`  security group mà cho phép tát cả lưu lượng egress và từ chối tất cả các lưu lượng ingress. Bạn có thể thay đổi rules trong  `default`  security group. Nó bạn launch instance mà không có security group chỉ định,  `default`  security group sẽ tự động được áp dụng cho instance đó. Tương tự, nếu bạn tạo 1 port mà không chỉ định security group,  `default`  security group tự động được áp cho port đó.
		- Mặc định khi một gói tin gửi đến không gồm trường IP nhưng default group sẽ ngăn chạn các bản tin ARP,
	- **DHCP** : 
		- quản lý các địa chỉ IP cho provider và sefl-service network . Networking service sử dụng manages  ``qdhcp``  namespaces và   ``dnsmasq``  service. 

# 3. Một 
