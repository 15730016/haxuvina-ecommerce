import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/custom/box_decorations.dart';
import 'package:haxuvina/custom/btn.dart';
import 'package:haxuvina/custom/confirm_dialog.dart';
import 'package:haxuvina/custom/device_info.dart';
import 'package:haxuvina/custom/enum_classes.dart';
import 'package:haxuvina/custom/info_dialog.dart';
import 'package:haxuvina/custom/lang_text.dart';
import 'package:haxuvina/custom/loading.dart';
import 'package:haxuvina/custom/toast_component.dart';
import 'package:haxuvina/data_model/order_detail_response.dart';
import 'package:haxuvina/helpers/main_helpers.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/helpers/shimmer_helper.dart';
import 'package:haxuvina/helpers/system_config.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/repositories/order_repository.dart';
import 'package:haxuvina/repositories/refund_request_repository.dart';
import 'package:haxuvina/screens/checkout/checkout.dart';
import 'package:haxuvina/screens/main.dart';
import 'package:haxuvina/screens/refund_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../helpers/api_header.dart';
import '../../helpers/payment_helper.dart';

class OrderDetails extends StatefulWidget {
  final int? id;
  final bool from_notification;
  final bool go_back;

  OrderDetails(
      {Key? key, this.id, this.from_notification = false, this.go_back = true})
      : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  ScrollController _mainScrollController = ScrollController();
  var _steps = [
    'pending',
    'confirmed',
    'on_delivery',
    'picked_up',
    'on_the_way',
    'delivered'
  ];

  TextEditingController _refundReasonController = TextEditingController();
  bool _showReasonWarning = false;

  //init
  int _stepIndex = 0;
  String? _selected_payment_method = "";
  ReceivePort _port = ReceivePort();
  DetailedOrder? _orderDetails;
  List<dynamic> _orderedItemList = [];
  bool _orderItemsInit = false;

  @override
  void initState() {
    super.initState();

    fetchAll(); // Hàm lấy dữ liệu nếu cần

    // Đăng ký port chỉ nếu chưa đăng ký
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');

    _port.listen((dynamic data) {
      String id = data[0];
      int status = data[1];
      int progress = data[2];

      print("Download $id status: $status progress: $progress");

      if (status == DownloadTaskStatus.complete.index) {
        ToastComponent.showDialog("Tải hóa đơn hoàn tất!");
      } else if (status == DownloadTaskStatus.failed.index) {
        ToastComponent.showDialog("Tải thất bại!");
      }

      setState(() {});
    });

    print(widget.id);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  Future<void> _downloadInvoice(id) async {
    var folder = await createFolder();
    try {
      final headers = ApiHeader.build(
        withAuth: true,
        includeCurrency: true,
        acceptAll: true, // nên dùng nếu backend trả về `application/pdf` hoặc file binary
      );

      String? _taskid = await FlutterDownloader.enqueue(
        url: AppConfig.BASE_URL + "/invoice/download/$id",
        saveInPublicStorage: true,
        savedDir: folder,
        showNotification: true,
        headers: headers,
        openFileFromNotification: true,
      );
    } on Exception catch (e) {
      print("Error during file download:");
      print(e.toString());
    }
  }

  Future<String> createFolder() async {
    var mPath = "storage/emulated/0/Download/";
    if (Platform.isIOS) {
      var iosPath = await getApplicationDocumentsDirectory();
      mPath = iosPath.path;
    }
    // print("path = $mPath");
    final dir = Directory(mPath);

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
      return dir.path;
    } else {
      await dir.create();
      return dir.path;
    }
  }

  fetchAll() {
    fetchOrderDetails();
    fetchOrderedItems();
  }

  fetchOrderDetails() async {
    var orderDetailsResponse =
        await OrderRepository().getOrderDetails(id: widget.id);

    if (orderDetailsResponse.detailed_orders.length > 0) {
      _orderDetails = orderDetailsResponse.detailed_orders[0];
      setStepIndex(_orderDetails!.delivery_status);
    }

    setState(() {});
  }

  setStepIndex(key) {
    _stepIndex = _steps.indexOf(key);
    setState(() {});
  }

  fetchOrderedItems() async {
    var orderItemResponse =
        await OrderRepository().getOrderItems(id: widget.id);
    _orderedItemList.addAll(orderItemResponse.orderedItems ?? []);
    _orderItemsInit = true;

    setState(() {});
  }

  reset() {
    _stepIndex = 0;
    _orderDetails = null;
    _orderedItemList.clear();
    _orderItemsInit = false;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  _onPressCancelOrder(id) async {
    Loading.show(context);
    var response = await OrderRepository().cancelOrder(id: id);
    Loading.close();
    if (response.result == true) {
      _onPageRefresh();
    }
    final msg = response.message;
    if (msg != null) {
      String message;
      if (msg is List) {
        message = msg.join('\n');
      } else {
        message = msg.toString();
      }
      ToastComponent.showDialog(message);
    }
  }

  _onPressReorder(id) async {
    Loading.show(context);
    var response = await OrderRepository().reOrder(id: id);
    Loading.close();
    Widget success = SizedBox.shrink(), failed = SizedBox.shrink();
    print(response.successMsgs.toString());
    print(response.failedMsgs.toString());
    if (response.successMsgs!.isNotEmpty) {
      success = Text(
        response.successMsgs?.join("\n") ?? "",
        style: TextStyle(fontSize: 14, color: MyTheme.green_light),
      );
    }
    if (response.failedMsgs!.isNotEmpty) {
      failed = Text(
        response.failedMsgs?.join("\n") ?? "",
        style: TextStyle(fontSize: 14, color: Colors.red),
      );
    }

    InfoDialog.show(
        title: LangText(context).local.info_ucf,
        content: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              success,
              SizedBox(
                height: 3,
              ),
              failed
            ],
          ),
        ));
  }

  _showCancelDialog(id) {
    return ConfirmDialog.show(
      context,
      title: "Please ensure us.",
      message: "Do you want to cancel this order?",
      yesText: "Yes",
      noText: "No",
      pressYes: () {
        _onPressCancelOrder(id);
      },
    );
  }

  _make_re_payment(String amount) {
    int convertedInt = parseCurrencyToInt(amount); // Dùng cho thanh toán
    print("💰 Converted int amount: $convertedInt");

    String displayAmount = convertPrice(amount); // Dùng để hiển thị: "420,000 ₫" chẳng hạn
    print("📺 Hiển thị giá: $displayAmount");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Checkout(
          title: "Thanh toán đơn hàng",
          rechargeAmount: convertedInt.toDouble(), // Dùng để xử lý backend
          paymentFor: PaymentFor.OrderRePayment,
          order_id: _orderDetails!.id,
        ),
      ),
    );
  }

  onTapAskRefund(item_id, item_name, order_code) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.only(
                  top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
              content: Container(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.product_name_ucf,
                                style: TextStyle(
                                    color: MyTheme.font_grey, fontSize: 12)),
                            Container(
                              width: 225,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(item_name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: MyTheme.font_grey,
                                        fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.order_code_ucf,
                                style: TextStyle(
                                    color: MyTheme.font_grey, fontSize: 12)),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(order_code,
                                  style: TextStyle(
                                      color: MyTheme.font_grey, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                                "${AppLocalizations.of(context)!.reason_ucf} *",
                                style: TextStyle(
                                    color: MyTheme.font_grey, fontSize: 12)),
                            _showReasonWarning
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                    ),
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .reason_cannot_be_empty,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12)),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 55,
                          child: TextField(
                            controller: _refundReasonController,
                            autofocus: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .enter_reason_ucf,
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.text_field_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.text_field_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.text_field_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 8.0, top: 16.0, bottom: 16.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Btn.minWidthFixHeight(
                        minWidth: 75,
                        height: 30,
                        color: Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppLocalizations.of(context)!.close_all_capital,
                          style: TextStyle(
                            color: MyTheme.font_grey,
                          ),
                        ),
                        onPressed: () {
                          _refundReasonController.clear();
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Btn.minWidthFixHeight(
                        minWidth: 75,
                        height: 30,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppLocalizations.of(context)!.submit_ucf,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onPressSubmitRefund(item_id, setState);
                        },
                      ),
                    )
                  ],
                )
              ],
            );
          });
        });
  }

  shoWReasonWarning(setState) {
    setState(() {
      _showReasonWarning = true;
    });
    Timer timer = Timer(Duration(seconds: 2), () {
      setState(() {
        _showReasonWarning = false;
      });
    });
  }

  onPressSubmitRefund(item_id, setState) async {
    var reason = _refundReasonController.text.toString();

    if (reason == "") {
      shoWReasonWarning(setState);
      return;
    }

    var refundRequestSendResponse = await RefundRequestRepository()
        .getRefundRequestSendResponse(id: item_id, reason: reason);

    if (refundRequestSendResponse.result == false) {
      final msg = refundRequestSendResponse.message;
      if (msg != null) {
        String message;
        if (msg is List) {
          message = msg.join('\n');
        } else {
          message = msg.toString();
        }
        ToastComponent.showDialog(message);
      }
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    _refundReasonController.clear();

    String message = "";
    final msg = refundRequestSendResponse.message;
    if (msg != null) {
      if (msg is List) {
        message = msg.join('\n');
      } else {
        message = msg.toString();
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: MyTheme.font_grey),
      ),
      backgroundColor: MyTheme.soft_accent_color,

      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.show_request_list_ucf,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RefundRequest();
          })).then((value) {
            onPopped(value);
          });
        },
        textColor: MyTheme.accent_color,
        disabledTextColor: Colors.grey,
      ),
    ));

    reset();
    fetchAll();
    setState(() {});
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.from_notification || widget.go_back == false) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Main();
          }));
          return Future<bool>.value(false);
        } else {
          return Future<bool>.value(true);
        }
      },
      child: Directionality(
        textDirection: TextDirection.ltr, // ✅ Cố định LTR cho tiếng Việt
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onPageRefresh,
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 20.0),
                      child: _orderDetails != null
                          ? buildTimeLineTiles()
                          : buildTimeLineShimmer()),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18.0, bottom: 20.0),
                    child: _orderDetails != null
                        ? buildOrderDetailsTopCard()
                        : ShimmerHelper().buildBasicShimmer(height: 150.0),
                  ),
                ])),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.ordered_product_ucf,
                      style: TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, top: 14.0),
                      child: _orderedItemList.length == 0 && _orderItemsInit
                          ? ShimmerHelper().buildBasicShimmer(height: 100.0)
                          : (_orderedItemList.length > 0
                              ? buildOrderedProductList()
                              : Container(
                                  height: 100,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .ordered_product_ucf,
                                    style: TextStyle(color: MyTheme.font_grey),
                                  ),
                                )))
                ])),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 75,
                        ),
                        buildBottomSection()
                      ],
                    ),
                  )
                ])),
                SliverList(
                    delegate:
                        SliverChildListDelegate([buildPaymentButtonSection()]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildBottomSection() {
    return Expanded(
      child: _orderDetails != null
          ? Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!.sub_total_all_capital,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          convertPrice(_orderDetails!.subtotal!),
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!.tax_all_capital,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          convertPrice(_orderDetails!.tax!),
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!
                                .shipping_cost_all_capital,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          convertPrice(_orderDetails!.shipping_cost!),
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!.discount_all_capital,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          convertPrice(_orderDetails!.coupon_discount!),
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Divider(),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!
                                .grand_total_all_capital,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Text(
                          convertPrice(_orderDetails!.grand_total!),
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ],
            )
          : ShimmerHelper().buildBasicShimmer(height: 100.0),
    );
  }

  buildTimeLineShimmer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ShimmerHelper().buildBasicShimmer(height: 20, width: 250.0),
        )
      ],
    );
  }

  buildTimeLineTiles() {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            isFirst: true,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails!.delivery_status == "pending" ? 36 : 30,
                    height:
                        _orderDetails!.delivery_status == "pending" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.redAccent, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.list_alt,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Text(
                    AppLocalizations.of(context)!.order_placed,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: MyTheme.font_grey),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 0 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.only(left: 4),
              iconStyle: _stepIndex >= 0
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            afterLineStyle: _stepIndex >= 1
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails!.delivery_status == "confirmed" ? 36 : 30,
                    height:
                        _orderDetails!.delivery_status == "confirmed" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.thumb_up_sharp,
                      color: Colors.blue,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Text(
                    AppLocalizations.of(context)!.confirmed_ucf,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: MyTheme.font_grey),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 1 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.only(left: 4),
              iconStyle: _stepIndex >= 1
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 1
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 2
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon vận chuyển
                  Container(
                    width: _orderDetails!.delivery_status == "on_the_way" ? 36 : 30,
                    height: _orderDetails!.delivery_status == "on_the_way" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.amber, width: 2),
                    ),
                    child: Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),

                  // Khoảng cách giữa icon và đường kẻ
                  SizedBox(width: 12),

                  // Đường kẻ chia
                  Expanded(
                    child: Container(
                      height: 1,
                      color: MyTheme.medium_grey_50,
                    ),
                  ),

                  // Khoảng cách giữa đường kẻ và text
                  SizedBox(width: 12),

                  // Text trạng thái
                  Text(
                    AppLocalizations.of(context)!.on_the_way_ucf,
                    style: TextStyle(
                      color: MyTheme.font_grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 2 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.only(left: 4),
              iconStyle: _stepIndex >= 2
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 2
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 5
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            isLast: true,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails!.delivery_status == "delivered" ? 36 : 30,
                    height:
                        _orderDetails!.delivery_status == "delivered" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.purple, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: Icon(
                      Icons.done_all,
                      color: Colors.purple,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  Spacer(),
                  Text(
                    AppLocalizations.of(context)!.delivered_ucf,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: MyTheme.font_grey),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 5 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.only(left: 4),
              iconStyle: _stepIndex >= 5
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 5
                ? LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
        ],
      ),
    );
  }

  buildOrderDetailsTopCard() {
    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.order_code_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  AppLocalizations.of(context)!.shipping_method_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderDetails!.code!,
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Text(
                    _orderDetails!.shipping_type_string!,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.order_date_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  AppLocalizations.of(context)!.payment_method_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderDetails!.date!,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                  Spacer(),
                  Text(
                    getTranslatedPaymentType(context, _orderDetails!.payment_type),
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.payment_status_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  AppLocalizations.of(context)!.delivery_status_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      _orderDetails!.payment_status_string!,
                      style: TextStyle(
                        color: MyTheme.grey_153,
                      ),
                    ),
                  ),
                  buildPaymentStatusCheckContainer(
                      _orderDetails!.payment_status),
                  Spacer(),
                  Text(
                    _orderDetails!.delivery_status_string!,
                    style: TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  _orderDetails!.shipping_address != null
                      ? AppLocalizations.of(context)!.shipping_address_ucf
                      : AppLocalizations.of(context)!.pickup_point_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Text(
                  AppLocalizations.of(context)!.total_amount_ucf,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thông tin địa chỉ
                  Expanded(
                    child: _orderDetails!.shipping_address != null
                        ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildShippingInfo(_orderDetails!.shipping_address!)
                    )
                        : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildPickupInfo(_orderDetails!.pickupPoint!)
                    ),
                  ),

                  // Cột bên phải: Tổng tiền + Reorder + Invoice
                  SizedBox(width: 12),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          convertPrice(_orderDetails!.grand_total!),
                          style: TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8),
                        Btn.basic(
                          minWidth: 60,
                          onPressed: () => _onPressReorder(_orderDetails!.id),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh, color: MyTheme.grey_153, size: 16),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  LangText(context).local.re_order_ucf,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: MyTheme.grey_153, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Btn.basic(
                          minWidth: 60,
                          onPressed: () => _downloadInvoice(_orderDetails!.id),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.file_download_outlined,
                                  color: MyTheme.grey_153, size: 16),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  LangText(context).local.invoice_ucf,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: MyTheme.grey_153, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (_orderDetails!.delivery_status == "pending" &&
                _orderDetails!.payment_status == "unpaid")
              Btn.basic(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  minWidth: DeviceInfo(context).width,
                  color: MyTheme.font_grey,
                  onPressed: () {
                    _showCancelDialog(_orderDetails!.id);
                  },
                  child: Text(
                    LangText(context).local.cancel_order_ucf,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
            if (_orderDetails!.delivery_status == "pending" &&
                _orderDetails!.payment_status == "unpaid")
              Btn.basic(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  minWidth: DeviceInfo(context).width,
                  color: MyTheme.accent_color,
                  onPressed: () {
                    if (_orderDetails?.grand_total == null || _orderDetails!.grand_total!.isEmpty) {
                      ToastComponent.showDialog("Không có thông tin tổng tiền để thanh toán lại.");
                      return;
                    }
                    _make_re_payment(_orderDetails!.grand_total!);
                  },
                  child: Text(
                    LangText(context).local.make_payment_ucf,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
          ],
        ),
      ),
    );
  }

  String getTranslatedPaymentType(BuildContext context, String? paymentType) {
    final local = LangText(context).local;

    switch (paymentType) {
      case 'cod':
        return local.payment_cod ?? 'Thanh toán khi nhận hàng';
      case 'Wallet System':
        return local.payment_wallet ?? 'Ví điện tử';
      case 'Wallet':
        return local.payment_wallet ?? 'Ví điện tử';
      case 'bank_transfer':
        return local.payment_bank_transfer ?? 'Chuyển khoản ngân hàng';
      default:
        return paymentType ?? '';
    }
  }

  List<Widget> _buildShippingInfo(ShippingAddress address) {
    return [
      if (address.name != null)
        Text("Họ và tên: ${address.name}", style: TextStyle(color: MyTheme.grey_153)),
      if (address.email != null)
        Text("Email: ${address.email}", style: TextStyle(color: MyTheme.grey_153)),
      Text("Địa chỉ: ${address.address}", style: TextStyle(color: MyTheme.grey_153)),
      Text("Thành phố: ${address.city}", style: TextStyle(color: MyTheme.grey_153)),
      Text("Quốc gia: ${address.country}", style: TextStyle(color: MyTheme.grey_153)),
      Text("Tỉnh: ${address.state}", style: TextStyle(color: MyTheme.grey_153)),
      Text("SĐT: ${address.phone ?? ''}", style: TextStyle(color: MyTheme.grey_153)),
    ];
  }

  List<Widget> _buildPickupInfo(PickupPoint pickup) {
    return [
      if (pickup.name != null)
        Text("Họ và tên: ${pickup.name}", style: TextStyle(color: MyTheme.grey_153)),
      Text("Địa chỉ: ${pickup.address}", style: TextStyle(color: MyTheme.grey_153)),
      Text("SĐT: ${pickup.phone}", style: TextStyle(color: MyTheme.grey_153)),
    ];
  }

  buildOrderedProductItemsCard(index) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _orderedItemList[index].product_name,
                maxLines: 2,
                style: TextStyle(
                  color: MyTheme.font_grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderedItemList[index].quantity.toString() + " x ",
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  _orderedItemList[index].variation != "" &&
                          _orderedItemList[index].variation != null
                      ? Text(
                          _orderedItemList[index].variation,
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          "item",
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                  Spacer(),
                  Text(
                    convertPrice(_orderedItemList[index].price),
                    style: TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            _orderedItemList[index].refund_section &&
                    _orderedItemList[index].refund_button
                ? InkWell(
                    onTap: () {
                      onTapAskRefund(
                          _orderedItemList[index].id,
                          _orderedItemList[index].product_name,
                          _orderDetails!.code);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.ask_for_refund_ucf,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Icon(
                              Icons.rotate_left,
                              color: MyTheme.accent_color,
                              size: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
            _orderedItemList[index].refund_section &&
                    _orderedItemList[index].refund_label != ""
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.refund_status_ucf,
                            style: TextStyle(color: MyTheme.font_grey),
                          ),
                          Text(
                            _orderedItemList[index].refund_label,
                            style: TextStyle(
                                color: getRefundRequestLabelColor(
                                    _orderedItemList[index]
                                        .refund_request_status)),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  getRefundRequestLabelColor(status) {
    if (status == 0) {
      return Colors.blue;
    } else if (status == 2) {
      return Colors.orange;
    } else if (status == 1) {
      return Colors.green;
    } else {
      return MyTheme.font_grey;
    }
  }

  buildOrderedProductList() {
    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) =>
              Divider(color: MyTheme.medium_grey),
          itemCount: _orderedItemList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildOrderedProductItemsCard(index);
          },
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
            onPressed: () {
              if (widget.from_notification || widget.go_back == false) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Main();
                }));
              } else {
                return Navigator.of(context).pop();
              }
            }),
      ),
      title: Text(
        AppLocalizations.of(context)!.order_details_ucf,
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.dark_font_grey,
            fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildPaymentButtonSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _orderDetails != null && (_orderDetails!.manually_payable ?? false)
              ? Btn.basic(
                  color: MyTheme.soft_accent_color,
                  child: Text(
                    AppLocalizations.of(context)!.make_offline_payment_ucf,
                    style: TextStyle(color: MyTheme.font_grey),
                  ),
                  onPressed: () {
                    if (_orderDetails != null) {
                      switchPaymentMethod();
                    } else {
                      ToastComponent.showDialog("Không thể thanh toán do thiếu thông tin đơn hàng.");
                    }
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  void switchPaymentMethod() {
    switch (_selected_payment_method) {
      case "wallet_system":
        ToastComponent.showDialog("Thanh toán bằng ví hiện đang tạm thời bị vô hiệu hóa.");
        break;

      case "cash_payment":
        ToastComponent.showDialog("Thanh toán khi nhận hàng (COD) chỉ áp dụng khi đặt đơn mới.");
        break;

      case "bank":
        payByBank(
          context: context,
          orderId: _orderDetails!.id!,
          paymentMethodName: "bank",
          rechargeAmount: double.tryParse(_orderDetails!.grand_total ?? '0') ?? 0.0,
          paymentFor: PaymentFor.Order,
          onComplete: () => onPopped(null),
        );
        break;

    // case "vnpay":
      // // Gọi hàm xử lý thanh toán VNPAY nếu bạn đã có
      //   payByVnpay(
      //     context: context,
      //     orderId: _orderDetails!.id!,
      //     amount: double.tryParse(_orderDetails!.grand_total ?? '0') ?? 0.0,
      //     onComplete: () => onPopped(null),
      //   );
      //   break;

      default:
        ToastComponent.showDialog("Phương thức thanh toán không được hỗ trợ.");
        break;
    }
  }

  Container buildPaymentStatusCheckContainer(String? payment_status) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: payment_status == "paid" ? Colors.green : Colors.red),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(payment_status == "paid" ? Icons.check : Icons.check,
            color: Colors.white, size: 10),
      ),
    );
  }
}
