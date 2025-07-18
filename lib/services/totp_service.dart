import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TOTPService {
  static const String _keyStorageKey = 'totp_secret_key';
  static const int _codeLength = 6;
  static const int _timeStep = 30; // 30 seconds validity

  // Tạo secret key cho thiết bị (chỉ chạy 1 lần khi cài app)
  static Future<String> generateSecretKey() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Kiểm tra xem đã có key chưa
    String? existingKey = prefs.getString(_keyStorageKey);
    if (existingKey != null) {
      return existingKey;
    }

    // Tạo key mới
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    final key = base64Encode(bytes);
    
    // Lưu key vào storage
    await prefs.setString(_keyStorageKey, key);
    return key;
  }

  // Lấy secret key đã lưu
  static Future<String?> getSecretKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyStorageKey);
  }

  // Tạo mã OTP dựa trên thời gian hiện tại
  static Future<String> generateTOTP() async {
    String? secretKey = await getSecretKey();
    if (secretKey == null) {
      secretKey = await generateSecretKey();
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final timeCounter = currentTime ~/ _timeStep;
    
    return _generateHOTP(secretKey, timeCounter);
  }

  // Tạo mã OTP cho thời gian cụ thể
  static String _generateHOTP(String secret, int counter) {
    final key = base64Decode(secret);
    final counterBytes = _intToBytes(counter);
    
    final hmac = Hmac(sha1, key);
    final digest = hmac.convert(counterBytes);
    final hash = digest.bytes;
    
    final offset = hash[hash.length - 1] & 0xf;
    final code = ((hash[offset] & 0x7f) << 24) |
                 ((hash[offset + 1] & 0xff) << 16) |
                 ((hash[offset + 2] & 0xff) << 8) |
                 (hash[offset + 3] & 0xff);
    
    final otp = code % pow(10, _codeLength);
    return otp.toString().padLeft(_codeLength, '0');
  }

  // Chuyển đổi int thành bytes
  static Uint8List _intToBytes(int value) {
    final bytes = Uint8List(8);
    for (int i = 7; i >= 0; i--) {
      bytes[i] = value & 0xff;
      value >>= 8;
    }
    return bytes;
  }

  // Xác thực mã OTP
  static Future<bool> verifyTOTP(String inputCode) async {
    final currentCode = await generateTOTP();
    return inputCode == currentCode;
  }

  // Lấy thời gian còn lại của mã hiện tại (giây)
  static int getTimeRemaining() {
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return _timeStep - (currentTime % _timeStep);
  }

  // Xóa secret key (khi logout hoặc reset)
  static Future<void> clearSecretKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyStorageKey);
  }
}
