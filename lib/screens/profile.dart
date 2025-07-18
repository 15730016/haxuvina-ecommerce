import 'dart:async';

import 'package:haxuvina/custom/aiz_route.dart';
import 'package:haxuvina/custom/box_decorations.dart';
import 'package:haxuvina/custom/device_info.dart';
import 'package:haxuvina/custom/lang_text.dart';
import 'package:haxuvina/custom/toast_component.dart';
import 'package:haxuvina/helpers/auth_helper.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/presenter/unRead_notification_counter.dart';
import 'package:haxuvina/repositories/profile_repository.dart';
import 'package:haxuvina/screens/address.dart';
import 'package:haxuvina/screens/blog_list_screen.dart';
import 'package:haxuvina/screens/coupon/coupons.dart';
import 'package:haxuvina/screens/filter.dart';
import 'package:haxuvina/screens/product/last_view_product.dart';
import 'package:haxuvina/screens/refund_request.dart';
import 'package:haxuvina/screens/wholesales_screen.dart';
import 'package:haxuvina/screens/wishlist/widgets/page_animation.dart';
import 'package:haxuvina/screens/affiliate/affiliate_screen.dart';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

import '../custom/btn.dart';
import '../repositories/auth_repository.dart';
import 'change_language.dart';
import 'chat/messenger_list.dart';
import 'club_point.dart';
import 'currency_change.dart';

import 'notification/notification_list.dart';
import 'orders/order_list.dart';
import 'profile_edit.dart';
import 'uploads/upload_file.dart';
import 'wallet.dart';
import 'wishlist/wishlist.dart';

class Profile extends StatefulWidget {
  final bool show_back_button;
  const Profile({Key? key, this.show_back_button = false}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScrollController _mainScrollController = ScrollController();
  late BuildContext loadingcontext;

  @override
  void initState() {
    super.initState();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  fetchAll() {
    Provider.of<UnReadNotificationCounter>(context, listen: false).getCount();
  }

  deleteAccountReq() async {
    loading();
    var response = await AuthRepository().getAccountDeleteResponse();

    Navigator.pop(loadingcontext);

    if (response.result == true) {
      AuthHelper().clearUserData();
      context.go("/");
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


  reset() {
    setState(() {});
  }

  onTapLogout(BuildContext context) async {
    await AuthHelper().clearUserData();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: MyTheme.light_grey,
        appBar: buildAppBar(context),
        body: buildBody(),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.accent_color,
      automaticallyImplyLeading: false,
      title: buildAppbarSection(),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            debugPrint("🔔 Đi đến /notifications");
            context.push('/notifications');
          },
          icon: badges.Badge(
            position: badges.BadgePosition.topEnd(top: -5, end: -5),
            badgeStyle: badges.BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.all(4),
            ),
            badgeContent: Consumer<UnReadNotificationCounter>(
              builder: (context, notification, child) {
                return Text(
                  "${notification.unReadNotificationCounter}",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                );
              },
            ),
            child: Icon(Icons.notifications_outlined, color: Colors.white),
          ),
        ),
        IconButton(
          onPressed: () {
            AIZRoute.push(context, ProfileEdit()).then((value) {
              onPopped(value);
            });
          },
          icon: Icon(Icons.settings_outlined, color: Colors.white),
        ),
        if (is_logged_in.$)
          IconButton(
            onPressed: () => onTapLogout(context),
            icon: Icon(Icons.logout, color: Colors.white),
          ),
      ],
    );
  }

  Widget buildAppbarSection() {
    return InkWell(
      onTap: () {
        print("👤 [PROFILE] Người dùng nhấn vào Profile");

        if (!is_logged_in.$) {
          print("🔐 [PROFILE] Chưa đăng nhập → điều hướng đến /users/login");
          context.push("/users/login");
        } else {
          print("✅ [PROFILE] Đã đăng nhập → không điều hướng");
        }
      },
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: MyTheme.white, width: 1.5),
            ),
            child: is_logged_in.$
                ? ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              child: avatar_original.$ == null || avatar_original.$!.isEmpty
                  ? Image.asset(
                'assets/profile_placeholder.png',
                fit: BoxFit.cover,
              )
                  : FadeInImage.assetNetwork(
                placeholder: 'assets/profile_placeholder.png',
                image: avatar_original.$!,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  print("❌ Error loading image: $error");
                  return Image.asset('assets/profile_placeholder.png', fit: BoxFit.cover);
                },
              ),
            )
                : ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              child: Image.asset(
                'assets/profile_placeholder.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded( // ✅ Giới hạn chiều rộng, tránh tràn chữ
            child: buildUserInfo(),
          ),
        ],
      ),
    );
  }

  Widget buildUserInfo() {
    return is_logged_in.$
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${user_name.$}",
          style: TextStyle(
            fontSize: 16,
            color: MyTheme.white,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (user_email.$ != "" || user_phone.$ != "")
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              user_email.$ != "" ? user_email.$ : user_phone.$,
              style: TextStyle(
                color: MyTheme.white.withOpacity(0.8),
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    )
        : Text(
      LangText(context).local.login_or_reg,
      style: TextStyle(
        fontSize: 16,
        color: MyTheme.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildBody() {
    if (!is_logged_in.$) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(LangText(context).local.you_need_to_log_in, style: TextStyle(fontSize: 16, color: MyTheme.font_grey)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("🔘 [BUTTON] Người dùng nhấn nút 'Đăng nhập'");
                context.push("/users/login");
              },
              child: Text(LangText(context).local.login_ucf),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: MyTheme.accent_color,
      backgroundColor: Colors.white,
      onRefresh: _onPageRefresh,
      displacement: 10,
      child: SingleChildScrollView(
        controller: _mainScrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              buildOrderSection(context),
              SizedBox(height: 12),
              buildUtilitiesSection(),
              SizedBox(height: 12),
              buildSettingsMenu(),
              SizedBox(height: 12),
              buildAddonMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.orders_ucf,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context, PageAnimation.fadeRoute(OrderList()));
                },
                child: Row(
                  children: [
                    Text(AppLocalizations.of(context)!.purchase_history_ucf,
                        style: TextStyle(
                            fontSize: 12, color: MyTheme.dark_grey)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios,
                        size: 12, color: MyTheme.dark_grey),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOrderStatusItem(
                icon: Icons.pending_actions_outlined,
                label: "Đang chờ xử lý",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderList(initialDeliveryStatus: "pending"),
                  ),
                ),
              ),
              _buildOrderStatusItem(
                icon: Icons.approval_outlined,
                label: "Đã xác nhận",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderList(initialDeliveryStatus: "confirmed"),
                  ),
                ),
              ),
              _buildOrderStatusItem(
                icon: Icons.task_alt_outlined,
                label: "Đã giao",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderList(initialDeliveryStatus: "delivered"),
                  ),
                ),
              ),
              _buildOrderStatusItem(
                icon: Icons.cancel_outlined,
                label: "Đơn hàng hủy",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderList(initialDeliveryStatus: "cancelled"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusItem({
    required IconData icon,
    required String label,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28, color: MyTheme.dark_font_grey),
          SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: MyTheme.dark_grey)),
        ],
      ),
    );
  }

  Widget buildUtilitiesSection() {
    final utilities = <Map<String, dynamic>>[
      if (wallet_system_status.$)
        {
          "icon": "assets/wallet.png",
          "label": "Ví",
          "onTap": () => Navigator.push(context, PageAnimation.fadeRoute(Wallet())),
        },
      {
        "icon": "assets/heart.png",
        "label": "Đã thích",
        "onTap": () => Navigator.push(context, PageAnimation.fadeRoute(Wishlist())),
      },
      if (conversation_system_status.$)
        {
          "icon": "assets/messages.png",
          "label": "Tin nhắn",
          "onTap": () => Navigator.push(context, PageAnimation.fadeRoute(MessengerList())),
        },
      if (club_point_addon_installed.$)
        {
          "icon": "assets/points.png",
          "label": "Điểm HAXU",
          "onTap": () => Navigator.push(context, PageAnimation.fadeRoute(ClubPoint())),
        },
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tiện ích của tôi",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemCount = utilities.length;
              final rowCount = (itemCount / 4.0).ceil();
              final double rowHeight = 80;

              return SizedBox(
                height: rowHeight * rowCount,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: itemCount,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final item = utilities[index];
                    return GestureDetector(
                      onTap: item["onTap"],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item["icon"],
                            height: 32,
                            width: 32,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item["label"],
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityItem({required String icon, required String label, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, height: 28, width: 28, color: MyTheme.dark_font_grey),
          SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: MyTheme.dark_grey)),
        ],
      ),
    );
  }

  Widget buildSettingsMenu() {
    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Column(
        children: [
          buildMenuListItem(
            "assets/location.png",
            AppLocalizations.of(context)!.address_ucf,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => Address())),
          ),
          buildMenuListItem(
            "assets/coupon.png",
            LangText(context).local.coupons_ucf,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => Coupons())),
          ),
          if (refund_addon_installed.$)
            buildMenuListItem(
              "assets/refund.png",
              AppLocalizations.of(context)!.refund_requests_ucf,
                  () => Navigator.push(context, PageAnimation.fadeRoute(RefundRequest())),
            ),
          buildMenuListItem(
            "assets/affiliate.png",
            "Tiếp thị liên kết",
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AffiliateScreen())),
          ),
        ],
      ),
    );
  }


  Widget buildAddonMenu() {
    // This section can be used for less frequently used items or specific addons
    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Column(
        children: [
          if (last_viewed_product_status.$)
            buildMenuListItem(
                "assets/last_view_product.png", LangText(context).local.last_view_product_ucf,
                    () => Navigator.push(context, MaterialPageRoute(builder: (context) => LastViewProduct()))
            ),

          buildMenuListItem(
              "assets/blog.png", 'Blog',
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => BlogListScreen()))
          ),
          if(is_logged_in.$)
            buildMenuListItem(
                "assets/delete.png",
                LangText(context).local.delete_my_account,
                    () => deleteWarningDialog(),
                showDivider: false
            ),
        ],
      ),
    );
  }


  Widget buildMenuListItem(String img, String label, Function() onPressed, {bool showDivider = true}) {
    return Column(
      children: [
        ListTile(
          onTap: onPressed,
          leading: Image.asset(img, height: 20, width: 20, color: MyTheme.dark_font_grey),
          title: Text(label, style: TextStyle(fontSize: 14, color: MyTheme.dark_font_grey)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: MyTheme.dark_grey.withOpacity(0.5)),
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        ),
        if(showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 55.0, right: 14),
            child: Divider(height: 1, thickness: 1, color: MyTheme.light_grey),
          ),
      ],
    );
  }

  showLoginWarning() {
    return ToastComponent.showDialog(
      AppLocalizations.of(context)!.you_need_to_log_in,
    );
  }

  deleteWarningDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            LangText(context).local.delete_account_warning_title,
            style: TextStyle(fontSize: 15, color: MyTheme.dark_font_grey),
          ),
          content: Text(
            LangText(context).local.delete_account_warning_description,
            style: TextStyle(fontSize: 13, color: MyTheme.dark_font_grey),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(LangText(context).local.no_ucf)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteAccountReq();
                },
                child: Text(LangText(context).local.yes_ucf))
          ],
        ));
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
