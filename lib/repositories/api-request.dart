import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:haxuvina/helpers/main_helpers.dart';
import 'package:haxuvina/middlewares/group_middleware.dart';
import 'package:haxuvina/middlewares/middleware.dart';
import 'package:haxuvina/repositories/aiz_api_response.dart';

class ApiRequest {
  /// gọi raw GET trả về http.Response đã qua middleware
  static Future<http.Response> get({
    required String url,
    Map<String, String>? headers,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    final uri = Uri.parse(url);
    final headerMap = {...commonHeader, ...currencyHeader};
    if (headers != null) headerMap.addAll(headers);

    final resp = await http.get(uri, headers: headerMap);
    return AIZApiResponse.check(
      resp,
      middleware: middleware,
      groupMiddleWare: groupMiddleWare,
    );
  }

  /// gọi raw POST trả về http.Response đã qua middleware
  static Future<http.Response> post({
    required String url,
    Map<String, String>? headers,
    required String body,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    final uri = Uri.parse(url);
    final headerMap = {...commonHeader, ...currencyHeader};
    if (headers != null) headerMap.addAll(headers);

    final resp = await http.post(uri, headers: headerMap, body: body);
    return AIZApiResponse.check(
      resp,
      middleware: middleware,
      groupMiddleWare: groupMiddleWare,
    );
  }

  /// gọi raw DELETE trả về http.Response đã qua middleware
  static Future<http.Response> delete({
    required String url,
    Map<String, String>? headers,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    final uri = Uri.parse(url);
    final headerMap = {...commonHeader, ...currencyHeader};
    if (headers != null) headerMap.addAll(headers);

    final resp = await http.delete(uri, headers: headerMap);
    return AIZApiResponse.check(
      resp,
      middleware: middleware,
      groupMiddleWare: groupMiddleWare,
    );
  }

  /// wrapper GET + JSON decode an toàn
  ///
  /// - parser: hàm convert String JSON thành model
  /// - defaultValue: giá trị trả về khi lỗi
  static Future<T> getJson<T>({
    required String url,
    Map<String, String>? headers,
    required T Function(String json) parser,
    required T defaultValue,
    Middleware? middleware,
    GroupMiddleware? groupMiddleWare,
  }) async {
    final resp = await get(
      url: url,
      headers: headers,
      middleware: middleware,
      groupMiddleWare: groupMiddleWare,
    );
    print('▶️ [getJson] URL: $url');
    print('▶️ [getJson] statusCode: ${resp.statusCode}');
    print('▶️ [getJson] body: ${resp.body}');
    final body = resp.body.trim();
    if (!(body.startsWith('{') || body.startsWith('['))) {
      // không phải JSON, log và trả default
      print('⚠️ ApiRequest.getJson: Response không phải JSON:\n$body');
      return defaultValue;
    }

    try {
      return parser(body);
    } catch (e, st) {
      print('❌ ApiRequest.getJson: Lỗi parse JSON: $e\n$st\nRaw body: $body');
      return defaultValue;
    }
  }
}
