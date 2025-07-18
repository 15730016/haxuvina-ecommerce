import 'dart:async';

import 'package:haxuvina/custom/box_decorations.dart';
import 'package:haxuvina/custom/enum_classes.dart';
import 'package:haxuvina/custom/toast_component.dart';
import 'package:haxuvina/custom/useful_elements.dart';
import 'package:haxuvina/helpers/shimmer_helper.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/repositories/wallet_repository.dart';
import 'package:haxuvina/screens/checkout/checkout.dart';
import 'package:haxuvina/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

import '../helpers/main_helpers.dart';

class Wallet extends StatefulWidget {
  final bool from_recharge;
  const Wallet({Key? key, this.from_recharge = false}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final ScrollController _mainScrollController = ScrollController();

  dynamic _balanceDetails;
  final List<dynamic> _rechargeList = [];
  bool _rechargeListInit = true;
  int _rechargePage = 1;
  int? _totalRechargeData = 0;
  bool _showRechargeLoadingContainer = false;

  @override
  void initState() {
    super.initState();
    fetchAll();
    _mainScrollController.addListener(() {
      if (_mainScrollController.position.pixels ==
          _mainScrollController.position.maxScrollExtent) {
        if (!_showRechargeLoadingContainer) {
          setState(() {
            _rechargePage++;
            _showRechargeLoadingContainer = true;
          });
          fetchRechargeList();
        }
      }
    });
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  Future<void> fetchAll() async {
    await fetchBalanceDetails();
    await fetchRechargeList();
  }

  Future<void> fetchBalanceDetails() async {
    var balanceDetailsResponse = await WalletRepository().getBalance();
    if (mounted) {
      setState(() {
        _balanceDetails = balanceDetailsResponse;
      });
    }
  }

  Future<void> fetchRechargeList() async {
    // Note: This now fetches point conversion history, assuming the repository is adapted.
    var rechargeListResponse =
    await WalletRepository().getRechargeList(page: _rechargePage);

    if (rechargeListResponse.result && rechargeListResponse.recharges != null) {
      _rechargeList.addAll(rechargeListResponse.recharges!);
      _totalRechargeData = rechargeListResponse.meta.total;
    }
    _rechargeListInit = false;
    _showRechargeLoadingContainer = false;
    if (mounted) {
      setState(() {});
    }
  }

  reset() {
    _balanceDetails = null;
    _rechargeList.clear();
    _rechargeListInit = true;
    _rechargePage = 1;
    _totalRechargeData = 0;
    _showRechargeLoadingContainer = false;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    await fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.from_recharge) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Main()));
        } else {
          Navigator.of(context).pop();
        }
        return Future.value(false);
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: MyTheme.light_grey,
          appBar: buildAppBar(context),
          body: RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onPageRefresh,
            displacement: 10,
            child: SingleChildScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  // SỬA LỖI: Thêm thuộc tính này để các widget con giãn ra theo chiều rộng
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _balanceDetails != null
                        ? buildBalanceCard(context)
                        : buildBalanceCardShimmer(),
                    const SizedBox(height: 24),
                    buildRechargeHistory(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: UsefulElements.backButton(context, color: "black"),
          onPressed: () {
            if (widget.from_recharge) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Main()));
            } else {
              return Navigator.of(context).pop();
            }
          },
        ),
      ),
      title: Text(
        AppLocalizations.of(context)!.my_wallet_ucf,
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.dark_font_grey,
            fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Widget buildBalanceCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [MyTheme.accent_color, Colors.blue.shade700],
            stops: [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: MyTheme.accent_color.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: -5,
              offset: const Offset(0, 10),
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.wallet_balance_ucf,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _balanceDetails != null
                      ? convertPrice(_balanceDetails.balance)
                      : "...",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Giao dịch mới nhất:", // Changed from "Last Recharged"
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  (_balanceDetails?.last_recharged == "Not Available")
                      ? AppLocalizations.of(context)?.no_transaction_yet ?? "Chưa có giao dịch"
                      : _balanceDetails?.last_recharged ?? "...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBalanceCardShimmer() {
    return Shimmer.fromColors(
      baseColor: MyTheme.shimmer_base,
      highlightColor: MyTheme.shimmer_highlighted,
      child: Container(
        height: 175,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget buildRechargeHistory() {
    if (_rechargeListInit && _rechargeList.isEmpty) {
      return buildRechargeListShimmer();
    } else if (_rechargeList.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lịch sử đổi điểm", // Changed from "Wallet Recharge History"
            style: TextStyle(
                color: MyTheme.dark_font_grey,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            itemCount:
            _rechargeList.length + (_showRechargeLoadingContainer ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 14),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == _rechargeList.length) {
                return buildLoadingContainer();
              }
              return buildRechargeListItemCard(index);
            },
          ),
        ],
      );
    } else {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.no_history_is_available,
            style: TextStyle(color: MyTheme.font_grey),
          ),
        ),
      );
    }
  }

  String _getPaymentMethodLabel(String method) {
    switch (method.toLowerCase()) {
      case 'pointconvert':
        return 'Đổi tích điểm';
    // Nếu bạn muốn hỗ trợ thêm các loại khác sau này:
      case 'bank':
        return 'Chuyển khoản ngân hàng';
      case 'momo':
        return 'Momo';
      default:
        return method; // hoặc return 'Không xác định';
    }
  }


  Widget buildRechargeListItemCard(int index) {
    // 📦 Debug log
    print("📦 Recharge Item $index:");
    print(" - Payment Method: ${_rechargeList[index].payment_method}");
    print(" - Amount: ${_rechargeList[index].amount}");
    print(" - Date: ${_rechargeList[index].date}");
    print(" - Order Code: ${_rechargeList[index].order_code}");

    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          _getPaymentMethodLabel(_rechargeList[index].payment_method),
          style: TextStyle(
              color: MyTheme.dark_font_grey,
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          _rechargeList[index].date ?? '',
          style: TextStyle(
            color: MyTheme.font_grey,
            fontSize: 12,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              convertPrice(_rechargeList[index].amount),
              style: const TextStyle(
                color: MyTheme.accent_color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _rechargeList[index].order_code != null
                  ? 'Mã đơn: ${_rechargeList[index].order_code}'
                  : 'Không có mã đơn',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRechargeListShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Shimmer.fromColors(
              baseColor: MyTheme.shimmer_base,
              highlightColor: MyTheme.shimmer_highlighted,
              child: Container(height: 20, width: 200, color: Colors.white)),
        ),
        Column(
          children: List.generate(
              5,
                  (index) => Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Shimmer.fromColors(
                  baseColor: MyTheme.shimmer_base,
                  highlightColor: MyTheme.shimmer_highlighted,
                  child: Container(
                    height: 75,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget buildLoadingContainer() {
    return SizedBox(
      height: _showRechargeLoadingContainer ? 36 : 0,
      width: double.infinity,
      child: Center(
        child: Text(_totalRechargeData == _rechargeList.length
            ? AppLocalizations.of(context)!.no_more_histories_ucf
            : AppLocalizations.of(context)!.loading_more_histories_ucf),
      ),
    );
  }
}
