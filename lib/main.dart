import 'dart:async';

import 'package:haxuvina/middlewares/auth_middleware.dart';
import 'package:haxuvina/providers/affiliate_provider.dart';
import 'package:haxuvina/screens/auth/login.dart';
import 'package:haxuvina/screens/auth/otp.dart';
import 'package:haxuvina/screens/auth/password_forget.dart';
import 'package:haxuvina/screens/filter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:haxuvina/screens/main.dart';
import 'package:haxuvina/screens/notification/notification_list.dart';
import 'package:haxuvina/screens/product/today_is_deal_products.dart';
import 'package:haxuvina/screens/splash_screen.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:shared_value/shared_value.dart';

import 'app_config.dart';
import 'custom/aiz_route.dart';

import 'firebase_options.dart';
import 'helpers/download_callback.dart';
import 'helpers/main_helpers.dart';
import 'helpers/shared_value_helper.dart';
import 'lang_config.dart';
import 'my_theme.dart';
import 'other_config.dart';
import 'presenter/cart_counter.dart';
import 'presenter/cart_provider.dart';
import 'presenter/currency_presenter.dart';
import 'presenter/home_presenter.dart';
import 'presenter/select_address_provider.dart';
import 'presenter/unRead_notification_counter.dart';
import 'providers/blog_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/auth/registration.dart';
import 'screens/brand_products.dart';
import 'screens/category_list_n_product/category_list.dart';
import 'screens/category_list_n_product/category_products.dart';
import 'screens/checkout/cart.dart';
import 'screens/coupon/coupons.dart';
import 'screens/flash_deal/flash_deal_list.dart';
import 'screens/flash_deal/flash_deal_products.dart';
import 'screens/index.dart';
import 'screens/orders/order_details.dart';
import 'screens/orders/order_list.dart';
import 'screens/product/product_details.dart';
import 'services/push_notification_service.dart';
import 'single_banner/photo_provider.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print("⚠️ Lỗi Flutter UI: ${details.exception}");
  };

  runZonedGuarded(() async {
    print("🚀 Bắt đầu khởi động app...");

    WidgetsFlutterBinding.ensureInitialized();
    print("✅ WidgetsFlutterBinding hoàn tất");

    try {
      print("🔌 Khởi tạo Firebase...");
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("✅ Firebase đã khởi tạo");

      print("⬇️ Khởi tạo FlutterDownloader...");
      await FlutterDownloader.initialize(
        debug: true,
        ignoreSsl: true,
      );
      print("✅ FlutterDownloader đã khởi tạo");

      print("📱 Cấu hình hướng màn hình...");
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      print("✅ Hướng màn hình đã được cấu hình");

      print("🎨 Cấu hình giao diện hệ thống...");
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ));
      print("✅ Giao diện hệ thống đã cấu hình");

      print("📲 Đăng ký callback downloader...");
      FlutterDownloader.registerCallback(downloadCallback);
      print("✅ Callback downloader đã đăng ký");

      print("🚀 Chạy app...");
      runApp(SharedValue.wrapApp(MyApp())); // ✅ CHẠY SỚM HƠN
    } catch (e, stack) {
      print("❌ Lỗi trong try/catch khởi tạo: $e");
      print("📄 StackTrace: $stack");
      runApp(MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text("Không thể khởi động ứng dụng. Vui lòng kiểm tra lại kết nối."),
          ),
        ),
      ));
    }
  }, (error, stackTrace) {
    print("❌ runZonedGuarded catch: $error");
    print("📄 StackTrace: $stackTrace");
  });
}

var routes = GoRouter(
  overridePlatformDefaultLocation: false,
  navigatorKey: OneContext().key,
  initialLocation: "/",
  routes: [
    GoRoute(
        path: '/',
        name: "Home",
        pageBuilder: (BuildContext context, GoRouterState state) =>
            MaterialPage(child: Index()),
        routes: [
          GoRoute(
              path: "product/:slug",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: ProductDetails(
                    slug: getParameter(state, "slug"),
                  ))),
          GoRoute(
              path: "users/login",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: Login())),
          GoRoute(
              path: "users/registration",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: Registration())),
          GoRoute(
              path: "users/password-forget",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: PasswordForget())),
          GoRoute(
            path: 'otp',
            pageBuilder: (BuildContext context, GoRouterState state) {
              final data = state.extra as Map<String, dynamic>? ?? {};
              final phone = data['phone'] as String? ?? '';
              final mode = data['mode'] as String? ?? 'login';

              return MaterialPage(
                child: Otp(
                  title: "Xác minh tài khoản",
                  phone: phone,
                  mode: mode,
                ),
              );
            },
          ),
          GoRoute(
            path: "dashboard",
            name: "Profile",
            redirect: (context, state) {
              if (access_token.$ == null || access_token.$!.isEmpty) {
                return '/users/login';
              }
              return null;
            },
            pageBuilder: (context, state) => AIZRoute.rightTransition(Main(
              go_back: false,
              selected_tab: 3,
            )),
          ),
          GoRoute(
              path: "brand/:slug",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: (BrandProducts(
                    slug: getParameter(state, "slug"),
                  )))),
          GoRoute(
              path: "brands",
              name: "Brands",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: Filter(
                    selected_filter: "brands",
                  ))),
          GoRoute(
              path: "cart",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: AuthMiddleware(Cart()).next())),
          GoRoute(
              path: "categories",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: (CategoryList(
                    slug: getParameter(state, "slug"),
                  )))),
          GoRoute(
              path: "category/:slug",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: (CategoryProducts(
                    slug: getParameter(state, "slug"),
                  )))),
          GoRoute(
              path: "flash-deals",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: (FlashDealList()))),
          GoRoute(
              path: "flash-deal/:slug",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(
                      child: (FlashDealProducts(
                    slug: getParameter(state, "slug"),
                  )))),
          GoRoute(
              path: "purchase_history",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: (OrderList()))),
          GoRoute(
            path: 'purchase_history/details/:id',
            pageBuilder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0; // ✅ ép kiểu
              final goBack = (state.extra as Map?)?['go_back'] as bool? ?? true;

              return MaterialPage(
                child: OrderDetails(id: id, go_back: goBack),
              );
            },
          ),
          GoRoute(
              path: "today-deal",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: (TodayIsDealProducts()))),
          GoRoute(
              path: "coupons",
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  MaterialPage(child: (Coupons()))),
        ]),
    GoRoute(
      path: '/notifications', // 👈 Route cấp cao nhất
      pageBuilder: (context, state) => MaterialPage(child: NotificationList()),
    )
  ],
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        print("💾 Khởi tạo SharedValue bên trong MyApp...");
        await initializeSharedValues();
        print("✅ SharedValue đã khởi tạo");
      } catch (e) {
        print("❌ Lỗi khi khởi tạo SharedValue: $e");
      }

      if (OtherConfig.USE_PUSH_NOTIFICATION) {
        PushNotificationService().initialise();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => CartCounter()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => SelectAddressProvider()),
        ChangeNotifierProvider(
            create: (context) => UnReadNotificationCounter()),
        ChangeNotifierProvider(create: (context) => CurrencyPresenter()),
        ///
        //ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => HomePresenter()),
        ChangeNotifierProvider(create: (_) => BlogProvider()),
        ChangeNotifierProvider(create: (_) => PhotoProvider()),
        ChangeNotifierProvider(create: (_) => AffiliateProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, provider, snapshot) {
          return MaterialApp.router(
            routerConfig: routes,
            title: AppConfig.app_name,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: MyTheme.white,
              scaffoldBackgroundColor: MyTheme.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: "BeVietnamPro",
              textTheme: MyTheme.textTheme1,
              scrollbarTheme: ScrollbarThemeData(
                thumbVisibility: WidgetStateProperty.all<bool>(false),
              ),
            ),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            locale: provider.locale,
            supportedLocales: LangConfig().supportedLocales(),
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              if (AppLocalizations.delegate.isSupported(deviceLocale!)) {
                return deviceLocale;
              }
              return const Locale('vi');
            },
          );
        },
      ),
    );
  }
}
