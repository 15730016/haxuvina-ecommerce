import 'package:shared_value/shared_value.dart';
import '../app_config.dart';

/// ───────────────────────────────────────────────
/// 👤 Thông tin người dùng & đăng nhập
/// ───────────────────────────────────────────────
final SharedValue<bool> is_logged_in = SharedValue(
  value: false,
  key: "is_logged_in",
);

final SharedValue<String?> access_token = SharedValue(
  value: "",
  key: "access_token",
);

final SharedValue<int?> user_id = SharedValue(
  value: 0,
  key: "user_id",
);

final SharedValue<String?> user_name = SharedValue(
  value: "",
  key: "user_name",
);

final SharedValue<String?> avatar_original = SharedValue(
  value: "",
  key: "avatar_original",
);

final SharedValue<String> user_email = SharedValue(
  value: "",
  key: "user_email",
);

final SharedValue<String> user_phone = SharedValue(
  value: "",
  key: "user_phone",
);

/// ───────────────────────────────────────────────
/// 👥 Người dùng vãng lai (khách chưa login)
/// ───────────────────────────────────────────────
final SharedValue<String?> temp_user_id = SharedValue(
  value: "",
  key: "temp_user_id",
);

final SharedValue<String> guestEmail = SharedValue(
  value: "",
  key: "guest_email",
);

/// ───────────────────────────────────────────────
/// 🌐 Ngôn ngữ & tiền tệ
/// ───────────────────────────────────────────────
final SharedValue<String?> app_language = SharedValue(
  value: AppConfig.default_language,
  key: "app_language",
);

final SharedValue<String?> app_mobile_language = SharedValue(
  value: AppConfig.mobile_app_code,
  key: "app_mobile_language",
);

final SharedValue<bool?> app_language_rtl = SharedValue(
  value: AppConfig.app_language_rtl,
  key: "app_language_rtl",
);

final SharedValue<int?> system_currency = SharedValue(
  value: 0,
  key: "system_currency",
);

/// ───────────────────────────────────────────────
/// 🧩 Addon được bật từ backend
/// ───────────────────────────────────────────────
final SharedValue<bool> club_point_addon_installed = SharedValue(
  value: false,
  key: "club_point_addon_installed",
);

final SharedValue<bool> whole_sale_addon_installed = SharedValue(
  value: false,
  key: "whole_sale_addon_installed",
);

final SharedValue<bool> refund_addon_installed = SharedValue(
  value: false,
  key: "refund_addon_installed",
);

final SharedValue<bool> otp_addon_installed = SharedValue(
  value: false,
  key: "otp_addon_installed",
);

final SharedValue<bool> auction_addon_installed = SharedValue(
  value: false,
  key: "auction_addon_installed",
);

/// ───────────────────────────────────────────────
/// 🔐 Đăng nhập mạng xã hội
/// ───────────────────────────────────────────────
final SharedValue<bool> allow_google_login = SharedValue(
  value: false,
  key: "allow_google_login",
);

final SharedValue<bool> allow_facebook_login = SharedValue(
  value: false,
  key: "allow_facebook_login",
);

final SharedValue<bool> allow_apple_login = SharedValue(
  value: false,
  key: "allow_apple_login",
);

/// ───────────────────────────────────────────────
/// ⚙️ Cài đặt hệ thống / cửa hàng
/// ───────────────────────────────────────────────
final SharedValue<bool> pick_up_status = SharedValue(
  value: false,
  key: "pick_up_status",
);

final SharedValue<bool> carrier_base_shipping = SharedValue(
  value: false,
  key: "carrier_base_shipping",
);

final SharedValue<bool> google_recaptcha = SharedValue(
  value: false,
  key: "google_recaptcha",
);

final SharedValue<bool> wallet_system_status = SharedValue(
  value: false,
  key: "wallet_system_status",
);

final SharedValue<bool> mail_verification_status = SharedValue(
  value: false,
  key: "mail_verification_status",
);

final SharedValue<bool> conversation_system_status = SharedValue(
  value: false,
  key: "conversation_system",
);

final SharedValue<bool> vendor_system = SharedValue(
  value: false,
  key: "vendor_system",
);

final SharedValue<bool> classified_product_status = SharedValue(
  value: false,
  key: "classified_product",
);

final SharedValue<bool> guest_checkout_status = SharedValue(
  value: false,
  key: "guest_checkout",
);

final SharedValue<bool> last_viewed_product_status = SharedValue(
  value: false,
  key: "last_viewed_product_activation",
);

/// ───────────────────────────────────────────────
/// 🔔 Cài đặt hiển thị thông báo
/// ───────────────────────────────────────────────
final SharedValue<String> notificationShowType = SharedValue(
  value: "",
  key: "notification_show_type",
);

final SharedValue<String> coupon_code = SharedValue(
  value: "",
  key: "coupon_code",
);



Future<void> initializeSharedValues() async {
  await Future.wait([
    is_logged_in.load(),
    access_token.load(),
    user_id.load(),
    user_name.load(),
    avatar_original.load(),
    user_email.load(),
    user_phone.load(),
    temp_user_id.load(),
    guestEmail.load(),
    app_language.load(),
    app_mobile_language.load(),
    app_language_rtl.load(),
    system_currency.load(),
    club_point_addon_installed.load(),
    whole_sale_addon_installed.load(),
    refund_addon_installed.load(),
    otp_addon_installed.load(),
    auction_addon_installed.load(),
    allow_google_login.load(),
    allow_facebook_login.load(),
    allow_apple_login.load(),
    pick_up_status.load(),
    carrier_base_shipping.load(),
    google_recaptcha.load(),
    wallet_system_status.load(),
    mail_verification_status.load(),
    conversation_system_status.load(),
    classified_product_status.load(),
    guest_checkout_status.load(),
    last_viewed_product_status.load(),
    notificationShowType.load(),
    coupon_code.load(),
  ]);
}
