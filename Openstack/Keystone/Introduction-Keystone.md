
## 1: Openstack Indentify ( Keystone ) 

## 1.1 : Khái niệm trong Keystone
  
- Keystone là OpenStack project cung cấp các dịch vụ Identity, Token, Catalog, Policy cho các project khác trong OpenStack. 
- Keystone có 2 phiển bản gồm

| V2  | V3  |
|---|---|
| sử dụng UUID  |  sử dụng PKI, mỗi mã thông báo đại diện cho một cặp khóa mở và đóng để xác minh chéo và xác thực.  | 

- Hai tính năng chính của Keystone:
	-   User Management: keystone xác thực tài khoản người dùng và chỉ định xem người dùng có quyền được làm gì.
	-   Service Catalog: Cung cấp một danh mục các dịch vụ sẵn sàng cùng với các API endpoints để truy cập các dịch vụ đó.


## 1.2 : Cấu trúc trong Keystone

**1.2.1. Project**

-   Khái niệm chỉ sự gom gộp, cô lập các nguồn tài nguyên (server, images, etc.)
-  Các user được gắn role và truy cập sử dụng tài nguyên trong project
-   -   role để quy định tài nguyên được phép truy cập trong project (khái niệm role assignment)

**1.2.2. Domain**
   -   Domain là tập hợp bao gồm các user, group, project
   -   Phân chia tài nguyên vào các "kho chứa" để sử dụng độc lập với các domain khác
   -   Mỗi domain có thể coi là sự phân chia về mặt logic giữa các tổ chức, doanh nghiệp trên cloud

**1.2.3. Users và User Groups**

-   User: người dùng sử dụng nguyên trong project, domain được phân bổ
-   Group: tập hợp các user , phân bổ tài nguyên
-   Role: các role gán cho user và user group trên các domain và project 

**1.2.4. Roles**

Khái niệm gắn liên với Authorization (ủy quyền), giới hạn các thao tác vận hành hệ thống và nguồn tài nguyên mà user được phép.  **Role được gán cho user và nó được gán cho user đó trên một project cụ thể. ("assigned to" user, "assigned on" project)**

**1.2.5. Token**

Token được sử dụng để xác thực tài khoản người dùng và ủy quyền cho người dùng khi truy cập tài nguyên (thực hiện các API call).  
Token bao gồm:
-   ID: định danh duy nhất của token trên DB
-   payload: là dữ liệu về người dùng (user được truy cập trên project nào, danh mục các dịch vụ sẵn sàng để truy cập cùng với endpoints truy cập các dịch vụ đó), thời gian khởi tạo, thời gian hết hạn, etc.

**1.2.6. Catalog**  

Là danh mục các dịch vụ để người dùng tìm kiếm và truy cập. Catalog chỉ ra các endpoints truy cập dịch vụ, loại dịch vụ mà người dùng truy cập cùng với tên tương ứng, etc. Từ đó người dùng có thể request khởi tạo VM và lưu trữ object.



![](https://camo.githubusercontent.com/8a5debcf7776f4c94a8c119510ab8f74b325be3c/687474703a2f2f312e62702e626c6f6773706f742e636f6d2f2d424c456c53354c487262492f5646634f774b714e3750492f41414141414141414150772f734f692d686a34474a2d512f73313630302f6b657973746f6e655f6261636b656e64732e706e67)


## 1.3 . Keystone WorkFlow

![](https://camo.githubusercontent.com/df9544d836ef42aec47fe777b7427680d7eb4453/687474703a2f2f692e696d6775722e636f6d2f566148594834382e706e67)
