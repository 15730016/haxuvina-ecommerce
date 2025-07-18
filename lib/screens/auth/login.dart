import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haxuvina/custom/btn.dart';
import 'package:haxuvina/custom/loading.dart';
import 'package:haxuvina/repositories/business_setting_repository.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:haxuvina/custom/toast_component.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/ui_elements/auth_ui.dart';
import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/repositories/auth_repository.dart';
import 'package:haxuvina/data_model/business_setting_response.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:haxuvina/helpers/auth_helper.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:crypto/crypto.dart';

class Login extends StatefulWidget {
  final String? prefilledPhone;
  const Login({Key? key, this.prefilledPhone}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final TextEditingController _otpPhoneController = TextEditingController();
  final TextEditingController _accountLoginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loginWithOtpEnabled = false;
  bool isLoadingSettings = true;
  bool showPassword = false;
  bool isSubmitting = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (mounted) setState(() {});
      });
    _fetchBusinessSettings();
    if (widget.prefilledPhone?.isNotEmpty ?? false) {
      _otpPhoneController.text = widget.prefilledPhone!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tabController.index = 0;
      });
    }
  }

  Future<void> _fetchBusinessSettings() async {
    try {
      var response = await BusinessSettingRepository().getBusinessSettingList();
      final found = response.data?.firstWhere(
            (item) => item.type == "login_with_otp",
        orElse: () => Datum(type: "", value: "0"),
      );
      setState(() {
        loginWithOtpEnabled = found?.value == "1";
        isLoadingSettings = false;
      });
    } catch (e) {
      print("Error loading settings: $e");
      setState(() => isLoadingSettings = false);
    }
  }

  void _onLogin() async {
    final isOtpMode = _tabController.index == 0;
    final rawInput = isOtpMode ? _otpPhoneController.text.trim() : _accountLoginController.text.trim();
    final password = _passwordController.text;

    if (rawInput.isEmpty || (!isOtpMode && password.isEmpty)) {
      ToastComponent.showDialog("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    FocusScope.of(context).unfocus();
    Loading.show(context);

    try {
      if (isOtpMode) {
        final phone = _formatVietnamPhone(rawInput);
        if (phone == null) throw "Số điện thoại không hợp lệ";

        final response = await AuthRepository().sendOtpCode(phone: phone);

        if (response.result == true) {
          GoRouter.of(context).push('/otp', extra: {
            'phone': phone,
            'mode': 'login',
          });
        } else {
          throw response.message ?? "Không thể gửi mã OTP";
        }

      } else {
        String loginId;

        if (_isEmail(rawInput)) {
          loginId = rawInput;
        } else {
          final phone = _formatVietnamPhone(rawInput);
          if (phone == null) throw "Số điện thoại không hợp lệ";
          loginId = phone;
        }

        final loginResponse = await AuthRepository().getLoginResponse(
          phone: loginId,
          password: password,
          deviceToken: "",
          loginBy: _isEmail(rawInput) ? "email" : "phone",
        );

        if (loginResponse.result == true) {
          await AuthHelper().setUserData(loginResponse);  // ✅ Cập nhật token và user

          guest_checkout_status.$ = false;
          guest_checkout_status.save();    // ✅ Nếu bạn dùng shared_value
          context.go("/dashboard");                       // ✅ Điều kiện redirect sẽ pass
        } else {
          throw loginResponse.message ?? "Đăng nhập thất bại";
        }
      }

    } catch (e) {
      ToastComponent.showDialog(e.toString());
    } finally {
      Loading.close();
    }
  }

  bool _isEmail(String input) {
    return input.contains('@');
  }

  String? _formatVietnamPhone(String input) {
    String number = input.replaceAll(RegExp(r'\D'), '');

    // Bỏ đầu 0 nếu có, ví dụ: 0979 -> 979
    if (number.startsWith('0')) {
      number = number.substring(1);
    }

    // Chỉ chấp nhận 9 chữ số sau khi bỏ số 0 đầu
    if (number.length != 9 || !RegExp(r'^[1-9]\d{8}$').hasMatch(number)) {
      return null;
    }

    return '+84$number';
  }

  onPressedFacebookLogin() async {
    try {
      final facebookLogin = await FacebookAuth.instance
          .login(loginBehavior: LoginBehavior.webOnly);

      if (facebookLogin.status == LoginStatus.success) {
        // get the user data
        // by default we get the userId, email,name and picture
        final userData = await FacebookAuth.instance.getUserData();
        var loginResponse = await AuthRepository().getSocialLoginResponse(
            "facebook",
            userData['name'].toString(),
            userData['email'].toString(),
            userData['id'].toString(),
            access_token: facebookLogin.accessToken!.tokenString);
        // print("..........................${loginResponse.toString()}");
        if (loginResponse.result == false) {
          ToastComponent.showDialog(
            loginResponse.message!,
          );
        } else {
          ToastComponent.showDialog(
            loginResponse.message!,
          );

          AuthHelper().setUserData(loginResponse);
          context.push("/main");
          FacebookAuth.instance.logOut();
        }
        // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      } else {
        print("....Facebook auth Failed.........");
        // print(facebookLogin.status);
        // print(facebookLogin.message);
      }
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  onPressedGoogleLogin() async {
    try {
      final GoogleSignInAccount googleUser = (await GoogleSignIn().signIn())!;

      print(googleUser.toString());

      GoogleSignInAuthentication googleSignInAuthentication =
      await googleUser.authentication;
      String? accessToken = googleSignInAuthentication.accessToken;

      // print("displayName ${googleUser.displayName}");
      // print("email ${googleUser.email}");
      // print("googleUser.id ${googleUser.id}");

      var loginResponse = await AuthRepository().getSocialLoginResponse(
          "google", googleUser.displayName, googleUser.email, googleUser.id,
          access_token: accessToken);

      if (loginResponse.result == false) {
        ToastComponent.showDialog(
          loginResponse.message!,
        );
      } else {
        ToastComponent.showDialog(
          loginResponse.message!,
        );
        AuthHelper().setUserData(loginResponse);
        context.push("/main");
      }
      GoogleSignIn().disconnect();
    } on Exception catch (e) {
      print("error is ....... $e");
      // TODO
    }
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      var loginResponse = await AuthRepository().getSocialLoginResponse(
          "apple",
          appleCredential.givenName,
          appleCredential.email,
          appleCredential.userIdentifier,
          access_token: appleCredential.identityToken);

      if (loginResponse.result == false) {
        ToastComponent.showDialog(
          loginResponse.message!,
        );
      } else {
        ToastComponent.showDialog(
          loginResponse.message!,
        );
        AuthHelper().setUserData(loginResponse);
        context.push("/main");
      }
    } on Exception catch (e) {
      print(e);
      // TODO
    }

    // Create an `OAuthCredential` from the credential returned by Apple.
    // final oauthCredential = OAuthProvider("apple.com").credential(
    //   idToken: appleCredential.identityToken,
    //   rawNonce: rawNonce,
    // );
    //print(oauthCredential.accessToken);

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    //return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;

    if (isLoadingSettings) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AuthScreen.buildScreen(
      context,
      "${AppLocalizations.of(context)!.login_to} ${AppConfig.app_name}",
      buildBody(context, _screenWidth),
    );
  }

  Widget buildBody(BuildContext context, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TabBar(
          controller: _tabController,
          labelColor: MyTheme.accent_color,
          unselectedLabelColor: Colors.grey,
          indicatorColor: MyTheme.accent_color,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: "OTP"),
            Tab(text: "Mật khẩu"),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: MyTheme.amber, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: _tabController.index == 0
                  ? KeyedSubtree(
                key: const ValueKey('otp'),
                child: buildOtpTab(),
              )
                  : KeyedSubtree(
                key: const ValueKey('password'),
                child: buildPasswordTab(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        isSubmitting
            ? const Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator())
            : SizedBox(
          height: 60,
          child: Btn.minWidthFixHeight(
            minWidth: MediaQuery.of(context).size.width,
            height: 60,
            color: MyTheme.amber,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0)),
            child: Text(
              AppLocalizations.of(context)!.login_screen_log_in,
              style: TextStyle(
                  color: MyTheme.accent_color,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
            onPressed: _onLogin,
          ),
        ),
        if (Platform.isIOS)
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SignInWithAppleButton(
              onPressed: () async {
                signInWithApple();
              },
            ),
          ),
        Visibility(
          visible: allow_google_login.$ || allow_facebook_login.$,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
                child: Text(
                  AppLocalizations.of(context)!.login_screen_login_with,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 15),
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: allow_google_login.$,
                  child: InkWell(
                    onTap: () {
                      onPressedGoogleLogin();
                    },
                    child: SizedBox(
                      width: 28,
                      child: Image.asset("assets/google_logo.png"),
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                Visibility(
                  visible: allow_facebook_login.$,
                  child: InkWell(
                    onTap: () {
                      onPressedFacebookLogin();
                    },
                    child: SizedBox(
                      width: 28,
                      child: Image.asset("assets/facebook_logo.png"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15),
          child: Center(
              child: Text(
                AppLocalizations.of(context)!
                    .login_screen_or_create_new_account,
                style: TextStyle(color: MyTheme.golden, fontSize: 13),
              )),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: Btn.minWidthFixHeight(
            minWidth: MediaQuery.of(context).size.width,
            height: 60,
            color: MyTheme.amber,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0)),
            child: Text(
              AppLocalizations.of(context)!.login_screen_sign_up,
              style: TextStyle(
                  color: MyTheme.blue_chill,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              context.push("/users/registration");
            },
          ),
        ),
      ],
    );
  }

  Widget buildOtpTab() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _otpPhoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 12),
                  Image.asset('assets/flags/vn.png', width: 24),
                  const SizedBox(width: 4),
                  const Text('+84'),
                  const SizedBox(width: 8),
                ],
              ),
              hintText: "Nhập số điện thoại",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey), // tùy chỉnh màu
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPasswordTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Số điện thoại hoặc Email",
          style: TextStyle(
              color: MyTheme.accent_color, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _accountLoginController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person),
            hintText: "Nhập số điện thoại hoặc email",
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
                "Mật khẩu",
                style: TextStyle(color: MyTheme.accent_color, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: !showPassword,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => showPassword = !showPassword),
            ),
            hintText: "Nhập mật khẩu",
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              context.push("/users/password-forget");
            },
            child: const Text("Quên mật khẩu?", style: TextStyle(fontSize: 14)),
          ),
        ),
      ],
    );
  }
}
