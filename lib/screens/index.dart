import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:haxuvina/helpers/addons_helper.dart';
import 'package:haxuvina/helpers/auth_helper.dart';
import 'package:haxuvina/helpers/business_setting_helper.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/helpers/system_config.dart';
import 'package:haxuvina/presenter/currency_presenter.dart';
import 'package:haxuvina/providers/locale_provider.dart';
import 'package:haxuvina/screens/main.dart';
import 'package:haxuvina/screens/splash_screen.dart';

class Index extends StatefulWidget {
  final bool goBack;
  const Index({Key? key, this.goBack = true}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initAppData();
  }

  Future<void> _initAppData() async {
    // Load shared values
    await Future.wait([
      access_token.load(),
      app_language.load(),
      app_mobile_language.load(),
      app_language_rtl.load(),
      system_currency.load(),
    ]);

    // Gọi các helper logic
    AuthHelper().fetch_and_set();
    AddonsHelper().setAddonsData();
    BusinessSettingHelper().setBusinessSettingData();
    Provider.of<CurrencyPresenter>(context, listen: false).fetchListData();

    // Set ngôn ngữ hệ thống
    Provider.of<LocaleProvider>(context, listen: false)
        .setLocale(app_mobile_language.$!);

    // Đánh dấu đã hiển thị splash
    await Future.delayed(const Duration(seconds: 2));
    SystemConfig.isShownSplashScreed = true;

    // Cập nhật UI
    setState(() {
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemConfig.context ??= context;

    return Scaffold(
      body: _ready
          ? Main(go_back: widget.goBack)
          : const SplashScreen(),
    );
  }
}
