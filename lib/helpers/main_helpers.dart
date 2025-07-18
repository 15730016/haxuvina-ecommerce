import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/helpers/system_config.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../data_model/currency_response.dart';

bool isNumber(String text) {
  return RegExp('^[0-9]+\$').hasMatch(text);
}

String capitalize(String text) {
  return toBeginningOfSentenceCase(text) ?? text;
}

// Tạo chữ ký bảo mật từ key
Map<String, String> get commonHeader {
  final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  const clientId = "flutter_app";

  final rawData = "$timestamp|$clientId";
  final hmac = Hmac(sha256, utf8.encode(AppConfig.system_key));
  final signature = hmac.convert(utf8.encode(rawData)).toString();

  return {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "App-Language": app_language.$ ?? "vi",
    "System-Client": clientId,
    "System-Timestamp": timestamp,
    "System-Signature": signature,
  };
}

// Nếu cần token, dùng cái này
Map<String, String> get authHeader {
  final headers = commonHeader;
  if (access_token.$ != null) {
    headers["Authorization"] = "Bearer ${access_token.$}";
  }
  return headers;
}

Map<String, String> get currencyHeader =>
    SystemConfig.systemCurrency?.code != null
        ? {
      "Currency-Code": SystemConfig.systemCurrency!.code!,
      "Currency-Exchange-Rate":
      SystemConfig.systemCurrency!.exchangeRate.toString(),
    }
        : {};

String convertPrice(String amount) {
  final currency = SystemConfig.systemCurrency;

  try {
    int value = int.tryParse(amount.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: currency?.symbol ?? '₫',
      decimalDigits: 0,
    );

    String formatted = formatter.format(value);
    print("📤 convertPrice output: $formatted");
    return formatted;
  } catch (e) {
    print("❌ convertPrice error: $e");
    return amount;
  }
}

String formatPoints(num? points) {
  if (points == null) return "0";

  final numberFormat = NumberFormat.decimalPattern('vi');
  return "${numberFormat.format(points)}";
}

String getParameter(GoRouterState state, String key) =>
    state.pathParameters[key] ?? "";

bool get userIsLoggedIn => SystemConfig.systemUser?.id != null;

String formatCurrency(dynamic value, {CurrencyInfo? currency}) {
  int amount = 0;

  if (value is int) {
    amount = value;
  } else if (value is double) {
    amount = value.round(); // không dùng thập phân
  } else if (value is String) {
    amount = parseCurrencyToInt(value);
  }

  final cur = currency ?? SystemConfig.systemCurrency ?? SystemConfig.defaultCurrency;
  final symbol = cur?.symbol ?? '₫';

  // ✅ Chỉ dùng định dạng số, không gắn symbol
  final formatter = NumberFormat('#,###', 'vi_VN');

  return "${formatter.format(amount)} $symbol";
}

int parseCurrencyToInt(String amountStr) {
  try {
    final cleaned = amountStr.replaceAll(RegExp(r'[^\d]'), '');
    return int.parse(cleaned);
  } catch (e) {
    print("❌ parseCurrencyToInt error: $e");
    return 0;
  }
}

double parseCurrencyString(String raw) {
  // Ví dụ: ₫1.234.567,89 hoặc 1,234,567.89 hoặc 1000000 VND
  String cleaned = raw.replaceAll(RegExp(r'[^\d,.]'), '');

  if (cleaned.contains(',') && cleaned.lastIndexOf(',') > cleaned.lastIndexOf('.')) {
    // Định dạng Việt: 1.234.567,89 → 1234567.89
    cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
  } else {
    // Định dạng quốc tế hoặc không có thập phân → bỏ dấu phân cách
    cleaned = cleaned.replaceAll(RegExp(r'[,.]'), '');
  }

  return double.tryParse(cleaned) ?? 0.00;
}

String formatCurrencyNoDecimal(dynamic value, {CurrencyInfo? currency}) {
  int amount = 0;

  if (value is int) {
    amount = value;
  } else if (value is double) {
    amount = value.toInt(); // Bỏ phần thập phân
  } else if (value is String) {
    amount = parseCurrencyToInt(value);
  }

  final cur = currency ?? SystemConfig.systemCurrency ?? SystemConfig.defaultCurrency;
  final symbol = cur?.symbol ?? '₫';

  final formatter = NumberFormat('#,###', 'vi_VN');
  return "${formatter.format(amount)} $symbol";
}

String formatCurrencyBank(String raw) {
  print("🧾 Input raw: \"$raw\"");

  double amount = double.tryParse(raw) ?? 0.0;
  print("💰 Parsed double: $amount");

  int rounded = amount.round(); // làm tròn thành số nguyên
  print("🔢 Rounded int: $rounded");

  final formatter = NumberFormat('#,###', 'vi_VN');
  final formatted = formatter.format(rounded) + ' ₫';
  print("✅ Formatted result: \"$formatted\"");
  return formatted;
}

