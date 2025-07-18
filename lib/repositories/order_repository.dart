import 'dart:convert';

import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/common_response.dart';
import 'package:haxuvina/data_model/order_detail_response.dart';
import 'package:haxuvina/data_model/order_item_response.dart';
import 'package:haxuvina/data_model/order_mini_response.dart';
import 'package:haxuvina/data_model/purchased_ditital_product_response.dart';
import 'package:haxuvina/helpers/main_helpers.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/middlewares/banned_user.dart';
import 'package:haxuvina/repositories/api-request.dart';

import 'package:haxuvina/data_model/reorder_response.dart';

class OrderRepository {
  Future<dynamic> getOrderList({
    int page = 1,
    String payment_status = "",
    String delivery_status = "",
    String search = "",
  }) async {
    String url = "${AppConfig.BASE_URL}/purchase-history"
        "?page=$page"
        "&payment_status=$payment_status"
        "&delivery_status=$delivery_status"
        "&search=$search";

    Map<String, String> header = commonHeader;

    header.addAll(authHeader);
    header.addAll(currencyHeader);

    final response = await ApiRequest.get(
        url: url, headers: header, middleware: BannedUser());

    return orderMiniResponseFromJson(response.body);
  }

  Future<List<String>> fetchSuggestions(String query) async {
    String url = "${AppConfig.BASE_URL}/order-suggestions?query=$query";

    Map<String, String> header = commonHeader;
    header.addAll(authHeader);
    header.addAll(currencyHeader);

    final response = await ApiRequest.get(
      url: url,
      headers: header,
      middleware: BannedUser(), // giống getOrderList
    );

    final body = jsonDecode(response.body);
    if (body is List) {
      return List<String>.from(body);
    }
    return [];
  }

  Future<dynamic> getOrderDetails({int? id = 0}) async {
    String url =
        ("${AppConfig.BASE_URL}/purchase-history-details/" + id.toString());

    Map<String, String> header = commonHeader;

    header.addAll(authHeader);
    header.addAll(currencyHeader);

    final response = await ApiRequest.get(
        url: url, headers: header, middleware: BannedUser());
    return orderDetailResponseFromJson(response.body);
  }

  Future<ReOrderResponse> reOrder({int? id = 0}) async {
    String url = ("${AppConfig.BASE_URL}/re-order/$id");

    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    return reOrderResponseFromJson(response.body);
  }

  Future<CommonResponse> cancelOrder({int? id = 0}) async {
    String url = "${AppConfig.BASE_URL}/order/cancel/$id";

    final response = await ApiRequest.get(
        url: url,
        headers: {
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    return commonResponseFromJson(response.body);
  }

  Future<dynamic> getOrderItems({int? id = 0}) async {
    String url =
        ("${AppConfig.BASE_URL}/purchase-history-items/" + id.toString());
    Map<String, String> header = commonHeader;

    header.addAll(authHeader);
    header.addAll(currencyHeader);

    final response = await ApiRequest.get(
        url: url, headers: header, middleware: BannedUser());

    return orderItemResponseFromJson(response.body);
  }
}
