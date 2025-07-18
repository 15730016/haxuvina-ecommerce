import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('vi')];

  /// No description provided for @auction_product_screen_.
  ///
  /// In vi, this message translates to:
  /// **''**
  String get auction_product_screen_;

  /// No description provided for @auction_product_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm đấu giá'**
  String get auction_product_ucf;

  /// No description provided for @auction_product_screen_title.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm đấu giá'**
  String get auction_product_screen_title;

  /// No description provided for @all_bidded_products.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả sản phẩm đấu thầu'**
  String get all_bidded_products;

  /// No description provided for @auction_purchase_history_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử mua đấu giá'**
  String get auction_purchase_history_ucf;

  /// No description provided for @auction_my_bid_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giá thầu của tôi'**
  String get auction_my_bid_ucf;

  /// No description provided for @auction_highest_bid_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giá thầu cao nhất'**
  String get auction_highest_bid_ucf;

  /// No description provided for @auction_order_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đơn đặt hàng đấu giá'**
  String get auction_order_ucf;

  /// No description provided for @auction_start_date_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ngày bắt đầu'**
  String get auction_start_date_ucf;

  /// No description provided for @auction_end_date_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ngày kết thúc'**
  String get auction_end_date_ucf;

  /// No description provided for @auction_total_bids_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số hồ sơ dự thầu'**
  String get auction_total_bids_ucf;

  /// No description provided for @auction_price_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giá'**
  String get auction_price_ucf;

  /// No description provided for @auction_view_bids_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả các giá thầu'**
  String get auction_view_bids_ucf;

  /// No description provided for @auction_all_bids_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả giá thầu'**
  String get auction_all_bids_ucf;

  /// No description provided for @auction_biding_price_date_range_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giá đấu thầu sản phẩm + Khoảng thời gian'**
  String get auction_biding_price_date_range_ucf;

  /// No description provided for @auction_starting_bid_price_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu giá đấu thầu'**
  String get auction_starting_bid_price_ucf;

  /// No description provided for @auction_date_range_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng thời gian đấu giá'**
  String get auction_date_range_ucf;

  /// No description provided for @auction_will_end.
  ///
  /// In vi, this message translates to:
  /// **'Đấu giá sẽ kết thúc'**
  String get auction_will_end;

  /// No description provided for @starting_bid_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu giá thầu'**
  String get starting_bid_ucf;

  /// No description provided for @highest_bid_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giá thầu cao nhất'**
  String get highest_bid_ucf;

  /// No description provided for @place_bid_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đặt giá thầu'**
  String get place_bid_ucf;

  /// No description provided for @change_bid_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi giá thầu'**
  String get change_bid_ucf;

  /// No description provided for @are_you_sure_to_mark_this_as_delivered.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn để đánh dấu điều này là được giao?'**
  String get are_you_sure_to_mark_this_as_delivered;

  /// No description provided for @are_you_sure_to_mark_this_as_picked_up.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn để đánh dấu điều này là được chọn?'**
  String get are_you_sure_to_mark_this_as_picked_up;

  /// No description provided for @are_you_sure_to_request_cancellation.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn yêu cầu hủy bỏ?'**
  String get are_you_sure_to_request_cancellation;

  /// No description provided for @enter_address_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập địa chỉ'**
  String get enter_address_ucf;

  /// No description provided for @back_to_shipping_info.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại thông tin giao hàng'**
  String get back_to_shipping_info;

  /// No description provided for @select_a_city.
  ///
  /// In vi, this message translates to:
  /// **'Chọn xã, phường'**
  String get select_a_city;

  /// No description provided for @select_a_state.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tỉnh, thành phố'**
  String get select_a_state;

  /// No description provided for @select_a_country.
  ///
  /// In vi, this message translates to:
  /// **'Chọn một quốc gia'**
  String get select_a_country;

  /// No description provided for @address_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ'**
  String get address_ucf;

  /// No description provided for @city_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xã, phường'**
  String get city_ucf;

  /// No description provided for @enter_city_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập xã, phường'**
  String get enter_city_ucf;

  /// No description provided for @postal_code_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mã bưu điện'**
  String get postal_code_ucf;

  /// No description provided for @enter_postal_code_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã bưu điện'**
  String get enter_postal_code_ucf;

  /// No description provided for @country_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Quốc gia'**
  String get country_ucf;

  /// No description provided for @enter_country_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập quốc gia'**
  String get enter_country_ucf;

  /// No description provided for @state_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tỉnh, thành phố'**
  String get state_ucf;

  /// No description provided for @enter_state_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tỉnh, thành phố'**
  String get enter_state_ucf;

  /// No description provided for @phone_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Điện thoại'**
  String get phone_ucf;

  /// No description provided for @enter_phone_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập điện thoại'**
  String get enter_phone_ucf;

  /// No description provided for @are_you_sure_to_remove_this_address.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn sẽ xóa địa chỉ này không?'**
  String get are_you_sure_to_remove_this_address;

  /// No description provided for @addresses_of_user.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ'**
  String get addresses_of_user;

  /// No description provided for @double_tap_on_an_address_to_make_it_default.
  ///
  /// In vi, this message translates to:
  /// **'Nhấp 2 lần trên một địa chỉ để làm mặc định'**
  String get double_tap_on_an_address_to_make_it_default;

  /// No description provided for @no_country_available.
  ///
  /// In vi, this message translates to:
  /// **'Không có quốc gia có sẵn'**
  String get no_country_available;

  /// No description provided for @no_state_available.
  ///
  /// In vi, this message translates to:
  /// **'Không có tỉnh, thành phố có sẵn'**
  String get no_state_available;

  /// No description provided for @no_city_available.
  ///
  /// In vi, this message translates to:
  /// **'Không có xã, phường có sẵn'**
  String get no_city_available;

  /// No description provided for @loading_countries_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải các quốc gia ...'**
  String get loading_countries_ucf;

  /// No description provided for @loading_states_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải tỉnh, thành phố ...'**
  String get loading_states_ucf;

  /// No description provided for @loading_cities_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải xã, phường...'**
  String get loading_cities_ucf;

  /// No description provided for @select_a_country_first.
  ///
  /// In vi, this message translates to:
  /// **'Trước tiên chọn một quốc gia'**
  String get select_a_country_first;

  /// No description provided for @select_a_state_first.
  ///
  /// In vi, this message translates to:
  /// **'Trước tiên chọn tỉnh, thành phố'**
  String get select_a_state_first;

  /// No description provided for @edit_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get edit_ucf;

  /// No description provided for @delete_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete_ucf;

  /// No description provided for @add_location_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vị trí'**
  String get add_location_ucf;

  /// No description provided for @assigned.
  ///
  /// In vi, this message translates to:
  /// **'Được giao'**
  String get assigned;

  /// No description provided for @amount_to_Collect_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thu nhập'**
  String get amount_to_Collect_ucf;

  /// No description provided for @account_delete_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tài khoản'**
  String get account_delete_ucf;

  /// No description provided for @fetching_bkash_url.
  ///
  /// In vi, this message translates to:
  /// **'Tìm nạp url bkash ...'**
  String get fetching_bkash_url;

  /// No description provided for @pay_with_bkash.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán với Bkash'**
  String get pay_with_bkash;

  /// No description provided for @search_product_here.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm sản phẩm ở đây ...'**
  String get search_product_here;

  /// No description provided for @do_you_want_to_delete_it.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có muốn xóa không?'**
  String get do_you_want_to_delete_it;

  /// No description provided for @you_need_to_log_in.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần phải đăng nhập'**
  String get you_need_to_log_in;

  /// No description provided for @please_choose_valid_info.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn thông tin hợp lệ'**
  String get please_choose_valid_info;

  /// No description provided for @nothing_to_pay.
  ///
  /// In vi, this message translates to:
  /// **'Không có gì để thanh toán'**
  String get nothing_to_pay;

  /// No description provided for @see_details_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'Xem chi tiết'**
  String get see_details_all_lower;

  /// No description provided for @no_payment_method_is_added.
  ///
  /// In vi, this message translates to:
  /// **'Không có phương thức thanh toán nào được thêm vào'**
  String get no_payment_method_is_added;

  /// No description provided for @please_choose_one_option_to_pay.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn một tùy chọn để thanh toán'**
  String get please_choose_one_option_to_pay;

  /// No description provided for @no_data_is_available.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu'**
  String get no_data_is_available;

  /// No description provided for @no_address_is_added.
  ///
  /// In vi, this message translates to:
  /// **'Không có địa chỉ nào được thêm vào'**
  String get no_address_is_added;

  /// No description provided for @loading_more_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải nhiều sản phẩm hơn ...'**
  String get loading_more_products_ucf;

  /// No description provided for @no_more_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không còn sản phẩm'**
  String get no_more_products_ucf;

  /// No description provided for @no_product_is_available.
  ///
  /// In vi, this message translates to:
  /// **'Không có sản phẩm nào có sẵn'**
  String get no_product_is_available;

  /// No description provided for @loading_more_brands_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải nhiều thương hiệu hơn ...'**
  String get loading_more_brands_ucf;

  /// No description provided for @no_more_brands_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không có thêm thương hiệu'**
  String get no_more_brands_ucf;

  /// No description provided for @no_brand_is_available.
  ///
  /// In vi, this message translates to:
  /// **'Không có thương hiệu nào có sẵn'**
  String get no_brand_is_available;

  /// No description provided for @loading_more_items_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải thêm...'**
  String get loading_more_items_ucf;

  /// No description provided for @no_more_items_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không còn gì nữa'**
  String get no_more_items_ucf;

  /// No description provided for @no_item_is_available.
  ///
  /// In vi, this message translates to:
  /// **'Không có sản phẩm nào có sẵn'**
  String get no_item_is_available;

  /// No description provided for @loading_more_shops_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải nhiều cửa hàng hơn ...'**
  String get loading_more_shops_ucf;

  /// No description provided for @no_more_shops_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không còn cửa hàng nữa'**
  String get no_more_shops_ucf;

  /// No description provided for @no_shop_is_available.
  ///
  /// In vi, this message translates to:
  /// **'Không có cửa hàng nào có sẵn'**
  String get no_shop_is_available;

  /// No description provided for @loading_more_histories_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tải thêm lịch sử ...'**
  String get loading_more_histories_ucf;

  /// No description provided for @no_more_histories_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không còn lịch sử nữa'**
  String get no_more_histories_ucf;

  /// No description provided for @no_history_is_available.
  ///
  /// In vi, this message translates to:
  /// **'Không có lịch sử có sẵn'**
  String get no_history_is_available;

  /// No description provided for @loading_more_categories_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải nhiều danh mục hơn ...'**
  String get loading_more_categories_ucf;

  /// No description provided for @no_more_categories_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không còn danh mục nữa'**
  String get no_more_categories_ucf;

  /// No description provided for @no_category_is_available.
  ///
  /// In vi, this message translates to:
  /// **'Không có danh mục nào có sẵn'**
  String get no_category_is_available;

  /// No description provided for @coming_soon.
  ///
  /// In vi, this message translates to:
  /// **'Sắp ra mắt'**
  String get coming_soon;

  /// No description provided for @close_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'ĐÓNG'**
  String get close_all_capital;

  /// No description provided for @close_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'đóng'**
  String get close_all_lower;

  /// No description provided for @close_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close_ucf;

  /// No description provided for @cancel_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'HỦY BỎ'**
  String get cancel_all_capital;

  /// No description provided for @cancel_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'Hủy bỏ'**
  String get cancel_all_lower;

  /// No description provided for @cancel_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hủy bỏ'**
  String get cancel_ucf;

  /// No description provided for @confirm_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'XÁC NHẬN'**
  String get confirm_all_capital;

  /// No description provided for @confirm_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'xác nhận'**
  String get confirm_all_lower;

  /// No description provided for @confirm_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm_ucf;

  /// No description provided for @update_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'CẬP NHẬT'**
  String get update_all_capital;

  /// No description provided for @update_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'cập nhật'**
  String get update_all_lower;

  /// No description provided for @update_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật'**
  String get update_ucf;

  /// No description provided for @send_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'GỬI'**
  String get send_all_capital;

  /// No description provided for @send_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'gửi'**
  String get send_all_lower;

  /// No description provided for @send_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get send_ucf;

  /// No description provided for @clear_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'XÓA'**
  String get clear_all_capital;

  /// No description provided for @clear_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'xóa'**
  String get clear_all_lower;

  /// No description provided for @clear_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get clear_ucf;

  /// No description provided for @apply_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'ÁP DỤNG'**
  String get apply_all_capital;

  /// No description provided for @apply_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'áp dụng'**
  String get apply_all_lower;

  /// No description provided for @apply_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get apply_ucf;

  /// No description provided for @add_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'THÊM VÀO'**
  String get add_all_capital;

  /// No description provided for @add_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'thêm vào'**
  String get add_all_lower;

  /// No description provided for @add_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào'**
  String get add_ucf;

  /// No description provided for @copied_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép'**
  String get copied_ucf;

  /// No description provided for @proceed_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get proceed_ucf;

  /// No description provided for @proceed_all_caps.
  ///
  /// In vi, this message translates to:
  /// **'TIẾP TỤC'**
  String get proceed_all_caps;

  /// No description provided for @submit_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get submit_ucf;

  /// No description provided for @shop_more_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mua thêm'**
  String get shop_more_ucf;

  /// No description provided for @show_less_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị ít hơn'**
  String get show_less_ucf;

  /// No description provided for @selected_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đã chọn'**
  String get selected_ucf;

  /// No description provided for @creating_order.
  ///
  /// In vi, this message translates to:
  /// **'Tạo thứ tự ...'**
  String get creating_order;

  /// No description provided for @payment_cancelled_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán đã hủy'**
  String get payment_cancelled_ucf;

  /// No description provided for @photo_permission_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cho phép truy cập ảnh'**
  String get photo_permission_ucf;

  /// No description provided for @this_app_needs_permission.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng này cần sự cho phép'**
  String get this_app_needs_permission;

  /// No description provided for @deny_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get deny_ucf;

  /// No description provided for @settings_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings_ucf;

  /// No description provided for @go_to_your_application_settings_and_give_photo_permission.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển đến cài đặt ứng dụng của bạn và cho phép truy cập ảnh'**
  String get go_to_your_application_settings_and_give_photo_permission;

  /// No description provided for @no_file_is_chosen.
  ///
  /// In vi, this message translates to:
  /// **'Không có tập tin nào được chọn'**
  String get no_file_is_chosen;

  /// No description provided for @yes_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đồng ý'**
  String get yes_ucf;

  /// No description provided for @no_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không'**
  String get no_ucf;

  /// No description provided for @date_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get date_ucf;

  /// No description provided for @follow_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Follow'**
  String get follow_ucf;

  /// No description provided for @followed_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đã Follow'**
  String get followed_ucf;

  /// No description provided for @unfollow_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hủy Follow nhà bán hàng'**
  String get unfollow_ucf;

  /// No description provided for @continue_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get continue_ucf;

  /// No description provided for @day_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get day_ucf;

  /// No description provided for @days_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get days_ucf;

  /// No description provided for @network_error.
  ///
  /// In vi, this message translates to:
  /// **'Mạng lỗi'**
  String get network_error;

  /// No description provided for @get_locations.
  ///
  /// In vi, this message translates to:
  /// **'NĐịa điểm nhận'**
  String get get_locations;

  /// No description provided for @get_direction_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhận chỉ đường'**
  String get get_direction_ucf;

  /// No description provided for @digital_product_screen_.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm kỹ thuật số'**
  String get digital_product_screen_;

  /// No description provided for @dashboard_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Bảng điều khiển'**
  String get dashboard_ucf;

  /// No description provided for @earnings_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập'**
  String get earnings_ucf;

  /// No description provided for @not_logged_in_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không đăng nhập'**
  String get not_logged_in_ucf;

  /// No description provided for @change_language_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi ngôn ngữ'**
  String get change_language_ucf;

  /// No description provided for @home_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home_ucf;

  /// No description provided for @profile_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profile_ucf;

  /// No description provided for @orders_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đơn đặt hàng'**
  String get orders_ucf;

  /// No description provided for @my_wishlist_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách yêu thích'**
  String get my_wishlist_ucf;

  /// No description provided for @messages_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get messages_ucf;

  /// No description provided for @wallet_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ví'**
  String get wallet_ucf;

  /// No description provided for @login_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login_ucf;

  /// No description provided for @logout_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout_ucf;

  /// No description provided for @mark_as_picked.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu như được chọn'**
  String get mark_as_picked;

  /// No description provided for @my_delivery_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giao hàng'**
  String get my_delivery_ucf;

  /// No description provided for @my_earnings_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thu nhập'**
  String get my_earnings_ucf;

  /// No description provided for @my_collection_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thu nhập'**
  String get my_collection_ucf;

  /// No description provided for @do_you_want_close_the_app.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có muốn đóng ứng dụng không?'**
  String get do_you_want_close_the_app;

  /// No description provided for @top_categories_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Top Danh mục'**
  String get top_categories_ucf;

  /// No description provided for @brands_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thương hiệu'**
  String get brands_ucf;

  /// No description provided for @top_sellers_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Top nhà bán hàng'**
  String get top_sellers_ucf;

  /// No description provided for @today_is_deal_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Today\'s Deal'**
  String get today_is_deal_ucf;

  /// No description provided for @flash_deal_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Flash Deal'**
  String get flash_deal_ucf;

  /// No description provided for @featured_categories_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục nổi bật'**
  String get featured_categories_ucf;

  /// No description provided for @featured_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm nổi bật'**
  String get featured_products_ucf;

  /// No description provided for @all_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả sản phẩm'**
  String get all_products_ucf;

  /// No description provided for @search_in_active_ecommerce_cms.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm ...'**
  String get search_in_active_ecommerce_cms;

  /// No description provided for @no_carousel_image_found.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy hình ảnh carousel'**
  String get no_carousel_image_found;

  /// No description provided for @no_category_found.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy danh mục'**
  String get no_category_found;

  /// No description provided for @categories_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục'**
  String get categories_ucf;

  /// No description provided for @view_subcategories_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xem các danh mục phụ'**
  String get view_subcategories_ucf;

  /// No description provided for @no_subcategories_available.
  ///
  /// In vi, this message translates to:
  /// **'Không có danh mục phụ có sẵn'**
  String get no_subcategories_available;

  /// No description provided for @all_products_of_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả sản phẩm của'**
  String get all_products_of_ucf;

  /// No description provided for @cannot_order_more_than.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đặt hàng nhiều hơn'**
  String get cannot_order_more_than;

  /// No description provided for @items_of_this_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'Mục này của điều này'**
  String get items_of_this_all_lower;

  /// No description provided for @are_you_sure_to_remove_this_item.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc chắn sẽ loại bỏ sản phẩm này không?'**
  String get are_you_sure_to_remove_this_item;

  /// No description provided for @cart_is_empty.
  ///
  /// In vi, this message translates to:
  /// **'Giỏ hàng trống'**
  String get cart_is_empty;

  /// No description provided for @total_amount_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số tiền'**
  String get total_amount_ucf;

  /// No description provided for @update_cart_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật giỏ hàng'**
  String get update_cart_ucf;

  /// No description provided for @proceed_to_shipping_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chọn giao hàng'**
  String get proceed_to_shipping_ucf;

  /// No description provided for @shopping_cart_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giỏ hàng'**
  String get shopping_cart_ucf;

  /// No description provided for @please_log_in_to_see_the_cart_items.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đăng nhập để xem các mục Giỏ hàng'**
  String get please_log_in_to_see_the_cart_items;

  /// No description provided for @cancel_request_is_already_send.
  ///
  /// In vi, this message translates to:
  /// **'Hủy yêu cầu đã được gửi'**
  String get cancel_request_is_already_send;

  /// No description provided for @classified_ads_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Quảng cáo rao vặt'**
  String get classified_ads_ucf;

  /// No description provided for @currency_change_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi tiền tệ'**
  String get currency_change_ucf;

  /// No description provided for @collection_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thu nhập'**
  String get collection_ucf;

  /// No description provided for @load_more_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tải nhiều hơn'**
  String get load_more_ucf;

  /// No description provided for @type_your_message_here.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tin nhắn của bạn ở đây ...'**
  String get type_your_message_here;

  /// No description provided for @enter_coupon_code.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã mã giảm giá'**
  String get enter_coupon_code;

  /// No description provided for @subtotal_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'Tạm tính'**
  String get subtotal_all_capital;

  /// No description provided for @tax_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'Thuế'**
  String get tax_all_capital;

  /// No description provided for @shipping_cost_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'Chi phí giao hàng'**
  String get shipping_cost_all_capital;

  /// No description provided for @discount_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'GIẢM GIÁ'**
  String get discount_all_capital;

  /// No description provided for @grand_total_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'TỔNG CỘNG'**
  String get grand_total_all_capital;

  /// No description provided for @coupon_code_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mã mã giảm giá'**
  String get coupon_code_ucf;

  /// No description provided for @apply_coupon_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng'**
  String get apply_coupon_all_capital;

  /// No description provided for @place_my_order_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'Đặt hàng'**
  String get place_my_order_all_capital;

  /// No description provided for @buy_package_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mua gói'**
  String get buy_package_ucf;

  /// No description provided for @remove_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get remove_ucf;

  /// No description provided for @checkout_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get checkout_ucf;

  /// No description provided for @cancelled_delivery_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy giao hàng'**
  String get cancelled_delivery_ucf;

  /// No description provided for @completed_delivery_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn thành giao hàng'**
  String get completed_delivery_ucf;

  /// No description provided for @search_products_from.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm sản phẩm từ'**
  String get search_products_from;

  /// No description provided for @no_language_is_added.
  ///
  /// In vi, this message translates to:
  /// **'Không có ngôn ngữ nào được thêm vào'**
  String get no_language_is_added;

  /// No description provided for @points_converted_to_wallet.
  ///
  /// In vi, this message translates to:
  /// **'Đổi điểm vào ví'**
  String get points_converted_to_wallet;

  /// No description provided for @show_wallet_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị ví'**
  String get show_wallet_all_capital;

  /// No description provided for @earned_points_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Điểm tích được'**
  String get earned_points_ucf;

  /// No description provided for @converted_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đã chuyển đổi'**
  String get converted_ucf;

  /// No description provided for @date_converted_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ngày chuyển đổi'**
  String get date_converted_ucf;

  /// No description provided for @status_converted_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái chuyển đổi'**
  String get status_converted_ucf;

  /// No description provided for @has_converted_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đã chuyển đổi'**
  String get has_converted_ucf;

  /// No description provided for @unconverted_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chưa chuyển đổi'**
  String get unconverted_ucf;

  /// No description provided for @done_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'HOÀN THÀNH'**
  String get done_all_capital;

  /// No description provided for @convert_now_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đổi điểm'**
  String get convert_now_ucf;

  /// No description provided for @my_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm'**
  String get my_products_ucf;

  /// No description provided for @current_package_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Gói hiện tại'**
  String get current_package_ucf;

  /// No description provided for @upgrade_package_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Gói nâng cấp'**
  String get upgrade_package_ucf;

  /// No description provided for @add_new_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thêm sản phẩm mới'**
  String get add_new_products_ucf;

  /// No description provided for @please_turn_on_your_internet_connection.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng bật kết nối Internet của bạn'**
  String get please_turn_on_your_internet_connection;

  /// No description provided for @please_log_in_to_see_the_profile.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đăng nhập để xem hồ sơ'**
  String get please_log_in_to_see_the_profile;

  /// No description provided for @notification_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get notification_ucf;

  /// No description provided for @purchase_history_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử mua hàng'**
  String get purchase_history_ucf;

  /// No description provided for @earning_points_history_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Kiếm tiền lịch sử điểm'**
  String get earning_points_history_ucf;

  /// No description provided for @refund_requests_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu hoàn tiền'**
  String get refund_requests_ucf;

  /// No description provided for @in_your_cart_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'trong giỏ hàng'**
  String get in_your_cart_all_lower;

  /// No description provided for @in_your_wishlist_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'trong danh sách yêu thích'**
  String get in_your_wishlist_all_lower;

  /// No description provided for @your_ordered_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'bạn đã đặt hàng'**
  String get your_ordered_all_lower;

  /// No description provided for @language_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language_ucf;

  /// No description provided for @currency_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tiền tệ'**
  String get currency_ucf;

  /// No description provided for @my_orders_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đơn đặt hàng'**
  String get my_orders_ucf;

  /// No description provided for @downloads_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tải xuống'**
  String get downloads_ucf;

  /// No description provided for @coupons_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu giảm giá'**
  String get coupons_ucf;

  /// No description provided for @favorite_seller_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Người bán yêu thích'**
  String get favorite_seller_ucf;

  /// No description provided for @all_digital_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả sản phẩm kỹ thuật số'**
  String get all_digital_products_ucf;

  /// No description provided for @on_auction_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Trên các sản phẩm đấu giá'**
  String get on_auction_products_ucf;

  /// No description provided for @bidded_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm đấu thầu'**
  String get bidded_products_ucf;

  /// No description provided for @wholesale_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm bán buôn'**
  String get wholesale_products_ucf;

  /// No description provided for @browse_all_sellers_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt tất cả nhà bán hàng'**
  String get browse_all_sellers_ucf;

  /// No description provided for @delete_my_account.
  ///
  /// In vi, this message translates to:
  /// **'Xóa tài khoản của tôi'**
  String get delete_my_account;

  /// No description provided for @delete_account_warning_title.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có muốn xóa tài khoản của mình khỏi hệ thống của chúng tôi không?'**
  String get delete_account_warning_title;

  /// No description provided for @delete_account_warning_description.
  ///
  /// In vi, this message translates to:
  /// **'Khi tài khoản của bạn bị xóa khỏi hệ thống của chúng tôi, bạn sẽ mất số dư và thông tin khác từ hệ thống của chúng tôi.'**
  String get delete_account_warning_description;

  /// No description provided for @blogs_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Blog'**
  String get blogs_ucf;

  /// No description provided for @check_balance_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra số dư'**
  String get check_balance_ucf;

  /// No description provided for @account_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get account_ucf;

  /// No description provided for @auction_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đấu giá'**
  String get auction_ucf;

  /// No description provided for @classified_products.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm phân loại'**
  String get classified_products;

  /// No description provided for @packages_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Gói'**
  String get packages_ucf;

  /// No description provided for @upload_limit_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giới hạn tải lên'**
  String get upload_limit_ucf;

  /// No description provided for @pending_delivery_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ giao hàng'**
  String get pending_delivery_ucf;

  /// No description provided for @flash_deal_has_ended.
  ///
  /// In vi, this message translates to:
  /// **'Thỏa thuận Flash đã kết thúc'**
  String get flash_deal_has_ended;

  /// No description provided for @ended_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đã kết thúc'**
  String get ended_ucf;

  /// No description provided for @flash_deals_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giao dịch flash'**
  String get flash_deals_ucf;

  /// No description provided for @top_selling_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm bán hàng hàng đầu'**
  String get top_selling_products_ucf;

  /// No description provided for @product_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm'**
  String get product_ucf;

  /// No description provided for @products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Các sản phẩm'**
  String get products_ucf;

  /// No description provided for @sellers_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Người bán'**
  String get sellers_ucf;

  /// No description provided for @you_can_use_filters_while_searching_for_products.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể sử dụng các bộ lọc trong khi tìm kiếm sản phẩm.'**
  String get you_can_use_filters_while_searching_for_products;

  /// No description provided for @filter_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Lọc'**
  String get filter_ucf;

  /// No description provided for @sort_products_by_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp sản phẩm theo'**
  String get sort_products_by_ucf;

  /// No description provided for @price_high_to_low.
  ///
  /// In vi, this message translates to:
  /// **'Giá cao đến thấp'**
  String get price_high_to_low;

  /// No description provided for @price_low_to_high.
  ///
  /// In vi, this message translates to:
  /// **'Giá thấp đến cao'**
  String get price_low_to_high;

  /// No description provided for @new_arrival_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đến mới'**
  String get new_arrival_ucf;

  /// No description provided for @popularity_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sự phổ biến'**
  String get popularity_ucf;

  /// No description provided for @top_rated_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xếp hạng hàng đầu'**
  String get top_rated_ucf;

  /// No description provided for @maximum_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tối đa'**
  String get maximum_ucf;

  /// No description provided for @minimum_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tối thiểu'**
  String get minimum_ucf;

  /// No description provided for @price_range_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Phạm vi giá'**
  String get price_range_ucf;

  /// No description provided for @search_here_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm ở đây?'**
  String get search_here_ucf;

  /// No description provided for @no_suggestion_available.
  ///
  /// In vi, this message translates to:
  /// **'Không có đề xuất nào có sẵn'**
  String get no_suggestion_available;

  /// No description provided for @searched_for_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'tìm kiếm'**
  String get searched_for_all_lower;

  /// No description provided for @times_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'thời gian'**
  String get times_all_lower;

  /// No description provided for @found_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'thành lập'**
  String get found_all_lower;

  /// No description provided for @loading_suggestions.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải đề xuất ...'**
  String get loading_suggestions;

  /// No description provided for @sort_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Loại'**
  String get sort_ucf;

  /// No description provided for @default_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mặc định'**
  String get default_ucf;

  /// No description provided for @you_can_use_sorting_while_searching_for_products.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể sử dụng phân loại trong khi tìm kiếm sản phẩm.'**
  String get you_can_use_sorting_while_searching_for_products;

  /// No description provided for @filter_screen_min_max_warning.
  ///
  /// In vi, this message translates to:
  /// **'Giá tối thiểu không thể lớn hơn giá tối đa'**
  String get filter_screen_min_max_warning;

  /// No description provided for @followed_sellers_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi nhà bán hàng'**
  String get followed_sellers_ucf;

  /// No description provided for @copy_product_link_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sao chép liên kết sản phẩm'**
  String get copy_product_link_ucf;

  /// No description provided for @share_options_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chọn chia sẻ'**
  String get share_options_ucf;

  /// No description provided for @title_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề'**
  String get title_ucf;

  /// No description provided for @enter_title_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tiêu đề'**
  String get enter_title_ucf;

  /// No description provided for @message_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn'**
  String get message_ucf;

  /// No description provided for @enter_message_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tin nhắn'**
  String get enter_message_ucf;

  /// No description provided for @title_or_message_empty_warning.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề hoặc tin nhắn không thể trống'**
  String get title_or_message_empty_warning;

  /// No description provided for @could_not_create_conversation.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tạo cuộc trò chuyện'**
  String get could_not_create_conversation;

  /// No description provided for @added_to_cart.
  ///
  /// In vi, this message translates to:
  /// **'Thêm giỏ hàng'**
  String get added_to_cart;

  /// No description provided for @show_cart_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị giỏ hàng'**
  String get show_cart_all_capital;

  /// No description provided for @description_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả:'**
  String get description_ucf;

  /// No description provided for @brand_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thương hiệu :'**
  String get brand_ucf;

  /// No description provided for @total_price_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tổng giá:'**
  String get total_price_ucf;

  /// No description provided for @price_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giá'**
  String get price_ucf;

  /// No description provided for @color_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Màu sắc'**
  String get color_ucf;

  /// No description provided for @seller_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Người bán'**
  String get seller_ucf;

  /// No description provided for @club_point_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Điểm'**
  String get club_point_ucf;

  /// No description provided for @total_club_point_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tổng điểm'**
  String get total_club_point_ucf;

  /// No description provided for @no_transaction_yet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có giao dịch'**
  String get no_transaction_yet;

  /// No description provided for @quantity_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng'**
  String get quantity_ucf;

  /// No description provided for @video_not_available.
  ///
  /// In vi, this message translates to:
  /// **'Video không có sẵn'**
  String get video_not_available;

  /// No description provided for @video_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Băng hình'**
  String get video_ucf;

  /// No description provided for @reviews_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá'**
  String get reviews_ucf;

  /// No description provided for @seller_policy_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách của nhà bán hàng'**
  String get seller_policy_ucf;

  /// No description provided for @return_policy_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách trả lại'**
  String get return_policy_ucf;

  /// No description provided for @support_policy_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách hỗ trợ'**
  String get support_policy_ucf;

  /// No description provided for @products_you_may_also_like.
  ///
  /// In vi, this message translates to:
  /// **'Thường xuyên mua sản phẩm'**
  String get products_you_may_also_like;

  /// No description provided for @other_ads_of_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Quảng cáo khác của'**
  String get other_ads_of_ucf;

  /// No description provided for @top_selling_products_from_seller.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm bán chạy nhất từ nhà bán hàng này'**
  String get top_selling_products_from_seller;

  /// No description provided for @chat_with_seller.
  ///
  /// In vi, this message translates to:
  /// **'Trò chuyện với nhà bán hàng'**
  String get chat_with_seller;

  /// No description provided for @available_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'có sẵn'**
  String get available_all_lower;

  /// No description provided for @add_to_cart_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thêm giỏ hàng'**
  String get add_to_cart_ucf;

  /// No description provided for @buy_now_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mua ngay'**
  String get buy_now_ucf;

  /// No description provided for @no_top_selling_products_from_this_seller.
  ///
  /// In vi, this message translates to:
  /// **'Không có sản phẩm bán hàng hàng đầu từ nhà bán hàng này'**
  String get no_top_selling_products_from_this_seller;

  /// No description provided for @no_related_product.
  ///
  /// In vi, this message translates to:
  /// **'Không có sản phẩm thường xuyên mua'**
  String get no_related_product;

  /// No description provided for @all_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get all_ucf;

  /// No description provided for @this_week_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tuần này'**
  String get this_week_ucf;

  /// No description provided for @this_month_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tháng này'**
  String get this_month_ucf;

  /// No description provided for @cod_ucf.
  ///
  /// In vi, this message translates to:
  /// **'COD'**
  String get cod_ucf;

  /// No description provided for @non_cod_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không phải COD'**
  String get non_cod_ucf;

  /// No description provided for @all_payments_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả phương thức thanh toán'**
  String get all_payments_ucf;

  /// No description provided for @all_deliveries_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả nhân viên giao hàng'**
  String get all_deliveries_ucf;

  /// No description provided for @paid_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đã thanh toán'**
  String get paid_ucf;

  /// No description provided for @unpaid_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chưa thanh toán'**
  String get unpaid_ucf;

  /// No description provided for @submitted_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi mã chuyển khoản'**
  String get submitted_ucf;

  /// No description provided for @search_order_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm đơn hàng'**
  String get search_order_ucf;

  /// No description provided for @confirmed_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirmed_ucf;

  /// No description provided for @on_the_way_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang giao hàng'**
  String get on_the_way_ucf;

  /// No description provided for @delivered_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đã giao hàng'**
  String get delivered_ucf;

  /// No description provided for @no_more_orders_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không còn đơn đặt hàng nữa'**
  String get no_more_orders_ucf;

  /// No description provided for @loading_more_orders_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải nhiều thứ tự hơn ...'**
  String get loading_more_orders_ucf;

  /// No description provided for @payment_status_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái thanh toán'**
  String get payment_status_ucf;

  /// No description provided for @delivery_status_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái giao hàng'**
  String get delivery_status_ucf;

  /// No description provided for @product_name_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tên sản phẩm'**
  String get product_name_ucf;

  /// No description provided for @product_unit_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đơn vị sản phẩm'**
  String get product_unit_ucf;

  /// No description provided for @order_code_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mã đặt hàng'**
  String get order_code_ucf;

  /// No description provided for @reason_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Lý do'**
  String get reason_ucf;

  /// No description provided for @reason_cannot_be_empty.
  ///
  /// In vi, this message translates to:
  /// **'Lý do không thể trống'**
  String get reason_cannot_be_empty;

  /// No description provided for @enter_reason_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lý do'**
  String get enter_reason_ucf;

  /// No description provided for @show_request_list_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hiển thị danh sách yêu cầu'**
  String get show_request_list_ucf;

  /// No description provided for @ordered_product_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đặt hàng sản phẩm'**
  String get ordered_product_ucf;

  /// No description provided for @no_item_ordered.
  ///
  /// In vi, this message translates to:
  /// **'Không có sản phẩm nào được đặt hàng'**
  String get no_item_ordered;

  /// No description provided for @sub_total_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'Tạm tính'**
  String get sub_total_all_capital;

  /// No description provided for @order_placed.
  ///
  /// In vi, this message translates to:
  /// **'Đặt hàng'**
  String get order_placed;

  /// No description provided for @shipping_method_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức giao hàng'**
  String get shipping_method_ucf;

  /// No description provided for @order_date_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ngày đặt hàng'**
  String get order_date_ucf;

  /// No description provided for @payment_method_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức thanh toán'**
  String get payment_method_ucf;

  /// No description provided for @shipping_address_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ giao hàng'**
  String get shipping_address_ucf;

  /// No description provided for @name_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get name_ucf;

  /// No description provided for @email_ucf.
  ///
  /// In vi, this message translates to:
  /// **'E-mail'**
  String get email_ucf;

  /// No description provided for @postal_code.
  ///
  /// In vi, this message translates to:
  /// **'Mã bưu điện'**
  String get postal_code;

  /// No description provided for @item_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'sản phẩm'**
  String get item_all_lower;

  /// No description provided for @ask_for_refund_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu hoàn tiền'**
  String get ask_for_refund_ucf;

  /// No description provided for @refund_status_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái hoàn tiền'**
  String get refund_status_ucf;

  /// No description provided for @order_details_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết đặt hàng'**
  String get order_details_ucf;

  /// No description provided for @make_offline_payment_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thực hiện thanh toán ngoại tuyến'**
  String get make_offline_payment_ucf;

  /// No description provided for @choose_an_address.
  ///
  /// In vi, this message translates to:
  /// **'Chọn một địa chỉ'**
  String get choose_an_address;

  /// No description provided for @choose_delivery_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chọn giao hàng'**
  String get choose_delivery_ucf;

  /// No description provided for @home_delivery_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giao hàng tận nơi'**
  String get home_delivery_ucf;

  /// No description provided for @choose_an_address_or_pickup_point.
  ///
  /// In vi, this message translates to:
  /// **'Chọn một địa chỉ hoặc điểm đón'**
  String get choose_an_address_or_pickup_point;

  /// No description provided for @to_add_or_edit_addresses_go_to_address_page.
  ///
  /// In vi, this message translates to:
  /// **'Để thêm hoặc chỉnh sửa địa chỉ, hãy truy cập trang địa chỉ'**
  String get to_add_or_edit_addresses_go_to_address_page;

  /// No description provided for @shipping_cost_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chi phí giao hàng'**
  String get shipping_cost_ucf;

  /// No description provided for @shipping_info.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin giao hàng'**
  String get shipping_info;

  /// No description provided for @carrier_points_is_unavailable_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Điểm giao hàng không khả dụng'**
  String get carrier_points_is_unavailable_ucf;

  /// No description provided for @carrier_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Người giao hàng'**
  String get carrier_ucf;

  /// No description provided for @proceed_to_checkout.
  ///
  /// In vi, this message translates to:
  /// **'Tiến hành thanh toán'**
  String get proceed_to_checkout;

  /// No description provided for @continue_to_delivery_info_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục thông tin giao hàng'**
  String get continue_to_delivery_info_ucf;

  /// No description provided for @pickup_point_is_unavailable_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Điểm đón không có sẵn'**
  String get pickup_point_is_unavailable_ucf;

  /// No description provided for @pickup_point_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Điểm đón'**
  String get pickup_point_ucf;

  /// No description provided for @mark_as_delivered.
  ///
  /// In vi, this message translates to:
  /// **'Đánh dấu như được giao'**
  String get mark_as_delivered;

  /// No description provided for @please_wait_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chờ...'**
  String get please_wait_ucf;

  /// No description provided for @remaining_uploads.
  ///
  /// In vi, this message translates to:
  /// **'Tải lên còn lại'**
  String get remaining_uploads;

  /// No description provided for @amount_cannot_be_empty.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền không thể trống'**
  String get amount_cannot_be_empty;

  /// No description provided for @my_wallet_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ví của tôi'**
  String get my_wallet_ucf;

  /// No description provided for @no_recharges_yet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có sạc lại'**
  String get no_recharges_yet;

  /// No description provided for @approval_status_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái phê duyệt'**
  String get approval_status_ucf;

  /// No description provided for @wallet_balance_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Số dư ví'**
  String get wallet_balance_ucf;

  /// No description provided for @last_recharged.
  ///
  /// In vi, this message translates to:
  /// **'Sạc mới nhất'**
  String get last_recharged;

  /// No description provided for @wallet_recharge_history_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ví Lịch sử nạp tiền'**
  String get wallet_recharge_history_ucf;

  /// No description provided for @amount_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền'**
  String get amount_ucf;

  /// No description provided for @enter_amount_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập số tiền'**
  String get enter_amount_ucf;

  /// No description provided for @wholesale_product.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm bán buôn'**
  String get wholesale_product;

  /// No description provided for @recharge_wallet_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sạc ví'**
  String get recharge_wallet_ucf;

  /// No description provided for @please_log_in_to_see_the_wishlist_items.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đăng nhập để xem các mục danh sách yêu thích'**
  String get please_log_in_to_see_the_wishlist_items;

  /// No description provided for @enter_email.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email'**
  String get enter_email;

  /// No description provided for @enter_phone_number.
  ///
  /// In vi, this message translates to:
  /// **'Nhập số điện thoại'**
  String get enter_phone_number;

  /// No description provided for @enter_password.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu'**
  String get enter_password;

  /// No description provided for @or_login_with_a_phone.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng số điện thoại'**
  String get or_login_with_a_phone;

  /// No description provided for @or_login_with_an_email.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập bằng một email'**
  String get or_login_with_an_email;

  /// No description provided for @password_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password_ucf;

  /// No description provided for @login_screen_phone.
  ///
  /// In vi, this message translates to:
  /// **'Điện thoại'**
  String get login_screen_phone;

  /// No description provided for @login_screen_forgot_password.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get login_screen_forgot_password;

  /// No description provided for @login_screen_log_in.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login_screen_log_in;

  /// No description provided for @login_screen_or_create_new_account.
  ///
  /// In vi, this message translates to:
  /// **'Hoặc, tạo một tài khoản mới?'**
  String get login_screen_or_create_new_account;

  /// No description provided for @login_screen_sign_up.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get login_screen_sign_up;

  /// No description provided for @login_screen_login_with.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập với'**
  String get login_screen_login_with;

  /// No description provided for @location_not_available.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí không có sẵn'**
  String get location_not_available;

  /// No description provided for @login_to.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập vào'**
  String get login_to;

  /// No description provided for @enter_your_name.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên của bạn'**
  String get enter_your_name;

  /// No description provided for @confirm_your_password.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu của bạn'**
  String get confirm_your_password;

  /// No description provided for @password_must_contain_at_least_6_characters.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải chứa ít nhất 6 ký tự'**
  String get password_must_contain_at_least_6_characters;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu không khớp'**
  String get passwords_do_not_match;

  /// No description provided for @join_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tham gia'**
  String get join_ucf;

  /// No description provided for @retype_password_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhận lại mật khẩu'**
  String get retype_password_ucf;

  /// No description provided for @or_register_with_a_phone.
  ///
  /// In vi, this message translates to:
  /// **'Hoặc, đăng ký bằng số điện thoại'**
  String get or_register_with_a_phone;

  /// No description provided for @or_register_with_an_email.
  ///
  /// In vi, this message translates to:
  /// **'Hoặc, đăng ký bằng một email'**
  String get or_register_with_an_email;

  /// No description provided for @sign_up_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get sign_up_ucf;

  /// No description provided for @already_have_an_account.
  ///
  /// In vi, this message translates to:
  /// **'Đã có một tài khoản?'**
  String get already_have_an_account;

  /// No description provided for @log_in.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get log_in;

  /// No description provided for @requested_for_cancellation.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu hủy bỏ'**
  String get requested_for_cancellation;

  /// No description provided for @forget_password_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forget_password_ucf;

  /// No description provided for @or_send_code_via_phone_number.
  ///
  /// In vi, this message translates to:
  /// **'Hoặc, gửi mã qua số điện thoại'**
  String get or_send_code_via_phone_number;

  /// No description provided for @or_send_code_via_email.
  ///
  /// In vi, this message translates to:
  /// **'Hoặc, gửi mã qua email'**
  String get or_send_code_via_email;

  /// No description provided for @send_code_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Gửi mã'**
  String get send_code_ucf;

  /// No description provided for @enter_verification_code.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã xác minh'**
  String get enter_verification_code;

  /// No description provided for @verify_your.
  ///
  /// In vi, this message translates to:
  /// **'Xác minh của bạn'**
  String get verify_your;

  /// No description provided for @email_account_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản email'**
  String get email_account_ucf;

  /// No description provided for @phone_number_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get phone_number_ucf;

  /// No description provided for @enter_the_verification_code_that_sent_to_your_email_recently.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã xác minh được gửi đến email của bạn gần đây.'**
  String get enter_the_verification_code_that_sent_to_your_email_recently;

  /// No description provided for @enter_the_verification_code_that_sent_to_your_phone_recently.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã xác minh được gửi đến điện thoại của bạn gần đây.'**
  String get enter_the_verification_code_that_sent_to_your_phone_recently;

  /// No description provided for @resend_code_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Resend mã'**
  String get resend_code_ucf;

  /// No description provided for @enter_the_code.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã'**
  String get enter_the_code;

  /// No description provided for @enter_the_code_sent.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã đã gửi'**
  String get enter_the_code_sent;

  /// No description provided for @congratulations_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chúc mừng !!'**
  String get congratulations_ucf;

  /// No description provided for @you_have_successfully_changed_your_password.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã thay đổi thành công mật khẩu của mình'**
  String get you_have_successfully_changed_your_password;

  /// No description provided for @password_changed_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu đã thay đổi'**
  String get password_changed_ucf;

  /// No description provided for @back_to_Login_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại để đăng nhập'**
  String get back_to_Login_ucf;

  /// No description provided for @cart_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giỏ hàng'**
  String get cart_ucf;

  /// No description provided for @fetching_nagad_url.
  ///
  /// In vi, this message translates to:
  /// **'Tìm nạp url nagad ...'**
  String get fetching_nagad_url;

  /// No description provided for @pay_with_nagad.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền với Nagad'**
  String get pay_with_nagad;

  /// No description provided for @pay_with_iyzico.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền với Iyzico'**
  String get pay_with_iyzico;

  /// No description provided for @if_you_are_finding_any_problem_while_logging_in.
  ///
  /// In vi, this message translates to:
  /// **'Nếu bạn đang tìm thấy bất kỳ vấn đề nào trong khi đăng nhập, vui lòng liên hệ với quản trị viên'**
  String get if_you_are_finding_any_problem_while_logging_in;

  /// No description provided for @fetching_paypal_url.
  ///
  /// In vi, this message translates to:
  /// **'Tìm nạp url paypal ...'**
  String get fetching_paypal_url;

  /// No description provided for @fetching_amarpay_url.
  ///
  /// In vi, this message translates to:
  /// **'Tìm nạp url amarpay ...'**
  String get fetching_amarpay_url;

  /// No description provided for @pay_with_paypal.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền với PayPal'**
  String get pay_with_paypal;

  /// No description provided for @pay_with_paystack.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền với Paystack'**
  String get pay_with_paystack;

  /// No description provided for @pay_with_paytm.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền với Paytm'**
  String get pay_with_paytm;

  /// No description provided for @pay_with_razorpay.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền với dao cạo'**
  String get pay_with_razorpay;

  /// No description provided for @pay_with_amarpay.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền với Amarpay'**
  String get pay_with_amarpay;

  /// No description provided for @pay_with_instamojo.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền với Instamojo'**
  String get pay_with_instamojo;

  /// No description provided for @fetching_sslcommerz_url.
  ///
  /// In vi, this message translates to:
  /// **'Tìm nạp URL SSLCommerz ...'**
  String get fetching_sslcommerz_url;

  /// No description provided for @pay_with_sslcommerz.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền với SSLCommerz'**
  String get pay_with_sslcommerz;

  /// No description provided for @pay_with_stripe.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền bằng sọc'**
  String get pay_with_stripe;

  /// No description provided for @pay_with_payfast.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền với Payfast'**
  String get pay_with_payfast;

  /// No description provided for @pay_with_phonepay.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán bằng Phonepay'**
  String get pay_with_phonepay;

  /// No description provided for @pay_with_my_fatoora.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền với Myfatoora'**
  String get pay_with_my_fatoora;

  /// No description provided for @your_delivery_location.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí giao hàng của bạn. '**
  String get your_delivery_location;

  /// No description provided for @calculating.
  ///
  /// In vi, this message translates to:
  /// **'Tính toán ...'**
  String get calculating;

  /// No description provided for @pick_here.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ở đây'**
  String get pick_here;

  /// No description provided for @amount_name_and_transaction_id_are_necessary.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng, tên và id giao dịch là bắt buộc'**
  String get amount_name_and_transaction_id_are_necessary;

  /// No description provided for @photo_proof_is_necessary.
  ///
  /// In vi, this message translates to:
  /// **'Hình ảnh giao dịch là bắt buộc'**
  String get photo_proof_is_necessary;

  /// No description provided for @all_marked_fields_are_mandatory.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả * các trường được đánh dấu là bắt buộc'**
  String get all_marked_fields_are_mandatory;

  /// No description provided for @correctly_fill_up_the_necessary_information.
  ///
  /// In vi, this message translates to:
  /// **'Điền chính xác các thông tin bắt buộc. '**
  String get correctly_fill_up_the_necessary_information;

  /// No description provided for @transaction_id_ucf.
  ///
  /// In vi, this message translates to:
  /// **'ID giao dịch'**
  String get transaction_id_ucf;

  /// No description provided for @photo_proof_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hình ảnh giao dịch'**
  String get photo_proof_ucf;

  /// No description provided for @only_image_file_allowed.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ được cho phép hình ảnh'**
  String get only_image_file_allowed;

  /// No description provided for @offline_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ngoại tuyến'**
  String get offline_ucf;

  /// No description provided for @type_your_review_here.
  ///
  /// In vi, this message translates to:
  /// **'Nhập đánh giá của bạn ở đây ...'**
  String get type_your_review_here;

  /// No description provided for @no_more_reviews_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không có thêm đánh giá'**
  String get no_more_reviews_ucf;

  /// No description provided for @loading_more_reviews_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải nhiều đánh giá hơn ...'**
  String get loading_more_reviews_ucf;

  /// No description provided for @no_reviews_yet_be_the_first.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có đánh giá nào. '**
  String get no_reviews_yet_be_the_first;

  /// No description provided for @you_need_to_login_to_give_a_review.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cần đăng nhập để đưa ra đánh giá'**
  String get you_need_to_login_to_give_a_review;

  /// No description provided for @review_can_not_empty_warning.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá không thể trống'**
  String get review_can_not_empty_warning;

  /// No description provided for @at_least_one_star_must_be_given.
  ///
  /// In vi, this message translates to:
  /// **'Ít nhất một ngôi sao phải được cung cấp'**
  String get at_least_one_star_must_be_given;

  /// No description provided for @password_changes_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thay đổi mật khẩu'**
  String get password_changes_ucf;

  /// No description provided for @basic_information_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cơ bản'**
  String get basic_information_ucf;

  /// No description provided for @new_password_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới'**
  String get new_password_ucf;

  /// No description provided for @update_profile_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật hồ sơ'**
  String get update_profile_ucf;

  /// No description provided for @update_password_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật mật khẩu'**
  String get update_password_ucf;

  /// No description provided for @edit_profile_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hồ sơ'**
  String get edit_profile_ucf;

  /// No description provided for @picked_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chọn'**
  String get picked_ucf;

  /// No description provided for @top_selling_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Bán hàng đầu'**
  String get top_selling_ucf;

  /// No description provided for @store_home_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ nhà'**
  String get store_home_ucf;

  /// No description provided for @new_arrivals_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm mới đến'**
  String get new_arrivals_products_ucf;

  /// No description provided for @no_featured_product_is_available_from_this_seller.
  ///
  /// In vi, this message translates to:
  /// **'Không có sản phẩm nổi bật nào có sẵn từ nhà bán hàng này'**
  String get no_featured_product_is_available_from_this_seller;

  /// No description provided for @no_new_arrivals.
  ///
  /// In vi, this message translates to:
  /// **'Không có người mới đến'**
  String get no_new_arrivals;

  /// No description provided for @view_all_products_prom_this_seller_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả các sản phẩm từ nhà bán hàng này'**
  String get view_all_products_prom_this_seller_all_capital;

  /// No description provided for @search_products_of_shop.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm sản phẩm của cửa hàng'**
  String get search_products_of_shop;

  /// No description provided for @today_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get today_ucf;

  /// No description provided for @total_collected_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số thu thập'**
  String get total_collected_ucf;

  /// No description provided for @yesterday_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hôm qua'**
  String get yesterday_ucf;

  /// No description provided for @your_app_is_now.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng của bạn bây giờ là'**
  String get your_app_is_now;

  /// No description provided for @you_are_currently_offline.
  ///
  /// In vi, this message translates to:
  /// **'Bạn hiện đang ngoại tuyến'**
  String get you_are_currently_offline;

  /// No description provided for @view_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xem sản phẩm'**
  String get view_products_ucf;

  /// No description provided for @pending_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ xử lý'**
  String get pending_ucf;

  /// No description provided for @picked_up_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhặt lên'**
  String get picked_up_ucf;

  /// No description provided for @money_withdraw_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Rút tiền'**
  String get money_withdraw_ucf;

  /// No description provided for @payment_history_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử thanh toán'**
  String get payment_history_ucf;

  /// No description provided for @add_new_coupon_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thêm mã giảm giá mới'**
  String get add_new_coupon_ucf;

  /// No description provided for @coupon_label_text.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mã giảm giá'**
  String get coupon_label_text;

  /// No description provided for @warning_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo!'**
  String get warning_ucf;

  /// No description provided for @coupon_code_is_empty_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mã mã giảm giá trống'**
  String get coupon_code_is_empty_ucf;

  /// No description provided for @discount_amount_is_invalid_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền chiết khấu không hợp lệ'**
  String get discount_amount_is_invalid_ucf;

  /// No description provided for @please_select_minimum_1_product_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng chọn tối thiểu 1 sản phẩm'**
  String get please_select_minimum_1_product_ucf;

  /// No description provided for @invalid_minimum_shopping_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mua sắm tối thiểu không hợp lệ'**
  String get invalid_minimum_shopping_ucf;

  /// No description provided for @invalid_maximum_discount_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giảm giá tối đa không hợp lệ'**
  String get invalid_maximum_discount_ucf;

  /// No description provided for @edit_coupon_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa mã giảm giá'**
  String get edit_coupon_ucf;

  /// No description provided for @save_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save_ucf;

  /// No description provided for @discount_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giảm giá'**
  String get discount_ucf;

  /// No description provided for @add_your_coupon_code_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thêm mã mã giảm giá của bạn'**
  String get add_your_coupon_code_ucf;

  /// No description provided for @minimum_shopping_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mua sắm tối thiểu'**
  String get minimum_shopping_ucf;

  /// No description provided for @maximum_discount_amount_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền chiết khấu tối đa'**
  String get maximum_discount_amount_ucf;

  /// No description provided for @coupon_information_adding.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin mã giảm giá thêm'**
  String get coupon_information_adding;

  /// No description provided for @select_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chọn sản phẩm'**
  String get select_products_ucf;

  /// No description provided for @offline_payment_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán ngoại tuyến'**
  String get offline_payment_ucf;

  /// No description provided for @youtube_ucf.
  ///
  /// In vi, this message translates to:
  /// **'YouTube'**
  String get youtube_ucf;

  /// No description provided for @dailymotion_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Dailymotion'**
  String get dailymotion_ucf;

  /// No description provided for @vimeo_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Vimeo'**
  String get vimeo_ucf;

  /// No description provided for @save_n_unpublish_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Lưu & không xuất bản'**
  String get save_n_unpublish_ucf;

  /// No description provided for @save_n_publish_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Lưu & Xuất bản'**
  String get save_n_publish_ucf;

  /// No description provided for @product_information_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin sản phẩm'**
  String get product_information_ucf;

  /// No description provided for @unit_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đơn vị'**
  String get unit_ucf;

  /// No description provided for @unit_eg_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đơn vị (ví dụ: kg, pc, v.v.)'**
  String get unit_eg_ucf;

  /// No description provided for @weight_in_kg_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Trọng lượng (tính bằng kg)'**
  String get weight_in_kg_ucf;

  /// No description provided for @minimum_purchase_quantity_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng mua tối thiểu'**
  String get minimum_purchase_quantity_ucf;

  /// No description provided for @tags_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thẻ'**
  String get tags_ucf;

  /// No description provided for @type_and_hit_enter_to_add_a_tag_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập và nhấn Enter để thêm thẻ'**
  String get type_and_hit_enter_to_add_a_tag_ucf;

  /// No description provided for @barcode_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mã vạch'**
  String get barcode_ucf;

  /// No description provided for @refundable_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Được hoàn trả'**
  String get refundable_ucf;

  /// No description provided for @product_description_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả sản phẩm'**
  String get product_description_ucf;

  /// No description provided for @cash_on_delivery_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán khi giao hàng'**
  String get cash_on_delivery_ucf;

  /// No description provided for @vat_n_tax_ucf.
  ///
  /// In vi, this message translates to:
  /// **'VAT & Thuế'**
  String get vat_n_tax_ucf;

  /// No description provided for @product_images_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hình ảnh sản phẩm'**
  String get product_images_ucf;

  /// No description provided for @thumbnail_image_300_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hình ảnh thu nhỏ (300x300)'**
  String get thumbnail_image_300_ucf;

  /// No description provided for @thumbnail_image_300_des.
  ///
  /// In vi, this message translates to:
  /// **'Những hình ảnh này có thể nhìn thấy trong tất cả các hộp sản phẩm. '**
  String get thumbnail_image_300_des;

  /// No description provided for @product_videos_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Video sản phẩm'**
  String get product_videos_ucf;

  /// No description provided for @video_provider_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhà cung cấp video'**
  String get video_provider_ucf;

  /// No description provided for @video_link_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết video'**
  String get video_link_ucf;

  /// No description provided for @video_link_des.
  ///
  /// In vi, this message translates to:
  /// **'Sử dụng liên kết thích hợp mà không cần tham số thêm. '**
  String get video_link_des;

  /// No description provided for @pdf_description_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả PDF'**
  String get pdf_description_ucf;

  /// No description provided for @pdf_specification_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thành phần PDF'**
  String get pdf_specification_ucf;

  /// No description provided for @discount_date_range_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng thời gian giảm giá'**
  String get discount_date_range_ucf;

  /// No description provided for @sku_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'SKU'**
  String get sku_all_capital;

  /// No description provided for @external_link_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết bên ngoài'**
  String get external_link_ucf;

  /// No description provided for @leave_it_blank_if_you_do_not_use_external_site_link.
  ///
  /// In vi, this message translates to:
  /// **'Để trống nếu bạn không sử dụng liên kết trang web bên ngoài'**
  String get leave_it_blank_if_you_do_not_use_external_site_link;

  /// No description provided for @external_link_button_text_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Văn bản nút liên kết bên ngoài'**
  String get external_link_button_text_ucf;

  /// No description provided for @low_stock_quantity_warning_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cảnh báo số lượng tồn kho thấp'**
  String get low_stock_quantity_warning_ucf;

  /// No description provided for @stock_visibility_state_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái hiển thị tồn kho'**
  String get stock_visibility_state_ucf;

  /// No description provided for @product_variation_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Biến thể sản phẩm'**
  String get product_variation_ucf;

  /// No description provided for @colors_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Màu sắc'**
  String get colors_ucf;

  /// No description provided for @attributes_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thuộc tính'**
  String get attributes_ucf;

  /// No description provided for @seo_all_capital.
  ///
  /// In vi, this message translates to:
  /// **'SEO'**
  String get seo_all_capital;

  /// No description provided for @meta_title_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề meta'**
  String get meta_title_ucf;

  /// No description provided for @meta_image_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hình ảnh meta'**
  String get meta_image_ucf;

  /// No description provided for @shipping_configuration_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cấu hình giao hàng'**
  String get shipping_configuration_ucf;

  /// No description provided for @shipping_configuration_is_maintained_by_admin.
  ///
  /// In vi, this message translates to:
  /// **'Cấu hình giao hàng được duy trì bởi quản trị viên.'**
  String get shipping_configuration_is_maintained_by_admin;

  /// No description provided for @estimate_shipping_time_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ước tính thời gian giao hàng'**
  String get estimate_shipping_time_ucf;

  /// No description provided for @shipping_days_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ngày giao hàng'**
  String get shipping_days_ucf;

  /// No description provided for @gallery_images_600.
  ///
  /// In vi, this message translates to:
  /// **'Hình ảnh bộ sưu tập (600x600)'**
  String get gallery_images_600;

  /// No description provided for @these_images_are_visible_in_product_details_page_gallery_600.
  ///
  /// In vi, this message translates to:
  /// **'Những hình ảnh này có thể nhìn thấy trong bộ sưu tập trang chi tiết sản phẩm. '**
  String get these_images_are_visible_in_product_details_page_gallery_600;

  /// No description provided for @photo_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ảnh'**
  String get photo_ucf;

  /// No description provided for @general_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get general_ucf;

  /// No description provided for @media_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đa phương tiện'**
  String get media_ucf;

  /// No description provided for @price_n_stock_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giá & tồn kho'**
  String get price_n_stock_ucf;

  /// No description provided for @shipping_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giao hàng'**
  String get shipping_ucf;

  /// No description provided for @add_new_product_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thêm sản phẩm mới'**
  String get add_new_product_ucf;

  /// No description provided for @product_reviews_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đánh giá sản phẩm'**
  String get product_reviews_ucf;

  /// No description provided for @update_now_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật ngay bây giờ'**
  String get update_now_ucf;

  /// No description provided for @slug_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Slug'**
  String get slug_ucf;

  /// No description provided for @update_product_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật sản phẩm'**
  String get update_product_ucf;

  /// No description provided for @shop_banner_image_is_required.
  ///
  /// In vi, this message translates to:
  /// **'Hình ảnh biểu ngữ cửa hàng là bắt buộc.'**
  String get shop_banner_image_is_required;

  /// No description provided for @banner_settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt biểu ngữ'**
  String get banner_settings;

  /// No description provided for @banner_1500_x_450.
  ///
  /// In vi, this message translates to:
  /// **'Biểu ngữ (1500 x 450)'**
  String get banner_1500_x_450;

  /// No description provided for @banner_1500_x_450_des.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi đã phải giới hạn chiều cao để duy trì tính nhất quán. '**
  String get banner_1500_x_450_des;

  /// No description provided for @delivery_boy_pickup_point.
  ///
  /// In vi, this message translates to:
  /// **'Điểm giao nhận của nhân viên giao hàng'**
  String get delivery_boy_pickup_point;

  /// No description provided for @longitude_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Kinh độ'**
  String get longitude_ucf;

  /// No description provided for @latitude_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Vĩ độ'**
  String get latitude_ucf;

  /// No description provided for @update_location.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật vị trí'**
  String get update_location;

  /// No description provided for @location_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí'**
  String get location_ucf;

  /// No description provided for @calculating_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tính toán'**
  String get calculating_ucf;

  /// No description provided for @pick_here_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ở đây'**
  String get pick_here_ucf;

  /// No description provided for @shop_name_is_required.
  ///
  /// In vi, this message translates to:
  /// **'Tên cửa hàng được yêu cầu'**
  String get shop_name_is_required;

  /// No description provided for @shop_phone_is_required.
  ///
  /// In vi, this message translates to:
  /// **'Điện thoại cửa hàng được yêu cầu'**
  String get shop_phone_is_required;

  /// No description provided for @shop_address_is_required.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ cửa hàng là bắt buộc'**
  String get shop_address_is_required;

  /// No description provided for @shop_title_is_required.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề cửa hàng là bắt buộc'**
  String get shop_title_is_required;

  /// No description provided for @shop_description_is_required.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả cửa hàng là bắt buộc'**
  String get shop_description_is_required;

  /// No description provided for @shop_logo_is_required.
  ///
  /// In vi, this message translates to:
  /// **'Logo cửa hàng được yêu cầu'**
  String get shop_logo_is_required;

  /// No description provided for @general_setting_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt chung'**
  String get general_setting_ucf;

  /// No description provided for @shop_description.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả cửa hàng'**
  String get shop_description;

  /// No description provided for @shop_title.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu đề cửa hàng'**
  String get shop_title;

  /// No description provided for @shop_phone.
  ///
  /// In vi, this message translates to:
  /// **'Cửa hàng điện thoại'**
  String get shop_phone;

  /// No description provided for @shop_address.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ cửa hàng'**
  String get shop_address;

  /// No description provided for @shop_name_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tên cửa hàng'**
  String get shop_name_ucf;

  /// No description provided for @shop_logo_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Logo mua sắm'**
  String get shop_logo_ucf;

  /// No description provided for @shop_settings_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt cửa hàng'**
  String get shop_settings_ucf;

  /// No description provided for @social_media_link.
  ///
  /// In vi, this message translates to:
  /// **'Liên kết truyền thông xã hội'**
  String get social_media_link;

  /// No description provided for @google_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Google'**
  String get google_ucf;

  /// No description provided for @twitter_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Twitter'**
  String get twitter_ucf;

  /// No description provided for @instagram_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Instagram'**
  String get instagram_ucf;

  /// No description provided for @facebook_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Facebook'**
  String get facebook_ucf;

  /// No description provided for @upload_file_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tải lên tập tin'**
  String get upload_file_ucf;

  /// No description provided for @commission_history_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử hoa hồng'**
  String get commission_history_ucf;

  /// No description provided for @chat_list.
  ///
  /// In vi, this message translates to:
  /// **'Danh sách trò chuyện'**
  String get chat_list;

  /// No description provided for @admin_commission_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Quản trị hoa hồng'**
  String get admin_commission_ucf;

  /// No description provided for @create_a_ticket.
  ///
  /// In vi, this message translates to:
  /// **'Tạo một vé'**
  String get create_a_ticket;

  /// No description provided for @subject_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chủ đề'**
  String get subject_ucf;

  /// No description provided for @provide_a_detailed_description.
  ///
  /// In vi, this message translates to:
  /// **'Cung cấp mô tả chi tiết'**
  String get provide_a_detailed_description;

  /// No description provided for @send_ticket.
  ///
  /// In vi, this message translates to:
  /// **'Gửi vé'**
  String get send_ticket;

  /// No description provided for @top_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm hàng đầu'**
  String get top_products_ucf;

  /// No description provided for @your_categories_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Danh mục của bạn'**
  String get your_categories_ucf;

  /// No description provided for @sales_stat_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ số bán hàng'**
  String get sales_stat_ucf;

  /// No description provided for @product_upload_limit_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giới hạn tải lên sản phẩm:'**
  String get product_upload_limit_ucf;

  /// No description provided for @package_expires_at_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Gói hết hạn tại:'**
  String get package_expires_at_ucf;

  /// No description provided for @manage_n_organize_your_shop.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý & Tổ chức\n'**
  String get manage_n_organize_your_shop;

  /// No description provided for @configure_your_payment_method.
  ///
  /// In vi, this message translates to:
  /// **'Định cấu hình thanh toán của bạn\n'**
  String get configure_your_payment_method;

  /// No description provided for @configure_now_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cấu hình ngay bây giờ'**
  String get configure_now_ucf;

  /// No description provided for @go_to_settings.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển đến Cài đặt'**
  String get go_to_settings;

  /// No description provided for @payment_settings_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt thanh toán'**
  String get payment_settings_ucf;

  /// No description provided for @rating_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xếp hạng'**
  String get rating_ucf;

  /// No description provided for @total_orders_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số đơn đặt hàng'**
  String get total_orders_ucf;

  /// No description provided for @total_sales_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tổng doanh số'**
  String get total_sales_ucf;

  /// No description provided for @hi_welcome_to_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'Xin chào, Chào mừng bạn đến'**
  String get hi_welcome_to_all_lower;

  /// No description provided for @login_to_your_account_all_lower.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập vào tài khoản của bạn'**
  String get login_to_your_account_all_lower;

  /// No description provided for @in_case_of_any_difficulties_contact_with_admin.
  ///
  /// In vi, this message translates to:
  /// **'Trong trường hợp có bất kỳ khó khăn, liên hệ với quản trị viên.'**
  String get in_case_of_any_difficulties_contact_with_admin;

  /// No description provided for @pending_balance_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Số dư đang chờ xử lý'**
  String get pending_balance_ucf;

  /// No description provided for @send_withdraw_request_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu rút tiền'**
  String get send_withdraw_request_ucf;

  /// No description provided for @premium_package_for_seller_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Gói cao cấp cho nhà bán hàng'**
  String get premium_package_for_seller_ucf;

  /// No description provided for @select_payment_type_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chọn hình thức thanh toán'**
  String get select_payment_type_ucf;

  /// No description provided for @select_payment_option_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tùy chọn thanh toán'**
  String get select_payment_option_ucf;

  /// No description provided for @enter_phone_number_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập số điện thoại'**
  String get enter_phone_number_ucf;

  /// No description provided for @we_will_send_you_a_OTP_code_if_the_mail_id_is_correct_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi sẽ gửi cho bạn một mã OTP nếu ID thư là chính xác.'**
  String get we_will_send_you_a_OTP_code_if_the_mail_id_is_correct_ucf;

  /// No description provided for @we_will_send_you_a_OTP_code_if_the_phone_no_is_correct_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chúng tôi sẽ gửi cho bạn mã OTP nếu điện thoại không đúng.'**
  String get we_will_send_you_a_OTP_code_if_the_phone_no_is_correct_ucf;

  /// No description provided for @reset_password_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đặt lại mật khẩu'**
  String get reset_password_ucf;

  /// No description provided for @bank_payment.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán ngân hàng'**
  String get bank_payment;

  /// No description provided for @cash_payment.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán bằng tiền mặt'**
  String get cash_payment;

  /// No description provided for @bank_account_number.
  ///
  /// In vi, this message translates to:
  /// **'Số tài khoản ngân hàng'**
  String get bank_account_number;

  /// No description provided for @bank_account_name.
  ///
  /// In vi, this message translates to:
  /// **'Tên tài khoản ngân hàng'**
  String get bank_account_name;

  /// No description provided for @bank_name_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tên ngân hàng'**
  String get bank_name_ucf;

  /// No description provided for @bank_routing_number_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Số định tuyến ngân hàng'**
  String get bank_routing_number_ucf;

  /// No description provided for @no_more_refund_requests_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không còn yêu cầu hoàn tiền'**
  String get no_more_refund_requests_ucf;

  /// No description provided for @approved_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tán thành'**
  String get approved_ucf;

  /// No description provided for @approve_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chấp thuận'**
  String get approve_ucf;

  /// No description provided for @rejected_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Vật bị loại bỏ'**
  String get rejected_ucf;

  /// No description provided for @reject_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get reject_ucf;

  /// No description provided for @support_tickets_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hỗ trợ vé'**
  String get support_tickets_ucf;

  /// No description provided for @options_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tùy chọn'**
  String get options_ucf;

  /// No description provided for @amount_is_invalid.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền không hợp lệ'**
  String get amount_is_invalid;

  /// No description provided for @message_is_invalid.
  ///
  /// In vi, this message translates to:
  /// **'Tin nhắn không hợp lệ'**
  String get message_is_invalid;

  /// No description provided for @coupon_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu giảm giá'**
  String get coupon_ucf;

  /// No description provided for @withdraw_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Rút'**
  String get withdraw_ucf;

  /// No description provided for @conversation_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Cuộc hội thoại'**
  String get conversation_ucf;

  /// No description provided for @wholesale_prices_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giá bán buôn'**
  String get wholesale_prices_ucf;

  /// No description provided for @min_quantity_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng tối thiểu'**
  String get min_quantity_ucf;

  /// No description provided for @max_quantity_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Số lượng tối đa'**
  String get max_quantity_ucf;

  /// No description provided for @add_more_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thêm nhiều hơn'**
  String get add_more_ucf;

  /// No description provided for @or.
  ///
  /// In vi, this message translates to:
  /// **'HOẶC'**
  String get or;

  /// No description provided for @registration.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get registration;

  /// No description provided for @be_a_seller.
  ///
  /// In vi, this message translates to:
  /// **'Là nhà bán hàng'**
  String get be_a_seller;

  /// No description provided for @personal_info_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cá nhân'**
  String get personal_info_ucf;

  /// No description provided for @basic_info_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cơ bản'**
  String get basic_info_ucf;

  /// No description provided for @shop_name.
  ///
  /// In vi, this message translates to:
  /// **'Tên cửa hàng'**
  String get shop_name;

  /// No description provided for @ok.
  ///
  /// In vi, this message translates to:
  /// **'ĐỒNG Ý'**
  String get ok;

  /// No description provided for @verify_now.
  ///
  /// In vi, this message translates to:
  /// **'Xác minh ngay bây giờ'**
  String get verify_now;

  /// No description provided for @verify_your_account.
  ///
  /// In vi, this message translates to:
  /// **'Xác minh tài khoản của bạn'**
  String get verify_your_account;

  /// No description provided for @your_account_is_unverified.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản của bạn chưa được xác minh'**
  String get your_account_is_unverified;

  /// No description provided for @verification_form_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mẫu xác minh'**
  String get verification_form_ucf;

  /// No description provided for @cancel_order_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng hủy'**
  String get cancel_order_ucf;

  /// No description provided for @re_order_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sắp xếp lại'**
  String get re_order_ucf;

  /// No description provided for @info_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin'**
  String get info_ucf;

  /// No description provided for @min_qty_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tối thiểu QTY'**
  String get min_qty_ucf;

  /// No description provided for @max_qty_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tối đa qty'**
  String get max_qty_ucf;

  /// No description provided for @unit_price_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đơn giá'**
  String get unit_price_ucf;

  /// No description provided for @invoice_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hóa đơn'**
  String get invoice_ucf;

  /// No description provided for @no_file_chosen_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không có tập tin được chọn'**
  String get no_file_chosen_ucf;

  /// No description provided for @product_file_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tệp sản phẩm'**
  String get product_file_ucf;

  /// No description provided for @purchase_price_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giá mua'**
  String get purchase_price_ucf;

  /// No description provided for @digital_product_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm kỹ thuật số'**
  String get digital_product_ucf;

  /// No description provided for @refunded_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn lại tiền'**
  String get refunded_ucf;

  /// No description provided for @bid_for_product_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Giá thầu cho sản phẩm'**
  String get bid_for_product_ucf;

  /// No description provided for @min_bid_amount_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Số tiền tối thiểu'**
  String get min_bid_amount_ucf;

  /// No description provided for @place_bid_price_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đặt giá thầu'**
  String get place_bid_price_ucf;

  /// No description provided for @please_fill_out_this_form.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng điền vào biểu mẫu này'**
  String get please_fill_out_this_form;

  /// No description provided for @value_must_be_greater.
  ///
  /// In vi, this message translates to:
  /// **'Giá trị phải lớn hơn\n '**
  String get value_must_be_greater;

  /// No description provided for @value_must_be_greater_or_equal.
  ///
  /// In vi, this message translates to:
  /// **'Giá trị phải lớn hơn\n '**
  String get value_must_be_greater_or_equal;

  /// No description provided for @seller_dashboard_support_ticket_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Vé hỗ trợ'**
  String get seller_dashboard_support_ticket_ucf;

  /// No description provided for @view_a_ticket.
  ///
  /// In vi, this message translates to:
  /// **'Xem một vé'**
  String get view_a_ticket;

  /// No description provided for @visit_store_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Ghé thăm cửa hàng'**
  String get visit_store_ucf;

  /// No description provided for @off.
  ///
  /// In vi, this message translates to:
  /// **'Giảm'**
  String get off;

  /// No description provided for @min_spend_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiêu tối thiểu'**
  String get min_spend_ucf;

  /// No description provided for @from.
  ///
  /// In vi, this message translates to:
  /// **'Từ'**
  String get from;

  /// No description provided for @store_to_get.
  ///
  /// In vi, this message translates to:
  /// **'Lưu trữ để có được'**
  String get store_to_get;

  /// No description provided for @off_on_total_orders.
  ///
  /// In vi, this message translates to:
  /// **'Giảm trên tổng đơn đặt hàng'**
  String get off_on_total_orders;

  /// No description provided for @code.
  ///
  /// In vi, this message translates to:
  /// **'Mã số'**
  String get code;

  /// No description provided for @in_house_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm'**
  String get in_house_products_ucf;

  /// No description provided for @coupon_products_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu giảm giá sản phẩm'**
  String get coupon_products_ucf;

  /// No description provided for @loading_coupons_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải mã giảm giá ...'**
  String get loading_coupons_ucf;

  /// No description provided for @no_more_coupons_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không còn mã giảm giá'**
  String get no_more_coupons_ucf;

  /// No description provided for @address_required.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ bắt buộc'**
  String get address_required;

  /// No description provided for @country_required.
  ///
  /// In vi, this message translates to:
  /// **'Tên quốc gia bắt buộc'**
  String get country_required;

  /// No description provided for @state_required.
  ///
  /// In vi, this message translates to:
  /// **'Tên nhà nước bắt buộc'**
  String get state_required;

  /// No description provided for @city_required.
  ///
  /// In vi, this message translates to:
  /// **'Tên thành phố bắt buộc'**
  String get city_required;

  /// No description provided for @postal_code_required.
  ///
  /// In vi, this message translates to:
  /// **'Mã bưu điện bắt buộc'**
  String get postal_code_required;

  /// No description provided for @phone_number_required.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại bắt buộc'**
  String get phone_number_required;

  /// No description provided for @select_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Lựa chọn'**
  String get select_ucf;

  /// No description provided for @pos_manager.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý POS'**
  String get pos_manager;

  /// No description provided for @sub_total.
  ///
  /// In vi, this message translates to:
  /// **'Tạm tính'**
  String get sub_total;

  /// No description provided for @tax.
  ///
  /// In vi, this message translates to:
  /// **'Thuế'**
  String get tax;

  /// No description provided for @total.
  ///
  /// In vi, this message translates to:
  /// **'Tổng cộng'**
  String get total;

  /// No description provided for @shipping.
  ///
  /// In vi, this message translates to:
  /// **'Giao hàng'**
  String get shipping;

  /// No description provided for @place_order.
  ///
  /// In vi, this message translates to:
  /// **'Đặt hàng'**
  String get place_order;

  /// No description provided for @no_customer_info.
  ///
  /// In vi, this message translates to:
  /// **'Không có thông tin khách hàng được chọn.'**
  String get no_customer_info;

  /// No description provided for @confirm_with_cash.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận bằng tiền mặt'**
  String get confirm_with_cash;

  /// No description provided for @order_summery.
  ///
  /// In vi, this message translates to:
  /// **'Đơn đặt hàng mùa hè'**
  String get order_summery;

  /// No description provided for @offline_payment_info.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin thanh toán ngoại tuyến'**
  String get offline_payment_info;

  /// No description provided for @payment_proof.
  ///
  /// In vi, this message translates to:
  /// **'Bằng chứng thanh toán'**
  String get payment_proof;

  /// No description provided for @add_new_address.
  ///
  /// In vi, this message translates to:
  /// **'Thêm địa chỉ mới.'**
  String get add_new_address;

  /// No description provided for @back_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get back_ucf;

  /// No description provided for @no_notification_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thông báo!'**
  String get no_notification_ucf;

  /// No description provided for @already_have_account.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã có một tài khoản với thông tin này. '**
  String get already_have_account;

  /// No description provided for @add_new_classified_product_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thêm sản phẩm được phân loại mới'**
  String get add_new_classified_product_ucf;

  /// No description provided for @condition_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản'**
  String get condition_ucf;

  /// No description provided for @descriptions_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả'**
  String get descriptions_ucf;

  /// No description provided for @thumbnail_image_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Hình ảnh hình thu nhỏ'**
  String get thumbnail_image_ucf;

  /// No description provided for @video_form_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mẫu video'**
  String get video_form_ucf;

  /// No description provided for @video_url_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Video URL'**
  String get video_url_ucf;

  /// No description provided for @document.
  ///
  /// In vi, this message translates to:
  /// **'tài liệu'**
  String get document;

  /// No description provided for @choose_file.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tập tin'**
  String get choose_file;

  /// No description provided for @browse.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt'**
  String get browse;

  /// No description provided for @custom_unit_price_and_base_price.
  ///
  /// In vi, this message translates to:
  /// **'Đơn giá (giá cơ sở)'**
  String get custom_unit_price_and_base_price;

  /// No description provided for @meta_tags_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thẻ meta'**
  String get meta_tags_ucf;

  /// No description provided for @meta_description_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả meta'**
  String get meta_description_ucf;

  /// No description provided for @save_product_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Lưu sản phẩm'**
  String get save_product_ucf;

  /// No description provided for @type_and_hit_submit_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Nhập và nhấn gửi'**
  String get type_and_hit_submit_ucf;

  /// No description provided for @gallery_images.
  ///
  /// In vi, this message translates to:
  /// **'Hình ảnh bộ sưu tập'**
  String get gallery_images;

  /// No description provided for @product_name_required.
  ///
  /// In vi, this message translates to:
  /// **'Tên sản phẩm bắt buộc'**
  String get product_name_required;

  /// No description provided for @name_required.
  ///
  /// In vi, this message translates to:
  /// **'Tên bắt buộc'**
  String get name_required;

  /// No description provided for @email_required.
  ///
  /// In vi, this message translates to:
  /// **'Email bắt buộc'**
  String get email_required;

  /// No description provided for @product_unit_required.
  ///
  /// In vi, this message translates to:
  /// **'Đơn vị sản phẩm bắt buộc'**
  String get product_unit_required;

  /// No description provided for @location_required.
  ///
  /// In vi, this message translates to:
  /// **'Vị trí bắt buộc'**
  String get location_required;

  /// No description provided for @product_tag_required.
  ///
  /// In vi, this message translates to:
  /// **'Thẻ sản phẩm bắt buộc'**
  String get product_tag_required;

  /// No description provided for @product_description_required.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu mô tả sản phẩm'**
  String get product_description_required;

  /// No description provided for @classified_product_limit_expired.
  ///
  /// In vi, this message translates to:
  /// **'Giới hạn tải lên sản phẩm phân loại của bạn đã đạt được. '**
  String get classified_product_limit_expired;

  /// No description provided for @status_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái'**
  String get status_ucf;

  /// No description provided for @published_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xuất bản'**
  String get published_ucf;

  /// No description provided for @unpublished_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Chưa xuất bản'**
  String get unpublished_ucf;

  /// No description provided for @loading_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải'**
  String get loading_ucf;

  /// No description provided for @enter_correct_email.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email chính xác'**
  String get enter_correct_email;

  /// No description provided for @shipping_address_required.
  ///
  /// In vi, this message translates to:
  /// **'Địa chỉ giao hàng bắt buộc'**
  String get shipping_address_required;

  /// No description provided for @existing_email_address.
  ///
  /// In vi, this message translates to:
  /// **'Nếu bạn đã sử dụng cùng một địa chỉ thư hoặc số điện thoại trước đây, vui lòng'**
  String get existing_email_address;

  /// No description provided for @first_to_continue.
  ///
  /// In vi, this message translates to:
  /// **'Đầu tiên để tiếp tục!'**
  String get first_to_continue;

  /// No description provided for @pay_with_flutterwave.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền với Flutterwave'**
  String get pay_with_flutterwave;

  /// No description provided for @pay_with_khalti.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán tiền với Khalti'**
  String get pay_with_khalti;

  /// No description provided for @pirated_app.
  ///
  /// In vi, this message translates to:
  /// **'Đây là một ứng dụng lậu. '**
  String get pirated_app;

  /// No description provided for @login_or_reg.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập/Đăng ký'**
  String get login_or_reg;

  /// No description provided for @make_payment_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Thực hiện thanh toán'**
  String get make_payment_ucf;

  /// No description provided for @last_view_product_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Sản phẩm mới'**
  String get last_view_product_ucf;

  /// No description provided for @delete_selection.
  ///
  /// In vi, this message translates to:
  /// **'Xóa lựa chọn'**
  String get delete_selection;

  /// No description provided for @select_all.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tất cả'**
  String get select_all;

  /// No description provided for @nothing_selected.
  ///
  /// In vi, this message translates to:
  /// **'Không có gì được chọn'**
  String get nothing_selected;

  /// No description provided for @your_order.
  ///
  /// In vi, this message translates to:
  /// **'Đơn đặt hàng'**
  String get your_order;

  /// No description provided for @has_been.
  ///
  /// In vi, this message translates to:
  /// **'đã được'**
  String get has_been;

  /// No description provided for @view_more.
  ///
  /// In vi, this message translates to:
  /// **'Xem thêm ...'**
  String get view_more;

  /// No description provided for @less.
  ///
  /// In vi, this message translates to:
  /// **'Ít hơn'**
  String get less;

  /// No description provided for @all_blogs_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả blog'**
  String get all_blogs_ucf;

  /// No description provided for @a.
  ///
  /// In vi, this message translates to:
  /// **''**
  String get a;

  /// No description provided for @out_stock.
  ///
  /// In vi, this message translates to:
  /// **'Hết hàng'**
  String get out_stock;

  /// No description provided for @status_placed.
  ///
  /// In vi, this message translates to:
  /// **'đặt hàng thành công'**
  String get status_placed;

  /// No description provided for @status_confirmed.
  ///
  /// In vi, this message translates to:
  /// **'xác nhận'**
  String get status_confirmed;

  /// No description provided for @status_on_delivery.
  ///
  /// In vi, this message translates to:
  /// **'giao hàng'**
  String get status_on_delivery;

  /// No description provided for @status_delivered.
  ///
  /// In vi, this message translates to:
  /// **'giao hàng thành công'**
  String get status_delivered;

  /// No description provided for @status_cancelled.
  ///
  /// In vi, this message translates to:
  /// **'huỷ thành công'**
  String get status_cancelled;

  /// No description provided for @status_pending.
  ///
  /// In vi, this message translates to:
  /// **'chờ xử lý'**
  String get status_pending;

  /// No description provided for @view_all_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get view_all_ucf;

  /// No description provided for @payment_cod.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán khi nhận hàng'**
  String get payment_cod;

  /// No description provided for @payment_wallet.
  ///
  /// In vi, this message translates to:
  /// **'Ví điện tử'**
  String get payment_wallet;

  /// No description provided for @payment_bank_transfer.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển khoản ngân hàng'**
  String get payment_bank_transfer;

  /// No description provided for @refresh_ucf.
  ///
  /// In vi, this message translates to:
  /// **'Làm mới'**
  String get refresh_ucf;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
