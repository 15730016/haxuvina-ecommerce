import 'dart:convert';

CommonResponse commonResponseFromJson(String str) =>
    CommonResponse.fromJson(json.decode(str));

String commonResponseToJson(CommonResponse data) => json.encode(data.toJson());

class CommonResponse {
  CommonResponse({
    this.result,
    this.message,
  });

  bool? result;
  dynamic message;

  factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
        result: json["result"],
        message: json["message"],
      );


  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
      };
}

class CommonDropDownItem {
  String? key;
  String? value;

  CommonDropDownItem(this.key, this.value);
}
