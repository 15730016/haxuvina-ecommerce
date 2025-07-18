import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:haxuvina/custom/btn.dart';
import 'package:haxuvina/custom/enum_classes.dart';
import 'package:haxuvina/custom/lang_text.dart';
import 'package:haxuvina/custom/toast_component.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/helpers/shimmer_helper.dart';
import 'package:haxuvina/helpers/system_config.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/repositories/cart_repository.dart';
import 'package:haxuvina/repositories/coupon_repository.dart';
import 'package:haxuvina/repositories/payment_repository.dart';
import 'package:haxuvina/screens/orders/order_list.dart';
import 'package:flutter/material.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:one_context/one_context.dart';

import '../../custom/loading.dart';
import '../../helpers/auth_helper.dart';
import '../../helpers/main_helpers.dart';
import '../../helpers/payment_helper.dart';
import '../../repositories/guest_checkout_repository.dart';
import '../../repositories/wallet_repository.dart';
import '../coupon/coupons.dart';
import '../guest_checkout_pages/guest_checkout_address.dart';

class Checkout extends StatefulWidget {
  final int? order_id; // only need when making manual payment from order details
  final String list;
  final PaymentFor? paymentFor;
  final double rechargeAmount;
  final String? title;
  final String? guestCheckOutShippingAddress;

  Checkout({
    Key? key,
    this.guestCheckOutShippingAddress,
    this.order_id = 0,
    this.paymentFor,
    this.list = "both",
    this.rechargeAmount = 0.0,
    this.title,
  }) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _selected_payment_method_index = 0;
  String? _selected_payment_method = "";
  String? _selected_payment_method_key = "";

  ScrollController _mainScrollController = ScrollController();
  TextEditingController _couponController = TextEditingController();
  var _paymentTypeList = [];
  bool _isInitial = true;
  String? _totalString = ". . .";
  double? _grandTotalValue = 0.00;
  String? _subTotalString = ". . .";
  String? _taxString = ". . .";
  String _shippingCostString = ". . .";
  String? _discountString = ". . .";
  String _used_coupon_code = "";
  bool? _coupon_applied = false;
  late BuildContext loadingcontext;
  String payment_type = "cart_payment";
  String? _title;

  double? _walletBalance;

  @override
  void initState() {
    super.initState();
    print("🟡 Checkout.initState() được gọi");
    if (is_logged_in.$) {
      fetchWalletBalance(); // 🟢 Chỉ fetch nếu đã login
    }
    fetchAll();
  }

  Future<void> fetchWalletBalance() async {
    print("🧪 Gọi fetchWalletBalance()");
    try {
      final res = await WalletRepository().getBalance();
      print("📦 Wallet API response: ${res.toJson()}");

      final rawBalance = res.balance.replaceAll(RegExp(r'[^\d.]'), '');
      final parsedBalance = double.tryParse(rawBalance);
      print("✅ Số dư sau xử lý: $parsedBalance");

      setState(() {
        _walletBalance = parsedBalance;
      });
    } catch (e) {
      print("❌ Lỗi khi gọi fetchWalletBalance(): $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  String balance() {
    if (widget.paymentFor == PaymentFor.OrderRePayment) {
      final rechargeText = convertPrice(widget.rechargeAmount.toInt().toString());
      print("📤 balance (recharge): $rechargeText");
      return rechargeText;
    }

    final displayText = _totalString ?? ". . .";
    print("📤 balance (_totalString): $displayText");
    return displayText;
  }

  fetchAll() {
    fetchList();
    if (widget.paymentFor == PaymentFor.Order) {
      fetchSummary();
    } else {
      _grandTotalValue = widget.rechargeAmount; // ✅ không cần gọi balance() để gán nữa
      if (widget.paymentFor == PaymentFor.OrderRePayment) {
        payment_type = 'order_re_payment';
      }
    }
  }

  fetchList() async {
    String mode = (widget.paymentFor == PaymentFor.Order || widget.paymentFor == PaymentFor.OrderRePayment)
        ? "order"
        : "wallet";

    var paymentTypeResponseList = await PaymentRepository()
        .getPaymentResponseList(list: widget.list, mode: mode);

    _paymentTypeList.clear();

    print("🔍 Danh sách ban đầu: ${paymentTypeResponseList.map((e) => e.payment_type).toList()}");

    // ✅ Nếu là thanh toán lại thì không cho phép COD
    if (widget.paymentFor == PaymentFor.OrderRePayment) {
      paymentTypeResponseList = paymentTypeResponseList
          .where((item) => item.payment_type != 'cash_payment')
          .toList();
      print("🔧 Đã lọc bỏ COD vì là thanh toán lại");
    }

    // ✅ Nếu là guest (chưa đăng nhập), không cho thanh toán bằng ví
    if (!is_logged_in.$) {
      paymentTypeResponseList = paymentTypeResponseList
          .where((item) => item.payment_type != 'wallet_system')
          .toList();
      print("🔧 Guest checkout - ẩn ví");
    }

    print("✅ Danh sách phương thức cuối cùng: ${paymentTypeResponseList.map((e) => e.payment_type).toList()}");

    _paymentTypeList.addAll(paymentTypeResponseList);

    if (_paymentTypeList.isNotEmpty) {
      _selected_payment_method = _paymentTypeList[0].payment_type;
      _selected_payment_method_key = _paymentTypeList[0].payment_type_key;
    }

    _isInitial = false;
    setState(() {});
  }

  fetchSummary() async {
    var cartSummaryResponse = await CartRepository().getCartSummaryResponse();

    if (cartSummaryResponse != null) {
      _subTotalString = cartSummaryResponse.sub_total;
      _taxString = cartSummaryResponse.tax;
      _shippingCostString = cartSummaryResponse.shipping_cost;
      _discountString = cartSummaryResponse.discount;
      _totalString = cartSummaryResponse.grand_total;

// 👇 Chỉ parse 1 lần duy nhất ở đây
      _grandTotalValue = cartSummaryResponse.grand_total_value ?? 0.00;

      print("📥 fetchSummary() set _grandTotalValue = $_grandTotalValue");

      _used_coupon_code = cartSummaryResponse.coupon_code ?? _used_coupon_code;
      _couponController.text = _used_coupon_code;
      _coupon_applied = cartSummaryResponse.coupon_applied;
      setState(() {});
    }
  }

  reset() {
    _paymentTypeList.clear();
    _isInitial = true;
    _selected_payment_method_index = 0;
    _selected_payment_method = "";
    _selected_payment_method_key = "";
    reset_summary();
    setState(() {});
  }

  reset_summary() {
    _totalString = ". . .";
    _grandTotalValue = 0.00;
    _subTotalString = ". . .";
    _taxString = ". . .";
    _shippingCostString = ". . .";
    _discountString = ". . .";
    _used_coupon_code = "";
    _couponController.text = _used_coupon_code;
    _coupon_applied = false;
    setState(() {});
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  onPopped(value) {
    reset();
    fetchAll();
  }

  onCouponApply() async {
    var coupon_code = _couponController.text.toString();
    if (coupon_code.isEmpty) {
      ToastComponent.showDialog(AppLocalizations.of(context)!.enter_coupon_code);
      return;
    }

    var couponApplyResponse =
    await CouponRepository().getCouponApplyResponse(coupon_code);
    if (!couponApplyResponse.result) {
      ToastComponent.showDialog(couponApplyResponse.message);
      return;
    }
    fetchSummary();
  }

  onCouponRemove() async {
    var couponRemoveResponse =
    await CouponRepository().getCouponRemoveResponse();

    if (!couponRemoveResponse.result) {
      ToastComponent.showDialog(couponRemoveResponse.message);
      return;
    }
    fetchSummary();
  }

  onPressPlaceOrderOrProceed() async {
    print("💳 onPressPlaceOrderOrProceed:");
    print("- Selected payment: $_selected_payment_method ($_selected_payment_method_key)");
    print("- paymentFor: ${widget.paymentFor}");
    print("- _grandTotalValue = $_grandTotalValue");
    if (guest_checkout_status.$ && !is_logged_in.$) {
      Loading.show(context);
      var guestUserAccountCreateResponse = await GuestCheckoutRepository()
          .guestUserAccountCreate(widget.guestCheckOutShippingAddress);
      Loading.close();

      if (guestUserAccountCreateResponse.result!) {
        AuthHelper().setUserData(guestUserAccountCreateResponse);
        // 👇 Gọi cập nhật lại địa chỉ cho Cart
        await CartRepository().updateAddressForCart(); // bạn sẽ tạo hàm này

        // Sau đó gọi fetch lại thông tin đơn hàng nếu cần
        await fetchSummary();
      } else {
        ToastComponent.showDialog(LangText(context).local.already_have_account);
        Navigator.pushAndRemoveUntil(OneContext().context!,
            MaterialPageRoute(builder: (context) => GuestCheckoutAddress()),
                (Route<dynamic> route) => false);
        return;
      }
    }

    if (_selected_payment_method == null || _selected_payment_method!.isEmpty) {
      print("🔍 Đã chọn phương thức: $_selected_payment_method ($_selected_payment_method_key)");
      ToastComponent.showDialog(AppLocalizations.of(context)!.please_choose_one_option_to_pay);
      return;
    }

    if (_grandTotalValue == 0.00 && widget.paymentFor == PaymentFor.Order) {
      print("🧾 Kiểm tra tổng thanh toán: $_grandTotalValue, paymentFor: ${widget.paymentFor}");
      ToastComponent.showDialog(AppLocalizations.of(context)!.nothing_to_pay);
      return;
    }

    print("💳 Gọi thanh toán với: $_selected_payment_method ($_selected_payment_method_key)");

    switch(_selected_payment_method) {
      case "wallet_system":
        print("🟣 Chọn phương thức thanh toán là Ví");
        await pay_by_wallet();
        break;
      case "cash_payment":
        pay_by_cod();
        break;
      case "bank":
        pay_by_bank();
        break;
      default:
        ToastComponent.showDialog("Selected payment method is not supported.");
        break;
    }
  }

  pay_by_wallet() async {
    print("🟢 pay_by_wallet: Bắt đầu thanh toán ví");

    try {
      final orderCreateResponse = await PaymentRepository()
          .getOrderCreateResponseFromWallet(_selected_payment_method_key, _grandTotalValue);

      print("📥 Response từ API ví: $orderCreateResponse");
      print("📥 Ví response: result=${orderCreateResponse.result}, message=${orderCreateResponse.message}");

      if (orderCreateResponse == null || orderCreateResponse.result == null) {
        print("❌ orderCreateResponse null hoặc result null");
        ToastComponent.showDialog(orderCreateResponse?.message ?? "Lỗi không xác định từ hệ thống");
        return;
      }

      // ✅ Đợi animation kết thúc
      await Future.delayed(Duration(milliseconds: 100));
      print("⏱ Đã đợi 100ms để animation hoàn tất");

      if (orderCreateResponse.result == false) {
        print("❌ Thanh toán thất bại: ${orderCreateResponse.message}");

        if (orderCreateResponse.message?.toLowerCase().contains("insufficient wallet") == true && _walletBalance != null) {
          ToastComponent.showDialog(
            "Thanh toán thất bại do số dư ví không đủ.\n"
                "Số dư hiện tại: ${convertPrice(_walletBalance.toString())}\n"
                "Tổng cần thanh toán: ${convertPrice(_grandTotalValue.toString())}",
          );
        } else {
          ToastComponent.showDialog(orderCreateResponse.message ?? "Thanh toán thất bại");
        }

        return;
      }

      print("✅ Thanh toán thành công, chuyển đến OrderList");

      context.push(
        '/purchase_history/details/${orderCreateResponse.order_id}',
        extra: {'go_back': false}, // nếu không muốn có nút back
      );
    } catch (e) {
      print("🚨 Lỗi khi gọi API ví: $e");
      ToastComponent.showDialog("Đã xảy ra lỗi khi thanh toán bằng ví.");
    }
  }

  pay_by_cod() async {
    print("🟡 pay_by_cod: Bắt đầu...");

    loading(); // show dialog
    print("🟡 pay_by_cod: Hiển thị loading");

    final response = await PaymentRepository()
        .getOrderCreateResponseFromCod(_selected_payment_method_key);

    print("🟢 pay_by_cod: Nhận được phản hồi từ API");
    print("ℹ️ response.result = ${response.result}");
    print("ℹ️ response.message = ${response.message}");

    Navigator.pop(context); // đóng dialog
    print("🟢 pay_by_cod: Đã đóng loading dialog");

    // ✅ Đợi animation kết thúc
    await Future.delayed(Duration(milliseconds: 100));
    print("⏱ Đã đợi 100ms để animation hoàn tất");

    if (response.result != true) {
      ToastComponent.showDialog(response.message ?? "Đặt hàng thất bại");
      return;
    }

    final orderId = response.order_id;
    if (orderId == null) {
      ToastComponent.showDialog("Không lấy được mã đơn hàng");
      return;
    }

    print("✅ pay_by_cod: Đặt hàng thành công, chuyển trang");

    // 👉 Chuyển đến chi tiết đơn hàng theo chuẩn GoRouter
    context.push(
      '/purchase_history/details/${response.order_id}',
      extra: {'go_back': false}, // nếu không muốn có nút back
    );
  }

  pay_by_bank() async {
    try {
      if (_selected_payment_method_key == null) {
        ToastComponent.showDialog("Vui lòng chọn phương thức thanh toán.");
        return;
      }

      await payByBank(
        context: context,
        orderId: widget.order_id ?? 0,
        paymentMethodName: _paymentTypeList[_selected_payment_method_index].name,
        rechargeAmount: _grandTotalValue ?? 0.00,
        paymentFor: widget.paymentFor!,
        onComplete: () {
          print("✅ Hoàn tất thanh toán bank");
        },
      );
    } catch (e) {
      print("❌ Lỗi trong pay_by_bank: $e");
      ToastComponent.showDialog("Lỗi khi thanh toán bằng chuyển khoản.");
    }
  }

  onPaymentMethodItemTap(index) async {
    print("🖱 Chọn phương thức ${_paymentTypeList[index].payment_type}");

    final isWalletSelected = _paymentTypeList[index].payment_type == "wallet_system";

    setState(() {
      _selected_payment_method_index = index;
      _selected_payment_method = _paymentTypeList[index].payment_type;
      _selected_payment_method_key = _paymentTypeList[index].payment_type_key;
    });

    // 🟢 Nếu chọn ví, cập nhật lại số dư
    if (isWalletSelected) {
      await fetchWalletBalance();
    }
  }

  onPressDetails() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.only(top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
        content: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow(AppLocalizations.of(context)!.subtotal_all_capital, _subTotalString),
                _buildDetailRow(AppLocalizations.of(context)!.tax_all_capital, _taxString),
                _buildDetailRow(AppLocalizations.of(context)!.shipping_cost_all_capital, _shippingCostString),
                _buildDetailRow(AppLocalizations.of(context)!.discount_all_capital, _discountString),
                Divider(),
                _buildDetailRow(AppLocalizations.of(context)!.grand_total_all_capital, _totalString, isTotal: true),
              ],
            ),
          ),
        ),
        actions: [
          Btn.basic(
            child: Text(
              AppLocalizations.of(context)!.close_all_lower,
              style: TextStyle(color: MyTheme.medium_grey),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String? value, {bool isTotal = false}) {
    final displayValue = SystemConfig.systemCurrency != null && value != null
        ? value.replaceAll(SystemConfig.systemCurrency!.code!, SystemConfig.systemCurrency!.symbol!)
        : value ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Spacer(),
          Text(
            displayValue,
            style: TextStyle(
                color: isTotal ? MyTheme.accent_color : MyTheme.font_grey,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: MyTheme.mainColor,
        resizeToAvoidBottomInset: false, // Prevent keyboard from resizing
        appBar: buildAppBar(context),
        body: Column(
          children: [
            // Main scrollable content
            Expanded(
              child: RefreshIndicator(
                color: MyTheme.accent_color,
                backgroundColor: Colors.white,
                onRefresh: _onRefresh,
                displacement: 0,
                child: SingleChildScrollView(
                  controller: _mainScrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        buildPaymentMethodList(),
                        SizedBox(height: 200), // Extra space for bottom section
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Fixed payment section at bottom
            _buildPaymentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.paymentFor == PaymentFor.Order) ...[
                buildApplyCouponRow(context),
                const SizedBox(height: 12),
              ],

              // ✅ Hiển thị số dư ví nếu đã đăng nhập + chọn ví
              if (_selected_payment_method == 'wallet_system' && _walletBalance != null && is_logged_in.$) ...[
                (() {
                  final formattedBalance = formatCurrencyNoDecimal(_walletBalance);
                  print("💰 Formatted Wallet Balance = $formattedBalance");
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "💰 Số dư ví: $formattedBalance",
                      style: TextStyle(
                        color: _walletBalance! >= _grandTotalValue!
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  );
                })(),
                const SizedBox(height: 8),
              ],

              // ✅ Hiển thị tổng tiền cho cả hai loại thanh toán
              grandTotalSection(),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 50,
                child: Btn.minWidthFixHeight(
                  minWidth: double.infinity,
                  height: 50,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    _getButtonText(context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    print("🔥 Bấm nút thanh toán");
                    onPressPlaceOrderOrProceed();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getButtonText(BuildContext context){
    switch(widget.paymentFor){
      case PaymentFor.OrderRePayment:
        return AppLocalizations.of(context)!.proceed_all_caps;
      default:
        return AppLocalizations.of(context)!.place_my_order_all_capital;
    }
  }

  void _showCouponSelectionSheet() async {
    final selectedCoupon = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Coupons(selectMode: true)),
    );

    if (selectedCoupon != null && selectedCoupon is String) {
      setState(() {
        _couponController.text = selectedCoupon;
        _coupon_applied = false;
      });

      // ✅ Gọi áp dụng mã
      _applyCouponCode(selectedCoupon);
    }
  }

  void _applyCouponCode(String code) async {
    var response = await CouponRepository().getCouponApplyResponse(code);

    if (response.success) {
      setState(() {
        _coupon_applied = true;
        // Gán các giá trị cần thiết, ví dụ: response.discountAmount...
      });

      ToastComponent.showDialog("Áp dụng mã thành công", gravity: ToastGravity.BOTTOM);
    } else {
      ToastComponent.showDialog("Mã không hợp lệ", gravity: ToastGravity.BOTTOM);
    }
  }

  Row buildApplyCouponRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end, // 🔧 giúp căn đáy
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.coupon_label_text ?? "Mã giảm giá", // hoặc dùng AppLocalizations như trước
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: MyTheme.font_grey,
                  ),
                ),
                SizedBox(
                  height: 42,
                  child: GestureDetector(
                    onTap: () {
                      if (!_coupon_applied!) {
                        _showCouponSelectionSheet();
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _couponController,
                        readOnly: true,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.enter_coupon_code,
                          hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.text_field_grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyTheme.text_field_grey, width: 0.5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: MyTheme.accent_color, width: 1.0),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),

                          // ✅ Đây là phần thêm vào để hiển thị icon gợi ý
                          suffixIcon: !_coupon_applied!
                              ? Icon(Icons.arrow_drop_down, color: MyTheme.accent_color)
                              : null,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 0), // 🔧 đẩy nút xuống gần đáy TextField
          child: SizedBox(
            width: 100,
            height: 42,
            child: Btn.basic(
              color: MyTheme.accent_color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              child: Text(
                !_coupon_applied!
                    ? AppLocalizations.of(context)!.apply_coupon_all_capital
                    : AppLocalizations.of(context)!.remove_ucf,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: !_coupon_applied! ? onCouponApply : onCouponRemove,
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.mainColor,
      scrolledUnderElevation: 0.0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        widget.title ?? "",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color, fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Widget buildPaymentMethodList() {
    if (_isInitial && _paymentTypeList.isEmpty) {
      return ShimmerHelper().buildListShimmer(item_count: 5, item_height: 80.0);
    }
    if (_paymentTypeList.isNotEmpty) {
      return Column(
        children: List.generate(_paymentTypeList.length, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: buildPaymentMethodItemCard(index),
          );
        }),
      );
    }
    return Container(
        height: 100,
        child: Center(
            child: Text(
              AppLocalizations.of(context)!.no_payment_method_is_added,
              style: TextStyle(color: MyTheme.font_grey),
            )));
  }

// ✅ Đoạn đã đầy đủ chức năng và hiển thị số dư ví khi chọn ví, kể cả ở chế độ thanh toán lại đơn hàng

  GestureDetector buildPaymentMethodItemCard(index) {
    final isSelected = _selected_payment_method_key == _paymentTypeList[index].payment_type_key;
    final isWallet = _paymentTypeList[index].payment_type == 'wallet_system';

    print("🧪 UI DEBUG: isWallet=$isWallet | isSelected=$isSelected | _walletBalance=$_walletBalance");

    return GestureDetector(
      onTap: () => onPaymentMethodItemTap(index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? MyTheme.accent_color : MyTheme.light_grey,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 80,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: _paymentTypeList[index].image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _paymentTypeList[index].title,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 14,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
              if (isSelected)
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(child: buildPaymentMethodCheckContainer(true)),
                )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethodCheckContainer(bool check) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 400),
      opacity: check ? 1 : 0,
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(shape: BoxShape.circle, color: MyTheme.accent_color),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Icon(Icons.check, color: Colors.white, size: 16),
        ),
      ),
    );
  }

  Widget grandTotalSection() {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: MyTheme.soft_accent_color,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Text(
              AppLocalizations.of(context)!.total_amount_ucf,
              style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
            ),
            if(widget.paymentFor == PaymentFor.Order)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: InkWell(
                  onTap: onPressDetails,
                  child: Text(
                    AppLocalizations.of(context)!.see_details_all_lower,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            Spacer(),
            Text(balance(),
                style: TextStyle(
                    color: MyTheme.accent_color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  loading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text("${AppLocalizations.of(context)!.please_wait_ucf}"),
            ],
          ),
        );
      },
    );
  }
}
