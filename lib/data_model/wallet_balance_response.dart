// To parse this JSON data, do
//
//     final walletBalanceResponse = walletBalanceResponseFromJson(jsonString);
//https://app.quicktype.io/

import 'dart:convert';

WalletBalanceResponse walletBalanceResponseFromJson(String str) =>
    WalletBalanceResponse.fromJson(json.decode(str));

String walletBalanceResponseToJson(WalletBalanceResponse data) => json.encode(data.toJson());

class WalletBalanceResponse {
  bool result;
  String balance;
  String last_recharged;

  WalletBalanceResponse({
    required this.result,
    required this.balance,
    required this.last_recharged,
  });

  factory WalletBalanceResponse.fromJson(Map<String, dynamic> json) {
    return WalletBalanceResponse(
      result: json['result'] ?? false,
      balance: json['balance'] ?? "0",
      last_recharged: json['last_recharged'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "result": result,
    "balance": balance,
    "last_recharged": last_recharged,
  };
}
