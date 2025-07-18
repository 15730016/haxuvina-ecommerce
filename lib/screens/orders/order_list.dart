import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haxuvina/screens/orders/widgets/order_search_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:haxuvina/custom/box_decorations.dart';
import 'package:haxuvina/custom/useful_elements.dart';
import 'package:haxuvina/helpers/main_helpers.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/repositories/order_repository.dart';
import 'package:haxuvina/screens/orders/order_details.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';

class OrderList extends StatefulWidget {
  final bool from_checkout;
  final String? initialDeliveryStatus;

  const OrderList({super.key, this.from_checkout = false, this.initialDeliveryStatus});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';

  List<dynamic> _orderList = [];
  bool _isInitial = true;
  int _page = 1;
  int? _totalData = 0;
  bool _showLoadingContainer = false;

  final List<Map<String, String>> _paymentStatusOptions = [];
  final List<Map<String, String>> _deliveryStatusOptions = [];

  String _selectedPaymentStatus = '';
  String _selectedDeliveryStatus = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  bool _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      _setupFilterOptions(); // đảm bảo AppLocalizations đã load
      fetchData();
      _hasInitialized = true;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupFilterOptions() {
    final locale = AppLocalizations.of(context)!;
    _paymentStatusOptions.clear();
    _paymentStatusOptions.addAll([
      {'key': '', 'label': locale.all_ucf},
      {'key': 'paid', 'label': locale.paid_ucf},
      {'key': 'unpaid', 'label': locale.unpaid_ucf},
      {'key': 'submitted', 'label': locale.submitted_ucf},
    ]);

    _deliveryStatusOptions.clear();
    _deliveryStatusOptions.addAll([
      {'key': '', 'label': locale.all_ucf},
      {'key': 'pending', 'label': locale.pending_ucf},
      {'key': 'confirmed', 'label': locale.confirmed_ucf},
      {'key': 'on_the_way', 'label': locale.on_the_way_ucf},
      {'key': 'delivered', 'label': locale.delivered_ucf},
      {'key': 'cancelled', 'label': locale.cancel_order_ucf},
    ]);

    _selectedDeliveryStatus = widget.initialDeliveryStatus ?? _selectedDeliveryStatus;
    _selectedPaymentStatus = _selectedPaymentStatus;
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      setState(() => _page++);
      _showLoadingContainer = true;
      fetchData();
    }
  }

  void _resetAndFetchData() {
    setState(() {
      _page = 1;
      _isInitial = true;
      _orderList.clear();
      _showLoadingContainer = false;
      _selectedPaymentStatus = '';
      _selectedDeliveryStatus = '';
    });
    fetchData();
  }

  Future<void> fetchData() async {
    final orderResponse = await OrderRepository().getOrderList(
      page: _page,
      payment_status: _selectedPaymentStatus,
      delivery_status: _selectedDeliveryStatus,
      search: _searchKeyword,
    );

    setState(() {
      if (_page == 1) {
        _orderList = orderResponse.orders ?? [];
      } else {
        _orderList.addAll(orderResponse.orders ?? []);
      }
      _totalData = orderResponse.meta.total;
      _isInitial = false;
      _showLoadingContainer = false;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _orderList.clear();
      _page = 1;
      _isInitial = true;
      _showLoadingContainer = false;
    });
    fetchData();
  }

  String _getPaymentLabel(String? status) {
    final raw = (status ?? '').toLowerCase().trim();

    String normalized;
    switch (raw) {
      case 'chưa thanh toán':
        normalized = 'unpaid';
        break;
      case 'đã thanh toán':
        normalized = 'paid';
        break;
      case 'đã gửi xác nhận':
        normalized = 'submitted';
        break;
      default:
        normalized = raw;
    }

    print("🧾 Kiểm tra payment_status: $status → $normalized, options: ${_paymentStatusOptions.map((e) => e['key']).toList()}");

    return _paymentStatusOptions.firstWhere(
          (e) => e['key'] == normalized,
      orElse: () => {'label': '-'},
    )['label']!;
  }

  String _getDeliveryLabel(String? status) {
    final raw = (status ?? '').toLowerCase().trim();

    // Map tiếng Việt → English key
    String normalized;
    switch (raw) {
      case 'đang chờ xử lý':
        normalized = 'pending';
        break;
      case 'đã giao':
        normalized = 'delivered';
        break;
      case 'đã huỷ':
      case 'đã hủy':
        normalized = 'cancelled';
        break;
      case 'đang giao':
        normalized = 'on_the_way';
        break;
      case 'xác nhận':
        normalized = 'confirmed';
        break;
      default:
        normalized = raw; // fallback dùng luôn nếu đã đúng
    }

    print("🚚 Kiểm tra delivery_status: $status → $normalized, options: ${_deliveryStatusOptions.map((e) => e['key']).toList()}");

    return _deliveryStatusOptions.firstWhere(
          (e) => e['key'] == normalized,
      orElse: () => {'label': '-'},
    )['label']!;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.from_checkout) {
          context.go("/");
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: MyTheme.mainColor,
        appBar: AppBar(
          backgroundColor: MyTheme.mainColor,
          elevation: 0,
          leading: IconButton(
            icon: UsefulElements.backIcon(context),
            onPressed: () {
              if (widget.from_checkout) {
                context.go("/");
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            AppLocalizations.of(context)!.purchase_history_ucf,
            style: TextStyle(
              fontSize: 16,
              color: MyTheme.dark_font_grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔍 Tìm kiếm
                  OrderSearchBar(
                    controller: _searchController,
                    label: "Nhập mã đơn hàng",
                    onSubmit: (value) {
                      _searchKeyword = value;
                      _resetAndFetchData();
                    },
                    onSuggest: (keyword) => OrderRepository().fetchSuggestions(keyword),
                  ),
                  const SizedBox(height: 12),

                  // 📦 Dropdown lọc
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecorations.buildBoxDecoration_1(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedPaymentStatus,
                              isExpanded: true,
                              icon: const Icon(Icons.expand_more),
                              items: _paymentStatusOptions
                                  .map((e) => DropdownMenuItem(
                                value: e['key'],
                                child: Text(e['label']!),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentStatus = value!;
                                  _orderList.clear();
                                  _page = 1;
                                });
                                fetchData();
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecorations.buildBoxDecoration_1(),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedDeliveryStatus,
                              isExpanded: true,
                              icon: const Icon(Icons.expand_more),
                              items: _deliveryStatusOptions
                                  .map((e) => DropdownMenuItem(
                                value: e['key'],
                                child: Text(e['label']!),
                              ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDeliveryStatus = value!;
                                  _orderList.clear();
                                  _page = 1;
                                });
                                fetchData();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 🧾 Danh sách đơn hàng
                  ListView.builder(
                    itemCount: _orderList.length,
                    shrinkWrap: true, // 🔥 quan trọng: cho phép nằm trong SingleChildScrollView
                    physics: NeverScrollableScrollPhysics(), // vì cha đã scroll rồi
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderDetails(id: _orderList[index].id),
                            ),
                          );
                        },
                        child: buildOrderCard(index),
                      );
                    },
                  ),

                  if (_showLoadingContainer) buildLoadingContainer(),

                  if (_orderList.isEmpty && !_isInitial)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Text(AppLocalizations.of(context)!.no_data_is_available),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${AppLocalizations.of(context)!.total_orders_ucf}: ${_orderList.length}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MyTheme.accent_color,
                  ),
                ),
                ElevatedButton(
                  onPressed: _onRefresh,
                  child: Text(AppLocalizations.of(context)!.refresh_ucf),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOrderList() {
    if (_isInitial) {
      return ListView.builder(
        controller: _scrollController,
        itemCount: 10,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          child: Shimmer.fromColors(
            baseColor: MyTheme.shimmer_base,
            highlightColor: MyTheme.shimmer_highlighted,
            child: Container(height: 75, width: double.infinity, color: Colors.white),
          ),
        ),
      );
    } else if (_orderList.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.no_data_is_available),
      );
    } else {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _orderList.length,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetails(id: _orderList[index].id),
                ),
              );
            },
            child: buildOrderCard(index),
          ),
        ),
      );
    }
  }

  Widget buildOrderCard(int index) {
    final order = _orderList[index];

    // In ra log kiểm tra
    print("📦 Order ${order.code} | payment_status = ${order.payment_status} | delivery_status = ${order.delivery_status}");

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecorations.buildBoxDecoration_1(),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(order.code,
              style: TextStyle(
                color: MyTheme.accent_color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(order.date, style: TextStyle(color: MyTheme.dark_font_grey, fontSize: 12)),
              const Spacer(),
              Text(convertPrice(order.grand_total),
                  style: TextStyle(
                    color: MyTheme.accent_color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text("${AppLocalizations.of(context)!.payment_status_ucf}: ",
                  style: TextStyle(color: MyTheme.dark_font_grey, fontSize: 12)),
              Text(
                _getPaymentLabel(order.payment_status),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: order.payment_status == 'paid' ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text("${AppLocalizations.of(context)!.delivery_status_ucf}: ",
                  style: TextStyle(color: MyTheme.dark_font_grey, fontSize: 12)),
              Text(
                _getDeliveryLabel(order.delivery_status),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: order.delivery_status == 'cancelled' ? Colors.red : MyTheme.dark_font_grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLoadingContainer() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 36,
        color: Colors.white,
        alignment: Alignment.center,
        child: Text(
          _totalData == _orderList.length
              ? AppLocalizations.of(context)!.no_more_orders_ucf
              : AppLocalizations.of(context)!.loading_more_orders_ucf,
        ),
      ),
    );
  }
}
