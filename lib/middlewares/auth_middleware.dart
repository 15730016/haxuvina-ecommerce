import 'package:haxuvina/helpers/main_helpers.dart';
import 'package:haxuvina/middlewares/route_middleware.dart';
import 'package:haxuvina/screens/auth/login.dart';
import 'package:flutter/cupertino.dart';

class AuthMiddleware extends RouteMiddleware {
  Widget _goto;

  AuthMiddleware(this._goto);

  @override
  Widget next() {
    if (!userIsLoggedIn) {
      return Login();
    }
    return _goto;
  }
}
