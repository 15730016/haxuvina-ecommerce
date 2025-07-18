import 'dart:convert';

OtpSendResponse otpSendResponseFromJson(String str) =>
    OtpSendResponse.fromJson(json.decode(str));

class OtpSendResponse {
  OtpSendResponse({
    required this.result,
    required this.message,
  });

  bool result;
  String message;

  factory OtpSendResponse.fromJson(Map<String, dynamic> json) => OtpSendResponse(
    result: json["result"],
    message: json["message"],
  );
}
