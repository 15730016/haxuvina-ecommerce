import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/main.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/presenter/bottom_appbar_index.dart';
import 'package:haxuvina/presenter/cart_counter.dart';
import 'package:haxuvina/screens/auth/login.dart';
import 'package:haxuvina/screens/category_list_n_product/category_list.dart';
import 'package:haxuvina/screens/checkout/cart.dart';
import 'package:haxuvina/screens/home.dart';
import 'package:haxuvina/screens/profile.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';

class Main extends StatefulWidget {
  final bool go_back;
  final int selected_tab;
  const Main({Key? key, this.go_back = true, this.selected_tab = 0}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  late List<Widget> _children;
  final CartCounter counter = CartCounter();
  final BottomAppbarIndex bottomAppbarIndex = BottomAppbarIndex();
  bool _dialogShowing = false;

  @override
  void initState() {
    _currentIndex = widget.selected_tab;
    _children = [
      Home(),
      CategoryList(slug: "", is_base_category: true),
      Cart(
        has_bottom_nav: true,
        from_navigation: true,
        counter: counter,
      ),
      Profile(),
    ];
    fetchAll(); // Nếu bạn có hàm này cho dữ liệu chung
    super.initState();
  }

  void fetchAll() {
    getCartCount();
  }

  Future<void> getCartCount() async {
    Provider.of<CartCounter>(context, listen: false).getCount();
  }

  void onTapped(int index) {
    fetchAll();

    if (index == 2 && !guest_checkout_status.$ && !is_logged_in.$) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => Login()));
      return;
    }

    // if (index == 3) {
    //   routes.push("/dashboard");
    //   return;
    // }

    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> willPop() async {
    if (_currentIndex != 0) {
      fetchAll();
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }

    if (_dialogShowing) return false;

    setState(() {
      _dialogShowing = true;
    });

    final shouldPop = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AlertDialog(
            content: Text(AppLocalizations.of(context)!.do_you_want_close_the_app),
            actions: [
              TextButton(
                onPressed: () {
                  Platform.isAndroid ? SystemNavigator.pop() : exit(0);
                },
                child: Text(AppLocalizations.of(context)!.yes_ucf),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context)!.no_ucf),
              ),
            ],
          ),
        );
      },
    ) ??
        false;

    setState(() {
      _dialogShowing = false;
    });

    return shouldPop;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) willPop();
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          child: Scaffold(
            extendBody: true,
            body: IndexedStack(
              index: _currentIndex,
              children: _children,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: onTapped,
              backgroundColor: Colors.white.withAlpha(242),
              unselectedItemColor: const Color.fromRGBO(168, 175, 179, 1),
              selectedItemColor: MyTheme.accent_color,
              selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.asset(
                      "assets/home.png",
                      color: _currentIndex == 0
                          ? MyTheme.accent_color
                          : const Color.fromRGBO(153, 153, 153, 1),
                      height: 16,
                    ),
                  ),
                  label: AppLocalizations.of(context)!.home_ucf,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.asset(
                      "assets/categories.png",
                      color: _currentIndex == 1
                          ? MyTheme.accent_color
                          : const Color.fromRGBO(153, 153, 153, 1),
                      height: 16,
                    ),
                  ),
                  label: AppLocalizations.of(context)!.categories_ucf,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: badges.Badge(
                      badgeStyle: badges.BadgeStyle(
                        shape: badges.BadgeShape.circle,
                        badgeColor: MyTheme.accent_color,
                        borderRadius: BorderRadius.circular(10),
                        padding: const EdgeInsets.all(5),
                      ),
                      badgeAnimation: badges.BadgeAnimation.slide(toAnimate: false),
                      badgeContent: Consumer<CartCounter>(
                        builder: (context, cart, child) => Text(
                          "${cart.cartCounter}",
                          style: const TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                      child: Image.asset(
                        "assets/cart.png",
                        color: _currentIndex == 2
                            ? MyTheme.accent_color
                            : const Color.fromRGBO(153, 153, 153, 1),
                        height: 16,
                      ),
                    ),
                  ),
                  label: AppLocalizations.of(context)!.cart_ucf,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.asset(
                      "assets/profile.png",
                      color: _currentIndex == 3
                          ? MyTheme.accent_color
                          : const Color.fromRGBO(153, 153, 153, 1),
                      height: 16,
                    ),
                  ),
                  label: AppLocalizations.of(context)!.profile_ucf,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
