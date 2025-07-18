// To parse this JSON data, do
//
//     final shippingCostResponse = shippingCostResponseFromJson(jsonString);

import 'dart:convert';

ShippingCostResponse shippingCostResponseFromJson(String str) =>
    ShippingCostResponse.fromJson(json.decode(str));

String shippingCostResponseToJson(ShippingCostResponse data) =>
    json.encode(data.toJson());

class ShippingCostResponse {
  ShippingCostResponse({
    this.result,
    this.shipping_type,
    this.value,
    this.value_string,
  });

  bool? result;
  String? shipping_type;
  var value;
  String? value_string;

  factory ShippingCostResponse.fromJson(Map<String, dynamic> json) =>
      ShippingCostResponse(
        result: json["result"] ?? false,
        shipping_type: json["shipping_type"] ?? "",
        value: (() {
          final raw = json["value"];
          if (raw == null) {
            print("⚠️ 'value' là null");
            return 0.0;
          }
          final parsed = double.tryParse(raw.toString());
          if (parsed == null) {
            print("⚠️ Không thể chuyển đổi 'value' sang double: $raw");
          }
          return parsed ?? 0.0;
        })(),
        value_string: json["value_string"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "shipping_type": shipping_type,
        "value": value,
        "value_string": value_string,
      };
}
