import 'dart:convert';

import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/delivery_info_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/repositories/api-request.dart';

import '../helpers/api_header.dart';

class ShippingRepository {
  Future<DeliveryInfoResponse> getDeliveryInfo() async {
    String url = ("${AppConfig.BASE_URL}/delivery-info");

    var post_body;
    if (guest_checkout_status.$ && !is_logged_in.$) {
      post_body = jsonEncode({"temp_user_id": temp_user_id.$});
    } else {
      post_body = jsonEncode({"user_id": user_id.$});
    }

    final response = await ApiRequest.post(
      url: url,
      body: post_body,
      headers: ApiHeader.build(
        withAuth: true,
        type: HeaderType.json,
      ),
    );

    return deliveryInfoResponseFromJson(response.body);
  }

  Future<double> getShippingCost() async {
    String url = "${AppConfig.BASE_URL}/shipping_cost";
    var postBody;

    if (guest_checkout_status.$ && !is_logged_in.$) {
      postBody = jsonEncode({"temp_user_id": temp_user_id.$});
    } else {
      postBody = jsonEncode({"user_id": user_id.$});
    }

    final response = await ApiRequest.post(
      url: url,
      body: postBody,
      headers: ApiHeader.build(
        withAuth: true,
        type: HeaderType.json,
      ),
    );

    final data = json.decode(response.body);

    /// 🟢 Debug in dữ liệu trả về
    print("🔍 Shipping cost response: $data");

    if (data['result'] == true) {
      return double.tryParse(data['value'].toString()) ?? 0.0;
    } else {
      throw Exception(data['message'] ?? "Không thể lấy phí vận chuyển");
    }
  }

}
