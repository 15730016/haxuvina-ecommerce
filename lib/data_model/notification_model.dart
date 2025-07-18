class NotificationModel {
  String? id;
  String? type;
  String? notificationText;
  String? image;
  String? dateTime;
  dynamic data; // nên có default null hoặc map rỗng
  bool? isChecked;

  NotificationModel({
    this.id,
    this.type,
    this.notificationText,
    this.image,
    this.dateTime,
    this.data,
    this.isChecked,
  });

  factory NotificationModel.localSuccessAccountCreated() {
    return NotificationModel(
      id: "local-success", // tránh null
      type: "App\\Notifications\\CustomNotification",
      notificationText: "Tài khoản đã được tạo thành công! Mật khẩu mặc định: 123456",
      dateTime: DateTime.now().toIso8601String(),
      image: "",
      data: {}, // tránh lỗi gọi `.data!.orderId`
      isChecked: false,
    );
  }
}
