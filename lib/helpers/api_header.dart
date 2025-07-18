import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/helpers/system_config.dart';
import 'shared_value_helper.dart';

enum HeaderType {
  json,
  multipart,
}

class ApiHeader {
  static Map<String, String> build({
    bool withAuth = false,
    HeaderType type = HeaderType.json,
    bool acceptAll = false,
    bool includeCurrency = false,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    const clientId = "flutter_app";

    final rawData = "$timestamp|$clientId";
    final hmac = Hmac(sha256, utf8.encode(AppConfig.system_key));
    final signature = hmac.convert(utf8.encode(rawData)).toString();

    final headers = <String, String>{
      "App-Language": app_language.$ ?? "vi",
      "System-Client": clientId,
      "System-Timestamp": timestamp,
      "System-Signature": signature,
      "Accept": acceptAll ? "*/*" : "application/json",
      "Content-Type": type == HeaderType.multipart
          ? "multipart/form-data; boundary=<calculated when request is sent>"
          : "application/json",
    };

    if (withAuth && access_token.$ != null && access_token.$!.isNotEmpty) {
      headers["Authorization"] = "Bearer ${access_token.$}";
    }

    if (includeCurrency && SystemConfig.systemCurrency != null) {
      final currency = SystemConfig.systemCurrency!;
      if (currency.code != null) {
        headers["Currency-Code"] = currency.code!;
      }
      if (currency.exchangeRate != null) {
        headers["Currency-Exchange-Rate"] = currency.exchangeRate.toString();
      }
    }

    return headers;
  }
}
