import 'package:haxuvina/custom/toast_component.dart';
import 'package:haxuvina/data_model/cart_response.dart';
import 'package:haxuvina/helpers/system_config.dart';
import 'package:haxuvina/presenter/cart_counter.dart';
import 'package:haxuvina/repositories/cart_repository.dart';
import 'package:flutter/material.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../custom/aiz_route.dart';
import '../custom/btn.dart';
import '../helpers/main_helpers.dart';
import '../helpers/shared_value_helper.dart';
import '../my_theme.dart';
import '../repositories/shipping_repository.dart';
import '../screens/checkout/select_address.dart';
import '../screens/guest_checkout_pages/guest_checkout_address.dart';

class CartProvider extends ChangeNotifier {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _mainScrollController = ScrollController();
  List<CartItem> _cartItems = [];
  CartResponse? _cartResponse;
  bool _isInitial = true;
  double _cartTotal = 0.00;
  String _cartTotalString = ". . .";
  String _shippingCostString = ". . .";
  double _shippingCost = 0.00;
  double get shippingCost => _shippingCost;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  ScrollController get mainScrollController => _mainScrollController;
  List<CartItem> get cartItems => _cartItems;
  CartResponse? get cartResponse => _cartResponse;
  bool get isInitial => _isInitial;
  double get cartTotal => _cartTotal;
  String get cartTotalString => _cartTotalString;
  String get shippingCostString => formatCurrency(_shippingCost);


  // Thêm đây:
  double get totalWithShipping => _cartTotal;
  String get totalWithShippingString => formatCurrency(totalWithShipping);

  void initState(BuildContext context) {
    print("🧩 [CartProvider] initState đang chạy");
    fetchDataAndShipping(context);
  }

  Future<void> fetchDataAndShipping(BuildContext context) async {
    print("📦 Gọi fetchData()");
    await fetchData(context);

    print("🚚 Gọi fetchShippingCost()");
    await fetchShippingCost(context);
  }

  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  Future<void> fetchData(BuildContext context) async {
    getCartCount(context);
    CartResponse cartResponseList =
    await CartRepository().getCartResponseList(user_id.$);

    if (cartResponseList.cartItems != null &&
        cartResponseList.cartItems!.isNotEmpty) {
      _cartItems = cartResponseList.cartItems!;
      _cartResponse = cartResponseList;
      getSetCartTotal();

      // ➕ THÊM LOG Ở ĐÂY:
      print("🛒 Tổng sp trong giỏ: ${_cartItems.length}");
      print("🛒 Grand total: ${_cartResponse!.grandTotal}");
      for (var item in _cartItems) {
        print("🛒 - ${item.productName} x${item.quantity}");
      }
    }

    _isInitial = false;
    notifyListeners();
  }

  void getCartCount(BuildContext context) {
    Provider.of<CartCounter>(context, listen: false).getCount();
  }

  void getSetCartTotal() {
    _cartTotalString = _cartResponse!.grandTotal!
        .replaceAll(SystemConfig.systemCurrency!.code!, SystemConfig.systemCurrency!.symbol!);

    _cartTotal = parseCurrencyToInt(_cartResponse!.grandTotal!).toDouble(); // <-- thêm dòng này

    notifyListeners();
  }

  void onQuantityIncrease(BuildContext context, int itemIndex) {
    if (_cartItems[itemIndex].quantity! < _cartItems[itemIndex].upperLimit!) {
      _cartItems[itemIndex].quantity = _cartItems[itemIndex].quantity! + 1;
      notifyListeners();
      process(context, mode: "update");
    } else {
      ToastComponent.showDialog(
          "${AppLocalizations.of(context)!.cannot_order_more_than} ${_cartItems[itemIndex].upperLimit} ${AppLocalizations.of(context)!.items_of_this_all_lower}",
          gravity: ToastGravity.CENTER,
          duration: Toast.LENGTH_LONG);
    }
  }

  void onQuantityDecrease(BuildContext context, int itemIndex) {
    if (_cartItems[itemIndex].quantity! > _cartItems[itemIndex].lowerLimit!) {
      _cartItems[itemIndex].quantity = _cartItems[itemIndex].quantity! - 1;
      notifyListeners();
      process(context, mode: "update");
    } else {
      ToastComponent.showDialog(
        "${AppLocalizations.of(context)!.cannot_order_more_than} ${_cartItems[itemIndex].lowerLimit} ${AppLocalizations.of(context)!.items_of_this_all_lower}",
      );
    }
  }

  void onPressDelete(BuildContext context, String cartId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        contentPadding:
            EdgeInsets.only(top: 30.0, left: 2.0, right: 2.0, bottom: 20.0),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            AppLocalizations.of(context)!.are_you_sure_to_remove_this_item,
            maxLines: 3,
            style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
          ),
        ),
        actions: [
          Btn.basic(
            child: Text(
              AppLocalizations.of(context)!.cancel_ucf,
              style: TextStyle(color: MyTheme.medium_grey),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          Btn.basic(
            color: MyTheme.soft_accent_color,
            child: Text(
              AppLocalizations.of(context)!.confirm_ucf,
              style: TextStyle(color: MyTheme.dark_grey),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              confirmDelete(context, cartId);
            },
          ),
        ],
      ),
    );
  }

  void confirmDelete(BuildContext context, String cartId) async {
    var cartDeleteResponse =
        await CartRepository().getCartDeleteResponse(int.parse(cartId));

    if (cartDeleteResponse.result == true) {
      ToastComponent.showDialog(
        cartDeleteResponse.message,
      );
      reset();
      fetchData(context);
    } else {
      ToastComponent.showDialog(
        cartDeleteResponse.message,
      );
    }
  }

  void onPressUpdate(BuildContext context) {
    process(context, mode: "update");
  }

  void onPressProceedToShipping(BuildContext context) {
    process(context, mode: "proceed_to_shipping");
  }

  void process(BuildContext context, {required String mode}) async {
    var cartIds = [];
    var cartQuantities = [];
    if (_cartItems.isNotEmpty) {
      for (var cartItem in _cartItems) {
        cartIds.add(cartItem.id);
        cartQuantities.add(cartItem.quantity);
      }
    }

    if (cartIds.length == 0) {
      ToastComponent.showDialog(
        AppLocalizations.of(context)!.cart_is_empty,
      );
      return;
    }

    var cartIdsString = cartIds.join(',').toString();
    var cartQuantitiesString = cartQuantities.join(',').toString();

    var cartProcessResponse = await CartRepository()
        .getCartProcessResponse(cartIdsString, cartQuantitiesString);

    if (cartProcessResponse.result == false) {
      ToastComponent.showDialog(
        cartProcessResponse.message,
      );
    } else {
      if (mode == "update") {
        await fetchData(context);
        await fetchShippingCost(context);
      } else if (mode == "proceed_to_shipping") {
        if (guest_checkout_status.$ && !is_logged_in.$) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return GuestCheckoutAddress();
          }));
        } else {
          final result = await AIZRoute.push(context, SelectAddress());
          onPopped(context, result);

          if (result == 'account_created') {
            // 🔄 Gọi lại fetchData, fetchShippingCost, hoặc cập nhật UI
            await fetchData(context);
            await fetchShippingCost(context);
            notifyListeners(); // nếu bạn muốn cập nhật UI thông qua provider
          }
        }
      }
    }
  }

  void reset() {
    _cartItems.clear();
    _isInitial = true;
    _cartTotal = 0.00;
    _cartTotalString = ". . .";
    notifyListeners();
  }

  Future<void> onRefresh(BuildContext context) async {
    reset();
    fetchData(context);
  }

  void onPopped(BuildContext context, dynamic value) {
    reset();
    fetchData(context).then((_) {
      fetchShippingCost(context); // <- GỌI LẠI SHIPPING Ở ĐÂY
    });
  }

  Future<void> fetchShippingCost(BuildContext context) async {
    print("📦 [DEBUG] Vào fetchShippingCost");

    try {
      print("📡 Gọi getCartSummaryResponse...");
      final summary = await CartRepository().getCartSummaryResponse();
      print("🧾 Response summary: $summary");

      if (summary != null) {
        print("🔎 shipping_cost: ${summary.shipping_cost}");
        print("🔎 grand_total: ${summary.grand_total}");
        // ❌ Đừng dùng dòng này nếu không có trường đó:
        // print("🔎 coupon_discount: ${summary.coupon_discount}");

        _shippingCost = parseCurrencyToInt(summary.shipping_cost).toDouble();
        double rawTotal = summary.grand_total_value ?? parseCurrencyToInt(summary.grand_total).toDouble();

        _cartTotal = rawTotal;

        print("💵 Tổng tiền sau giảm giá + shipping: $_cartTotal");
        notifyListeners();
      } else {
        print("⚠️ summary == null");
        ToastComponent.showDialog("Không thể lấy thông tin giỏ hàng");
      }
    } catch (e, s) {
      print("❌ Lỗi khi fetchShippingCost: $e");
      print("🪵 StackTrace: $s");
      ToastComponent.showDialog("Không thể lấy thông tin giỏ hàng");
    }
  }

  // Helper
  double extractNumber(String input) {
    return double.tryParse(input.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
  }

}
