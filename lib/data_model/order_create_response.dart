// To parse this JSON data, do
//
//     final orderCreateResponse = orderCreateResponseFromJson(jsonString);

import 'dart:convert';

OrderCreateResponse orderCreateResponseFromJson(String str) => OrderCreateResponse.fromJson(json.decode(str));

String orderCreateResponseToJson(OrderCreateResponse data) => json.encode(data.toJson());

class OrderCreateResponse {
  OrderCreateResponse({
    this.combined_order_id,
    this.result,
    this.message,
    this.order_id,
    this.grand_total,
    this.viet_qr_url,
    this.bank_name,
    this.branch_name,
    this.account_name,
    this.account_number,
    this.transfer_note,
  });

  int? combined_order_id;
  int? order_id;
  double? grand_total;
  bool? result;
  String? message;
  String? viet_qr_url;
  String? bank_name;
  String? branch_name;
  String? account_name;
  String? account_number;
  String? transfer_note;

  factory OrderCreateResponse.fromJson(Map<String, dynamic> json) => OrderCreateResponse(
    combined_order_id: json["combined_order_id"],
    order_id: json["order_id"],
    grand_total: (json["grand_total"] is int)
        ? (json["grand_total"] as int).toDouble()
        : json["grand_total"],
    result: json["result"],
    message: json["message"],
    viet_qr_url: json["viet_qr_url"],
    bank_name: json["bank_name"],
    branch_name: json["branch_name"],
    account_name: json["account_name"],
    account_number: json["account_number"],
    transfer_note: json["transfer_note"],
  );

  Map<String, dynamic> toJson() => {
    "combined_order_id": combined_order_id,
    "order_id": order_id,
    "grand_total": grand_total,
    "result": result,
    "message": message,
    "viet_qr_url": viet_qr_url,
    "bank_name": bank_name,
    "branch_name": branch_name,
    "account_name": account_name,
    "account_number": account_number,
    "transfer_note": transfer_note,
  };
}

