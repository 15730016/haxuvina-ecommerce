import 'package:haxuvina/data_model/address_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/helpers/system_config.dart';
import 'package:haxuvina/screens/checkout/select_address.dart';
import 'package:haxuvina/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AIZRoute {
  static Future<T?> push<T extends Object?>(
      BuildContext context, Widget route, {String? phone}) {
    if (_isMailVerifiedRoute(route)) {
      // Nếu cần xác minh email thì đẩy qua GoRouter tới /otp
      context.push('otp', extra: phone ?? '');
      return Future.value(null);
    }

    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => route));
  }

  static Future<T?> slideLeft<T extends Object?>(
      BuildContext context, Widget route, {String? phone}) {
    if (_isMailVerifiedRoute(route)) {
      context.push('otp', extra: phone ?? '');
      return Future.value(null);
    }

    return Navigator.push(context, _leftTransition<T>(route));
  }

  static Future<T?> slideRight<T extends Object?>(
      BuildContext context, Widget route, {String? phone}) {
    if (_isMailVerifiedRoute(route)) {
      context.push('otp', extra: phone ?? '');
      return Future.value(null);
    }

    return Navigator.push(context, _rightTransition<T>(route));
  }

  static Route<T> _leftTransition<T extends Object?>(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin =
        !(app_language_rtl.$!) ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route<T> _rightTransition<T extends Object?>(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage rightTransition(Widget page) {
    return CustomTransitionPage(
      child: page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin =
        !(app_language_rtl.$!) ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static bool _isMailVerifiedRoute(Widget widget) {
    bool mailVerifiedRoute = false;
    mailVerifiedRoute = <Type>[SelectAddress, Address, Profile]
        .any((element) => widget.runtimeType == element);
    if (is_logged_in.$ &&
        mailVerifiedRoute &&
        SystemConfig.systemUser != null) {
      return !(SystemConfig.systemUser!.emailVerified ?? true);
    }
    return false;
  }
}
