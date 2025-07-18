import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:haxuvina/custom/btn.dart';
import 'package:haxuvina/custom/toast_component.dart';
import 'package:haxuvina/helpers/auth_helper.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/repositories/auth_repository.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';

class Otp extends StatefulWidget {
  final String title;
  final String phone;
  final String mode;

  const Otp({
    Key? key,
    required this.title,
    required this.phone,
    required this.mode,
  }) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final TextEditingController _otpController = TextEditingController();
  int _resendCountdown = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    _startCountdown();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _canResend = false;
    _resendCountdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> onTapResend() async {
    if (!_canResend) return;

    try {
      final response = await AuthRepository()
          .getResendCodeResponse(phone: widget.phone);

      final message = response.message ?? "Gửi lại thất bại";

      final timeLeftMatch = RegExp(r'Please wait (\d+) seconds')
          .firstMatch(message);

      if (response.result == false && timeLeftMatch != null) {
        final serverTimeLeft = int.parse(timeLeftMatch.group(1)!);
        setState(() {
          _resendCountdown = serverTimeLeft;
          _canResend = false;
        });
        _startCountdown(); // dùng lại _resendCountdown
      } else if (response.result == true) {
        ToastComponent.showDialog(message);
        _startCountdown();
      } else {
        ToastComponent.showDialog(message);
      }
    } catch (e) {
      ToastComponent.showDialog("Đã có lỗi khi gửi lại mã OTP.");
    }
  }


  Future<void> onPressConfirm() async {
    String code = _otpController.text.trim();
    if (code.isEmpty || code.length < 4) {
      ToastComponent.showDialog("Vui lòng nhập mã xác minh hợp lệ");
      return;
    }

    dynamic response;
    try {
      switch (widget.mode) {
        case 'login':
          response = await AuthRepository().verifyOtpLogin(
            phone: widget.phone,
            otp: code, // Đây là OTP dùng cho đăng nhập
          );
          break;

        case 'register_phone':
        case 'register_email':
          response = await AuthRepository().getConfirmCodeResponse(code); // Đây là verification_code dùng cho đăng ký
          break;

        default:
          throw "Chế độ xác minh không hợp lệ";
      }

      if (response?.result == true) {
        ToastComponent.showDialog(response.message ?? "Xác minh thành công");
        AuthHelper().setUserData(response);

        guest_checkout_status.$ = false;
        guest_checkout_status.save();

        if (widget.mode == 'register_phone' || widget.mode == 'login') {
          context.go("/dashboard");
        } else {
          context.go("/users/login");
        }
      } else {
        ToastComponent.showDialog(response?.message ?? "Xác minh thất bại");
      }
    } catch (e) {
      ToastComponent.showDialog("Đã có lỗi xảy ra. Vui lòng thử lại.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmailMode = widget.mode == 'register_email';
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEmailMode
                    ? "Mã xác nhận đã gửi tới email:"
                    : "Nhập mã xác minh đã gửi đến số điện thoại:",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                widget.phone,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.accent_color,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "Nhập mã OTP",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyTheme.accent_color, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(fontSize: 20, letterSpacing: 4),
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: Btn.minWidthFixHeight(
                  minWidth: MediaQuery.of(context).size.width,
                  height: 50,
                  color: MyTheme.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.confirm_ucf,
                    style: TextStyle(
                      color: MyTheme.accent_color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: onPressConfirm,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: _canResend
                    ? TextButton(
                  onPressed: onTapResend,
                  child: Text(
                    "Gửi lại mã xác nhận",
                    style: TextStyle(
                      color: MyTheme.accent_color,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
                    : Text(
                  "Gửi lại mã sau ${_resendCountdown}s",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    AuthHelper().clearUserData();
                    context.go("/");
                  },
                  child: Text(
                    "Đăng xuất",
                    style: TextStyle(
                      color: MyTheme.accent_color,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
