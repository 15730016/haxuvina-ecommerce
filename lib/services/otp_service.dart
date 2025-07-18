import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';

class OTPService {
  static const String baseUrl = '${AppConfig.BASE_URL}'; // Thay bằng URL API của bạn

  // Gửi OTP đến số điện thoại
  static Future<Map<String, dynamic>> sendOTP(String phoneNumber) async {
    try {
      final countryCode = phoneNumber.startsWith('+') ? phoneNumber.substring(1, phoneNumber.length - phoneNumber.replaceAll(RegExp(r'[^0-9]'), '').length) : '';
      final phone = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

      final response = await http.post(
        Uri.parse('$baseUrl/v2/auth/send-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'country_code': countryCode,
          'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Lưu session token để xác thực
        if (data['session_token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('otp_session_token', data['session_token']);
          await prefs.setString('otp_phone', phoneNumber);
        }

        return {
          'success': true,
          'message': data['message'] ?? 'OTP đã được gửi',
          'session_token': data['session_token'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Có lỗi xảy ra khi gửi OTP',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: ${e.toString()}',
      };
    }
  }

  // Xác thực OTP
  static Future<Map<String, dynamic>> verifyOTP(String otp) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final phone = prefs.getString('otp_phone');

      if (phone == null) {
        return {
          'success': false,
          'message': 'Số điện thoại không hợp lệ',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/v2/auth/validate-otp-code'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'phone': phone,
          'otp_code': otp,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Lưu token đăng nhập nếu có
        if (data['access_token'] != null) {
          await prefs.setString('access_token', data['access_token']);
          await prefs.setString('user_data', jsonEncode(data['user']));
        }

        // Xóa session OTP
        await clearOTPSession();

        return {
          'success': true,
          'message': data['message'] ?? 'Đăng nhập thành công',
          'user': data['user'],
          'access_token': data['access_token'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'OTP không đúng',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: ${e.toString()}',
      };
    }
  }

  // Gửi lại OTP
  static Future<Map<String, dynamic>> resendOTP() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final phone = prefs.getString('otp_phone');

      if (phone == null) {
        return {
          'success': false,
          'message': 'Không tìm thấy số điện thoại',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/v2/auth/resend-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'OTP đã được gửi lại',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Không thể gửi lại OTP',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Lỗi kết nối: ${e.toString()}',
      };
    }
  }

  // Lấy thời gian còn lại của OTP
  static Future<int> getOTPTimeRemaining() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final phone = prefs.getString('otp_phone');

      if (phone == null) {
        return 0;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/otp/time-remaining?phone=$phone'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['time_remaining'] ?? 0;
      }
    } catch (e) {
      print('Error getting OTP time remaining: $e');
    }
    return 0;
  }

  // Xóa session OTP
  static Future<void> clearOTPSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('otp_session_token');
    await prefs.remove('otp_phone');
  }

  // Kiểm tra có thể gửi lại OTP không
  static Future<bool> canResendOTP() async {
    final timeRemaining = await getOTPTimeRemaining();
    return timeRemaining == 0;
  }

  // Validate số điện thoại Việt Nam
  static bool isValidVietnamesePhone(String phone) {
    // Loại bỏ khoảng trắng và ký tự đặc biệt
    phone = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Kiểm tra độ dài và đầu số
    if (phone.length == 10) {
      // Các đầu số di động Việt Nam
      final validPrefixes = [
        '032', '033', '034', '035', '036', '037', '038', '039', // Viettel
        '070', '079', '077', '076', '078', // Mobifone
        '081', '082', '083', '084', '085', // Vinaphone
        '056', '058', '059', // Vietnamobile
        '099' // Gmobile
      ];

      for (String prefix in validPrefixes) {
        if (phone.startsWith(prefix)) {
          return true;
        }
      }
    }

    return false;
  }

  // Format số điện thoại
  static String formatPhoneNumber(String phone) {
    phone = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (phone.startsWith('84') && phone.length == 12) {
      // Chuyển từ +84 về 0
      phone = '0' + phone.substring(2);
    } else if (phone.startsWith('0') && phone.length == 10) {
      // Đã đúng format
      return phone;
    }

    return phone;
  }

  // Tạo OTP offline cho test (chỉ dùng trong development)
  static String generateTestOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }
}
