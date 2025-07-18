import 'package:flutter/material.dart';
import 'package:haxuvina/custom/fade_network_image.dart';
import 'package:provider/provider.dart';
import 'package:haxuvina/custom/btn.dart';
import 'package:haxuvina/custom/text_styles.dart';
import 'package:haxuvina/custom/useful_elements.dart';
import 'package:haxuvina/data_model/cart_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/helpers/shimmer_helper.dart';
import 'package:haxuvina/helpers/system_config.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/presenter/cart_counter.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:haxuvina/custom/fade_network_image.dart';

import '../../presenter/cart_provider.dart';

class Cart extends StatefulWidget {
  Cart({
    Key? key,
    this.has_bottom_nav,
    this.from_navigation = false,
    this.counter,
  }) : super(key: key) {
    print("🛒 [DEBUG] Cart constructor được gọi");
  }

  final bool? has_bottom_nav;
  final bool from_navigation;
  final CartCounter? counter;

  @override
  _CartState createState() => _CartState();
}


class _CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    print("🧩 _CartState.initState chạy");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      print("🧩 Gọi lại fetchDataAndShipping() trong CartState");
      cartProvider.fetchDataAndShipping(context); // ✅ gọi trực tiếp
    });
  }

  @override
  Widget build(BuildContext context) {
    print("🧱 [DEBUG] Cart widget đang được build");
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        if (!cartProvider.isInitial && cartProvider.cartItems.isEmpty) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: const Color(0xffF2F1F6),
            resizeToAvoidBottomInset: false,
            appBar: buildAppBar(context),
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shopping_cart_outlined,
                        size: 64, color: MyTheme.font_grey),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.cart_is_empty,
                      style:
                          TextStyle(fontSize: 16, color: MyTheme.font_grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xffF2F1F6),
          resizeToAvoidBottomInset: false,
          appBar: buildAppBar(context),
          body: Stack(
            children: [
              RefreshIndicator(
                color: MyTheme.accent_color,
                backgroundColor: Colors.white,
                onRefresh: () => cartProvider.onRefresh(context),
                displacement: 0,
                child: CustomScrollView(
                  controller: cartProvider.mainScrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            buildCartItemList(cartProvider, context),
                            SizedBox(
                                height: widget.has_bottom_nav! ? 140 : 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: buildBottomContainer(cartProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Container buildBottomContainer(CartProvider cartProvider) {
    return Container(
      color: const Color(0xffF2F1F6),
      height: widget.has_bottom_nav! ? 260 : 140,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
        child: Column(
          children: [
            // 🔹 Hiển thị phí giao hàng
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: MyTheme.soft_accent_color,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Text(
                    "Phí giao hàng",
                    style: TextStyle(
                      color: MyTheme.dark_font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      cartProvider.shippingCostString,
                      style: const TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 🔹 Hiển thị tiền tạm tính
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: MyTheme.soft_accent_color,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Text(
                    AppLocalizations.of(context)!.subtotal_all_capital,
                    style: TextStyle(
                      color: MyTheme.dark_font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      cartProvider.cartTotalString,
                      style: const TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 🔹 Hiển thị tổng tiền
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: MyTheme.soft_accent_color,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Text(
                    AppLocalizations.of(context)!.total_amount_ucf,
                    style: TextStyle(
                      color: MyTheme.dark_font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      cartProvider.totalWithShippingString,
                      style: const TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 🔹 Nút thanh toán
            SizedBox(
              height: 58,
              width: double.infinity,
              child: Btn.basic(
                minWidth: double.infinity,
                color: MyTheme.accent_color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  AppLocalizations.of(context)!.proceed_to_shipping_ucf,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () {
                  cartProvider.onPressProceedToShipping(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xffF2F1F6),
      leading: Builder(
        builder: (_) => widget.from_navigation
            ? UsefulElements.backToMain(context, go_back: false)
            : UsefulElements.backButton(context),
      ),
      title: Text(
        AppLocalizations.of(context)!.shopping_cart_ucf,
        style: TextStyles.buildAppBarTexStyle(),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      scrolledUnderElevation: 0.0,
    );
  }

  Widget buildCartItemList(CartProvider cartProvider, BuildContext context) {
    if (cartProvider.isInitial && cartProvider.cartItems.isEmpty) {
      return ShimmerHelper().buildListShimmer(
        item_count: 5,
        item_height: 100.0,
      );
    } else if (cartProvider.cartItems.isNotEmpty) {
      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: cartProvider.cartItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          return buildCartItemCard(cartProvider, context, index);
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildCartItemCard(
      CartProvider cartProvider, BuildContext context, int itemIndex) {
    var cartItem = cartProvider.cartItems[itemIndex];
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: MyImage.imageNetworkPlaceholder(
                url: cartItem.productThumbnailImage!,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cartItem.productName!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 12, color: MyTheme.font_grey),
                  ),
                  Row(
                    children: [
                      Text(
                        cartItem.price ?? '',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: MyTheme.accent_color),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 28,
                        child: InkWell(
                          onTap: () {
                            cartProvider.onPressDelete(
                                context, cartItem.id.toString());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffFEF0F0),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(Icons.delete_forever_outlined,
                                  color: Color(0xffE64444), size: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 75,
                        height: 28,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildQuantityButton(
                              onTap: () {
                                cartProvider.onQuantityDecrease(
                                    context, itemIndex);
                              },
                              icon: Icons.remove,
                            ),
                            Text(
                              cartItem.quantity.toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: MyTheme.accent_color),
                            ),
                            buildQuantityButton(
                              onTap: () {
                                cartProvider.onQuantityIncrease(
                                    context, itemIndex);
                              },
                              icon: Icons.add,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10)
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildQuantityButton(
      {required void Function() onTap, required IconData icon}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: const Color(0xffF2F1F6),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: MyTheme.grey_153, size: 14),
      ),
    );
  }
}
