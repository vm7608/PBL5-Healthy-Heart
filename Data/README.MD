# **Dataset**

## **Thông tin dữ liệu**

- Nguồn dữ liệu tín hiệu ECG được lấy từ cơ sở dữ liệu MIT-BIH Arrhythmia Database, được đo từ 45 bệnh nhân, bao gồm 19 nữ (23 - 89 tuổi) và 26 nam (32 - 89 tuổi) ở tần số 360Hz.
- Liên kết đến bộ dữ liệu: [link](https://www.physionet.org/content/mitdb/1.0.0/)
- Dữ liệu bao gồm 48 records, mỗi record dài khoảng 30 phút.
- Dataset có tổng cộng 19 lớp. Nhóm tiến hành lấy ra 6 lớp để sử dụng, cụ thể như sau:
  - NOR: Normal - Nhịp xoang bình thường
  - PVC: Premature Ventricular Contraction - Nhịp tâm thất bất thường xuất phát từ tâm thất.
  - APB: Atrial Premature Beat - Nhịp xoang bất thường xuất phát từ tâm nhĩ.
  - LBB: Left Bundle Branch Block - Rối loạn dẫn truyền do khối nhánh trái bị ngăn cản.
  - RBB: Right Bundle Branch Block - Rối loạn dẫn truyền do khối nhánh phải bị ngăn cản.
  - PAB: Paced Beat - Nhịp tim được tạo bởi máy phát nhịp điện cắm trong cơ thể.
  - Trong đó, lấy ra các record '100', '101', '103', '106', '107', '118', '109', '209' để làm dữ liệu kiểm thử mô hình.

## **Xử lý dữ liệu**

- Dữ liệu huấn luyện:

|Bộ dữ liệu|Số mẫu trong một ảnh|Tần số lấy mẫu (Hz)|Thời gian của một ảnh (s)|
|:---:|:---:|:---:|:---:|
Dataset 1 | 128| 360| ~ 0.36
Dataset 2| 24| 33| ~ 0.72

- Bộ dữ liệu kiểm thử:

Bộ dữ liệu kiểm thử| Cách cắt| Số mẫu|Tần số lấy mẫu (Hz)|Thời gian của một ảnh (s)|
:---:|:---:|:---:|:---:|:---:|
Test set 1.1| Dùng đỉnh được đánh dấu | 128| 360| ~ 0.36
Test set 1.2| Dùng thuật toán tìm đỉnh |128 |360 | ~ 0.36
Test set 2.1| Dùng đỉnh được đánh dấu | 24 | 33 | ~ 0.72
Test set 2.2| Dùng thuật toán tìm đỉnh | 24 | 33 | ~ 0.72

- Thông tin chi tiết về dữ liệu, phương pháp xử lý dữ liệu, cách cắt dữ liệu, cách tạo dữ liệu kiểm thử, ... được trình bày trong Report đính kèm.
