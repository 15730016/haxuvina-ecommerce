// 📁 lib/repositories/auth_repository.dart
import 'dart:convert';

import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/common_response.dart';
import 'package:haxuvina/data_model/confirm_code_response.dart';
import 'package:haxuvina/data_model/login_response.dart';
import 'package:haxuvina/data_model/logout_response.dart';
import 'package:haxuvina/data_model/password_confirm_response.dart';
import 'package:haxuvina/data_model/password_forget_response.dart';
import 'package:haxuvina/data_model/resend_code_response.dart';
import 'package:haxuvina/data_model/otp_send_response.dart';
import 'package:haxuvina/helpers/api_header.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/repositories/api-request.dart';

class AuthRepository {
  Future<LoginResponse> getLoginResponse({
    required String phone,
    required String password,
    required String deviceToken,
    required String loginBy, // 👈 Thêm dòng này
  }) async {
    final postBody = jsonEncode({
      "email": phone,           // 👈 vẫn dùng key "email" theo API backend
      "password": password,
      "device_token": deviceToken,
      "login_by": loginBy,      // 👈 thêm trường login_by để backend xử lý
    });

    final response = await ApiRequest.post(
      url: "${AppConfig.BASE_URL}/auth/login",
      headers: ApiHeader.build(),
      body: postBody,
    );

    return loginResponseFromJson(response.body);
  }

  Future<LoginResponse> getSignupResponse(
      String name,
      String? emailOrPhone,
      String password,
      String passwordConfirmation,
      String registerBy,
      String captchaKey,
      String? referralCode,
      ) async {
    final Map<String, dynamic> data = {
      "name": name,
      "email_or_phone": emailOrPhone,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "register_by": registerBy,
      "g-recaptcha-response": captchaKey,
    };

    if (referralCode != null && referralCode.isNotEmpty) {
      data["referral_code"] = referralCode;
    }

    final response = await ApiRequest.post(
      url: "${AppConfig.BASE_URL}/auth/signup",
      headers: ApiHeader.build(),
      body: jsonEncode(data),
    );

    return loginResponseFromJson(response.body);
  }

  Future<OtpSendResponse> sendOtpCode({required String phone}) async {
    var postBody = jsonEncode({
      "country_code": '84',
      "phone": phone.replaceAll(RegExp(r'[^0-9]'), '').replaceFirst('84', ''),
    });

    final response = await ApiRequest.post(
      url: "${AppConfig.BASE_URL}/auth/send-otp",
      headers: ApiHeader.build(),
      body: postBody,
    );

    return otpSendResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getResendCodeResponse({required String phone}) async {
    var postBody = jsonEncode({
      "phone": phone,
    });

    final response = await ApiRequest.post(
      url: "${AppConfig.BASE_URL}/auth/resend-otp",
      headers: ApiHeader.build(),
      body: postBody,
    );

    return resendCodeResponseFromJson(response.body);
  }

  Future<LoginResponse> verifyOtpLogin({
    required String phone,
    required String otp,
  }) async {
    print('verifyOtpLogin: $phone - $otp');

    var postBody = jsonEncode({
      "phone": phone,
      "otp_code": otp,
    });

    final response = await ApiRequest.post(
      url: "${AppConfig.BASE_URL}/auth/validate-otp-code",
      headers: ApiHeader.build(withAuth: false),
      body: postBody,
    );

    print('verifyOtpLogin response: ${response.body}');
    return loginResponseFromJson(response.body);
  }

  Future<LoginResponse> verifyOtpRegister({
    required String phone,
    required String otp,
  }) async {
    // Giống với verifyOtpLogin
    return verifyOtpLogin(phone: phone, otp: otp);
  }

  Future<ConfirmCodeResponse> getConfirmCodeResponse(String verificationCode) async {
    var postBody = jsonEncode({"verification_code": verificationCode});

    final response = await ApiRequest.post(
      url: "${AppConfig.BASE_URL}/auth/confirm_code",
      headers: ApiHeader.build(),
      body: postBody,
    );

    return confirmCodeResponseFromJson(response.body);
  }

  Future<LogoutResponse> getLogoutResponse() async {
    final response = await ApiRequest.get(
      url: "${AppConfig.BASE_URL}/auth/logout",
      headers: ApiHeader.build(withAuth: true),
    );

    return logoutResponseFromJson(response.body);
  }

  Future<LoginResponse> getUserByTokenResponse() async {
    if (access_token.$!.isNotEmpty) {
      final postBody = jsonEncode({"access_token": access_token.$});

      final response = await ApiRequest.post(
        url: "${AppConfig.BASE_URL}/auth/info",
        headers: ApiHeader.build(withAuth: true),
        body: postBody,
      );

      return loginResponseFromJson(response.body);
    }
    return LoginResponse();
  }

  Future<PasswordForgetResponse> getPasswordForgetResponse(String? emailOrPhone, String sendCodeBy) async {
    var postBody = jsonEncode({
      "email_or_phone": emailOrPhone,
      "send_code_by": sendCodeBy,
    });

    final response = await ApiRequest.post(
      url: "${AppConfig.BASE_URL}/auth/password/forget_request",
      headers: ApiHeader.build(),
      body: postBody,
    );

    return passwordForgetResponseFromJson(response.body);
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(String verificationCode, String password) async {
    var postBody = jsonEncode({
      "verification_code": verificationCode,
      "password": password,
    });

    final response = await ApiRequest.post(
      url: "${AppConfig.BASE_URL}/auth/password/confirm_reset",
      headers: ApiHeader.build(),
      body: postBody,
    );

    return passwordConfirmResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(String? emailOrCode, String verifyBy) async {
    var postBody = jsonEncode({
      "email_or_code": emailOrCode,
      "verify_by": verifyBy,
    });

    final response = await ApiRequest.post(
      url: "${AppConfig.BASE_URL}/auth/password/resend_code",
      headers: ApiHeader.build(),
      body: postBody,
    );

    return resendCodeResponseFromJson(response.body);
  }

  Future<LoginResponse> getSocialLoginResponse(
      String social_provider,
      String? name,
      String? email,
      String? provider, {
        access_token = "",
        secret_token = "",
      }) async {
    email = email == ("null") ? "" : email;

    var postBody = jsonEncode({
      "name": name,
      "email": email,
      "provider": "$provider",
      "social_provider": "$social_provider",
      "access_token": "$access_token",
      "secret_token": "$secret_token",
    });

    final response = await ApiRequest.post(
      url: "${AppConfig.BASE_URL}/auth/social-login",
      headers: {
        "Content-Type": "application/json",
        "App-Language": app_language.$!,
      },
      body: postBody,
    );

    return loginResponseFromJson(response.body);
  }

  Future<CommonResponse> getAccountDeleteResponse() async {
    final response = await ApiRequest.get(
      url: "${AppConfig.BASE_URL}/auth/account-deletion",
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!,
      },
    );

    return commonResponseFromJson(response.body);
  }
}
