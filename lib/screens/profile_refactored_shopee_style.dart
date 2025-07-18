import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:badges/badges.dart' as badges;

import '../custom/btn.dart';
import '../custom/lang_text.dart';
import '../custom/toast_component.dart';
import '../gen_l10n/app_localizations.dart';
import '../helpers/auth_helper.dart';
import '../helpers/shared_value_helper.dart';
import '../my_theme.dart';
import '../presenter/unRead_notification_counter.dart';
import '../repositories/auth_repository.dart';
import '../repositories/profile_repository.dart';
import '../screens/address.dart';
import '../screens/blog_list_screen.dart';
import '../screens/chat/messenger_list.dart';
import '../screens/coupon/coupons.dart';
import '../screens/filter.dart';
import '../screens/notification/notification_list.dart';
import '../screens/orders/order_list.dart';
import '../screens/profile_edit.dart';
import '../screens/refund_request.dart';
import '../screens/uploads/upload_file.dart';
import '../screens/wallet.dart';
import '../screens/wishlist/wishlist.dart';
import '../screens/product/last_view_product.dart';
import '../screens/wholesales_screen.dart';
import '../screens/club_point.dart';

class Profile extends StatefulWidget {
  final bool show_back_button;
  const Profile({Key? key, this.show_back_button = false}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _cart = 0, _wishlist = 0, _order = 0;

  @override
  void initState() {
    super.initState();
    if (is_logged_in.$) fetchCounters();
  }

  fetchCounters() async {
    var response = await ProfileRepository().getProfileCountersResponse();
    setState(() {
      _cart = response.cart_item_count ?? 0;
      _wishlist = response.wishlist_item_count ?? 0;
      _order = response.order_count ?? 0;
    });
  }

  Widget buildCounterBox(String imagePath, String text, int count) {
    return Expanded(
      child: Column(
        children: [
          Image.asset(imagePath, width: 28),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            count.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrdersSection(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.orders_ucf,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => OrderList()));
                },
                child: Text(
                  AppLocalizations.of(context)!.view_all_ucf,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildCounterBox(
                  "assets/cart.png",
                  AppLocalizations.of(context)!.in_your_cart_all_lower,
                  _cart),
              buildCounterBox(
                  "assets/heart.png",
                  AppLocalizations.of(context)!.in_your_wishlist_all_lower,
                  _wishlist),
              buildCounterBox(
                  "assets/orders.png",
                  AppLocalizations.of(context)!.your_ordered_all_lower,
                  _order),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.light_grey,
      appBar: AppBar(
        backgroundColor: MyTheme.accent_color,
        title: Text(is_logged_in.$ ? (user_name.$ ?? 'Guest') : 'Đăng nhập / Đăng ký'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NotificationList()));
            },
            icon: badges.Badge(
              badgeContent: Consumer<UnReadNotificationCounter>(
                builder: (_, provider, __) => Text(
                  '${provider.unReadNotificationCounter}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => fetchCounters(),
        child: ListView(
          children: [
            buildOrdersSection(context),
            const SizedBox(height: 12),
            // Các phần khác như ví, điểm, tin nhắn, phiếu giảm giá, địa chỉ,...
            // có thể tiếp tục sử dụng lại các widget đã viết hoặc nâng cấp thêm
          ],
        ),
      ),
    );
  }
}
