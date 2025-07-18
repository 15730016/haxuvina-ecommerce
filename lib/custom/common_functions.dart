import 'dart:io';

import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';

class CommonFunctions {
  BuildContext context;

  CommonFunctions(this.context);

  appExitDialog() {
    showDialog(
        context: context,
        builder: (context) => Directionality(
              textDirection:
                  TextDirection.ltr, // ✅ Cố định LTR cho tiếng Việt
              child: AlertDialog(
                content: Text(
                    AppLocalizations.of(context)!.do_you_want_close_the_app),
                actions: [
                  TextButton(
                      onPressed: () {
                        Platform.isAndroid ? SystemNavigator.pop() : exit(0);
                      },
                      child: Text(AppLocalizations.of(context)!.yes_ucf)),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.no_ucf)),
                ],
              ),
            ));
  }

  static TextStyle dashboardBoxNumber(context) {
    return TextStyle(
        fontSize: 16, color: MyTheme.white, fontWeight: FontWeight.bold);
  }

  static TextStyle dashboardBoxText(context) {
    return TextStyle(
        fontSize: 12, color: MyTheme.white, fontWeight: FontWeight.bold);
  }
}
