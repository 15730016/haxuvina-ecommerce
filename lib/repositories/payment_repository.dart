import 'dart:convert';

import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/order_create_response.dart';
import 'package:haxuvina/data_model/payment_type_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/middlewares/banned_user.dart';
import 'package:haxuvina/repositories/api-request.dart';
import 'package:haxuvina/helpers/api_header.dart';

class PaymentRepository {
  Future<dynamic> getPaymentResponseList({mode = "", list = "both"}) async {
    String url =
        ("${AppConfig.BASE_URL}/payment-types?mode=${mode}&list=${list}");

    final response = await ApiRequest.get(
        url: url,
        headers: ApiHeader.build(),
        middleware: BannedUser());

    return paymentTypeResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponse(payment_method) async {
    var post_body = jsonEncode({"payment_type": "$payment_method"});

    String url = ("${AppConfig.BASE_URL}/order/store");
    final response = await ApiRequest.post(
        url: url,
        headers: ApiHeader.build(withAuth: true),
        body: post_body,
        middleware: BannedUser());

    return orderCreateResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponseFromWallet(
      payment_method, double? amount) async {
    String url = ("${AppConfig.BASE_URL}/payments/pay/wallet");

    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_method}",
      "amount": "${amount}"
    });

    final response = await ApiRequest.post(
        url: url,
        headers: ApiHeader.build(withAuth: true),
        body: post_body,
        middleware: BannedUser());

    return orderCreateResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponseFromCod(payment_method) async {
    var post_body = jsonEncode(
        {"user_id": "${user_id.$}", "payment_type": "${payment_method}"});

    String url = ("${AppConfig.BASE_URL}/payments/pay/cod");

    final response = await ApiRequest.post(
        url: url,
        headers: ApiHeader.build(withAuth: true),
        body: post_body,
        middleware: BannedUser());

    return orderCreateResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponseFromBank(
      String paymentMethod, {
        int? orderId,
        double? amount,
        String? paymentFor,
      }) async {
    final postBody = jsonEncode({
      "user_id": user_id.$,
      "payment_type": paymentMethod,
      if (orderId != null && orderId > 0) "order_id": orderId,
      if (amount != null && amount > 0) "amount": amount,
      if (paymentFor != null) "payment_for": paymentFor,
    });

    const url = "${AppConfig.BASE_URL}/payments/pay/bank";

    print("[Bank] 👉 Sending request to $url");
    print("[Bank] 📦 Request body: $postBody");

    try {
      final response = await ApiRequest.post(
        url: url,
        headers: ApiHeader.build(withAuth: true),
        body: postBody,
        middleware: BannedUser(),
      );

      print("[Bank] ✅ Response status: ${response.statusCode}");
      print("[Bank] 📩 Raw response: ${response.body}");

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 && json['result'] == true) {
        print("[Bank] 🎯 Parsed data:");
        print("    - Order ID: ${json['order_id']}");
        print("    - Amount: ${json['grand_total']}");
        print("    - Transfer Note: ${json['transfer_note']}");
        print("    - QR URL: ${json['viet_qr_url']}");
        return json;
      } else {
        print("[Bank] ❌ Failed with message: ${json['message']}");
        throw Exception(json['message'] ?? "Failed to initiate bank payment");
      }
    } catch (e) {
      print("[Bank] 🚨 Error: $e");
      rethrow;
    }
  }

  Future<dynamic> confirmBankTransfer({
    required int orderId,
    required String trxId,
    required int photoUploadId,
  }) async {
    const url = "${AppConfig.BASE_URL}/payments/pay/bank/confirm";

    final postBody = jsonEncode({
      "order_id": orderId,
      "trx_id": trxId,
      "photo": photoUploadId,
    });

    try {
      final response = await ApiRequest.post(
        url: url,
        headers: ApiHeader.build(withAuth: true),
        body: postBody,
      );

      final json = jsonDecode(response.body);
      return json;
    } catch (e) {
      print("Bank confirm error: $e");
      rethrow;
    }
  }

}
