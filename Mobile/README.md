# Giới thiệu về ứng dụng
Ứng dụng di động này được xây dựng để thực hiện quản lý và điều khiển thiết bị phần cứng từ xa trong đồ án PBL5, đề tài "Hệ thống giám sát nhịp tim và cảnh báo cho người dùng tín hiệu bất thường".

Ứng dụng được xây dựng và phát triển dựa trên ngôn ngữ lập trình [Dart](https://dart.dev/), sử dụng framework [flutter](https://flutter.dev/).

Chức năng của hệ thống gồm có:
- Đăng ký.
- Đăng nhập.
- Lấy lại mật khẩu.
- Trang chủ.
- Đo điện tim và chuẩn đoán bệnh.
- Lưu lại các bản ghi.
- Xem lại lịch sử đo.

# Cách sử dụng

## Chức năng đăng ký:

Để có thể sử dụng ứng dụng di động, người dùng trước hết cần tạo một tài khoản. Các thông tin cần cung cấp bao gồm:
- Email cá nhân.
- Mật khẩu.
- Tên.
- Ngày tháng năm sinh.
- Giới tính (nam hoặc nữ).

Sau khi đã nhận đầy đủ thông tin, tiếp theo bấm vào nút "Sign up". Hệ thống sẽ gửi email xác thực. Vui lòng kiểm tra và xác thực theo hướng dẫn được viết trên email.
Sau khi đã xác thực email, người dùng có thể đăng nhập và sử dụng các chức năng chính của ứng dụng.

## Chức năng đăng nhập:

Chức năng đăng nhập dùng để đăng nhập vào tài khoản mà người dùng đã đăng ký. Người dùng cần nhập email và mật khẩu đã được dùng để đăng ký và bấm vào nút "Sign in".

Trong trường hợp quên mật khẩu, người dùng có thể sử dụng chức năng lấy lại mật khẩu.

## Chức năng lấy lại mật khẩu:

Khi người dùng quên mật khẩu, có thể thông qua email để đặt lại mật khẩu. Tất cả những gì cần làm là bấm vào nút "Forgot Password", hệ thống sẽ yêu cầu người dùng nhập email đã đăng ký. Link đặt lại mật khẩu sẽ được gửi qua email này. Trong trường hợp email không được gửi đến, vui lòng kiểm tra lại địa chỉ email hoặc chắc chắn rằng email nãy đã được sử dụng để đăng ký tài khoản.

<p align="center" >
<img width="200" src="https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile1.jpg?raw=true" alt="Dart diagram">
<!-- https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile1.jpg?raw=true -->
<img width="200" src="https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile2.jpg?raw=true" alt="Dart diagram">
<!-- https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile2.jpg?raw=true -->
<img width="200" src="https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile3.jpg?raw=true" alt="Dart diagram">
<!-- https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile3.jpg?raw=true -->
<p>

## Trang chủ

Trang chủ gồm các bài báo và một số thông tin giúp người dùng nâng cao hiểu biết về sức khoẻ tim mạch, cũng như một số cách bảo vệ tim mạch.
Người dùng có thể nhấn vào các tin tức để xem toàn bộ các thông tin hữu ích.

<p align="center" >
<img width="200" src="https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile4.jpg?raw=true" alt="Dart diagram">
<!-- https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile4.jpg?raw=true -->
<img width="200" src="https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile5.jpg?raw=true" alt="Dart diagram">
<!-- https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile5.jpg?raw=true -->
<p>

## Đo nhịp tim
Để đo nhịp tim, người dùng chuyển sang trang đo nhịp tim và bấm vào nút đo nhịp tim. Sau khi đo xong, kết quả sẽ được hiển thị cho người dùng bao gồm:
- Bản điện tâm đồ
- Kết quả chuẩn đoán
- Kết quả phân lớp
- Kết quả số BPM (nhịp tim trên phút)

Người dùng có thể lưu lại kết quả bằng cách nhấp vào nút "Save" và nhập tên cho bản ghi.
Hãy chắc chắn rằng thiết bị đo đã sẵn sàng.

Trong trường hợp xảy ra lỗi, vui lòng xử lý như sau:
- Lỗi "The device doesn't work. Please check it and try later": Thiết bị phần cứng không hoạt động hoặc không thể kết nối mạng. Vui lòng kiểm tra lại thiết bị và thử lại sau.
- Lỗi "Something is wrong. Check your device and API": Bản ghi không tốt do nhiễu. Có rất nhiều yếu tố dẫn đến nhiễu như nguồn điện không ổn định, tư thế đo không thích hợp, cảm biến đặt trong môi trường có nhiều nhiễu... Vui lòng thực hiện đúng quy trình đo khi sử dụng thiết bị phần cứng.
- Lỗi "API does not work": Không thể gọi API để xử lý kết quả. Có thể do ứng dụng di động và server không cùng một mạng LAN hoặc do server không hoạt động. Vui lòng kiểm tra lại hoạt động của server và API.

<p align="center" >
<img width="200" src="https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile7.jpg?raw=true" alt="Dart diagram">
<!-- https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile7.jpg?raw=true -->
<img width="200" src="https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile8.jpg?raw=true" alt="Dart diagram">
<!-- https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile8.jpg?raw=true -->
<p>

## Lịch sử đo

Người dùng có thể xem lại các bản ghi đã được lưu. Thông tin các bản ghi gồm:
- Thời gian lưu
- Bản điện tâm đồ
- Kết quả chuẩn đoán
- Kết quả phân lớp
- Kết quả số BPM (nhịp tim trên phút)

<p align="center" >
<img width="200" src="https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile9.jpg?raw=true" alt="Dart diagram">
<!-- https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile9.jpg?raw=true -->
<img width="200" src="https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile10.jpg?raw=true" alt="Dart diagram">
<!-- https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile10.jpg?raw=true -->
<p>

## Trang cá nhân

Trang cá nhân gồm các thông tin mà người dùng đã cung cấp trong quá trình đăng ký tài khoản. Các thông tin này là căn cứ để xét xem nhịp tim người đo có bất thường hay không.

<p align="center" >
<img width="200" src="https://github.com/vm7608/PBL5-Healthy-Heart/blob/main/Mobile/source/mobile6.jpg?raw=true" alt="Dart diagram">
<p>

## APK

Ứng dụng có thể được cài đặt thông qua file [release.apk](/Mobile/project/apk/app-release.apk)