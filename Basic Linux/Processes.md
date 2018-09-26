

# Quản lý các tiến trình 
Chương trình là một loạt các hướng dẫn cho máy tính biết phải làm gì. Khi chúng ta chạy một chương trình, các lệnh đó được sao chép vào bộ nhớ và không gian được cấp phát cho các biến và các thứ khác cần thiết để quản lý việc thực hiện nó. Ví dụ chạy chương trình này được gọi là một quá trình và đó là các quá trình mà chúng tôi quản lý.

Hệ điều hành sẽ theo dõi các tiến trình thông qua một ID có 5 chứ số mà được biết như là pid hay process ID.
Mỗi tiến trình có duy nhất một pid.

Tại cùng một lúc không thể có 2 tiến trình có cùng pid.

Khi bạn bắt đầu một tiến trình (đơn giản là chạy một lệnh), có 2 các để chạy nó:
* Foreground Process: Mặc định khi bắt đầu các tiến trình là Foreground, nhận input từ bàn phím và output tới màn hình. Trong khi chương trình chạy thì không thể chạy bất cứ tiến trình nào khác
* Background Process: chạy mà không kết nối với bàn phím của bạn. Lợi thế là khi đó đang chạy tiến trình background vẫn có thể chạy các tiến trình khác.

Command | Operation
-------- |-------
top | Liệt kê các process đang chạy theo thời gian thực
ps  | Liệt kê các process đang chạy
htop | Liệt kê các %CPU, %RAM các process đang chạy theo thời gian thực 
kill process_id | Đóng process đang chạy

1. Load average
  *  load average: x, x, x : cho thấy trung bình có bao nhiêu process mà server phải thực hiện  trong khoản thời gian 1 phút, 5 phút, 15 phút. 
```
cat /proc/loadavg   3.00 2.00 7.00   
```
Trong 1 phút gần đây có trung bình 3 process cần CPU xử lý
.Trung bình 5 process xử lý trong 5 phút gần đây, và 7 process cần xử lý trong 15 phút gần đây .
Ngưỡng loadavg của mỗi servrer khác nhau do có số lượng CPU khác nhau 
```

cat /sys/devices/system/cpu/online
0-1
```
Như vậy hiện tại server đang có 2 CPU . Với 2 CPU , sẽ có  ngưỡng loadavg <= 2.00\
Các yếu tối ảnh hưởng loadavg 
-   Cpu Utilazion
-   Disk I/O
-   Network Traffic
2.  ps - POSIX Programmer
*   ps -a : các process được thực hiện trên terminal
*   ps -A : các process đang chạy trên hệ thống bởi tất cả người dùng
*   ps -u : liệt kê các process đang chạy , và người dùng thực hiện
*   ps -U {user_name} : liệt kê các process của một người dùng
*   ps -elf : Hiển thị đầy đủ thông tin các process đang chạy  
3. kill
*	Kill làm nhiệm vụ gửi các SINGAL tới các process trên hệ thống. Kill xử lý các singal từ  0 đến 64
*	SIGNAL 9 : tín hiệu đóng
*	SIGNAL 17,19,23  : tín hiệu tiếp tục nếu đã gửi tín hiệu ngừn từ trước
*	SIGNAL 19,18,25 : tín hiệu ngừng
4. top\
![](https://image.ibb.co/kOVhWp/top.png)

4.1 : Các thông tin CPU 
* us : %CPU  của các process  người dùng  sử dụng 
* sy : %CPU  của các  process  hệ thống sử dụng ( root ) 
* ni  : %CPU  của các procces ưu tiên thấp đang sử dụng
* id : %CPU đang rảnh
* wa : %CPU đang ở hàng đợi ưu tiên chờ các tiến trình I/O khác xử lý xong
* hi : %CPU xử lý gián đoạn phần cứng
* si : %CPU xử lý gián đoạn phần mềm
* st : %CPU của các VM đang sử dụng

4.2 : Các thông tin tiến trình :
* PID : ID của tiến trình
* User : người dùng chạy tiến trình
* PR ( priority ) : mức độ ưu tiên của process , với -20 quan trọng nhất đến 19 là không quan trọng
* NI ( Nine Value ) : giá trị sửa đổi của PR
* VIRT ( vitual memory ) : %Memory ảo process đang sử dụng
* RES : %Memory thực ( vật lý ) process đang sử dụng
* S ( stutus ) : trạng thái của tiến trình
* CPU : %CPU do tiến trình sử dụng
* RAM : %RAM trên tổng RAM ( vật lý, swap ) đã dùng
* TIME + : thời gian tiến trình đã chạy
* COMMAD : tên tiến trình , đường dẫn khởi động tiến trình
