// To parse this JSON data, do
//
//     final clubPointsToWalletResponse = clubPointsToWalletResponseFromJson(jsonString);

import 'dart:convert';

ClubPointToWalletResponse clubPointsToWalletResponseFromJson(String str) => ClubPointToWalletResponse.fromJson(json.decode(str));

String clubPointsToWalletResponseToJson(ClubPointToWalletResponse data) => json.encode(data.toJson());

class ClubPointToWalletResponse {
  ClubPointToWalletResponse({
    this.result,
    this.message,
  });

  bool? result;
  String? message;

  factory ClubPointToWalletResponse.fromJson(Map<String, dynamic> json) => ClubPointToWalletResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
