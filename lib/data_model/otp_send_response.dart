import 'dart:convert';

OtpSendResponse otpSendResponseFromJson(String str) =>
    OtpSendResponse.fromJson(json.decode(str));

class OtpSendResponse {
  bool result;
  String message;
  int? userId;
  bool success;

  OtpSendResponse({
    required this.result,
    required this.message,
    this.userId,
    required this.success,
  });

  factory OtpSendResponse.fromJson(Map<String, dynamic> json) => OtpSendResponse(
    result: json["result"] ?? false,
    message: json["message"] ?? "",
    userId: json["user_id"],
    success: json["success"] ?? false,
  );
}
