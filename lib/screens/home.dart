import 'package:flutter/material.dart';
import 'package:haxuvina/custom/flash deals banner/flash_deal_banner.dart';
import 'package:haxuvina/custom/home_search_box.dart';
import 'package:haxuvina/custom/home_all_products_2.dart';
import 'package:haxuvina/custom/home_banner_one.dart';
import 'package:haxuvina/custom/featured_product_horizontal_list_widget.dart';
import 'package:haxuvina/custom/feature_categories_widget.dart';
import 'package:haxuvina/custom/home_carousel_slider.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:haxuvina/helpers/shimmer_helper.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/presenter/home_presenter.dart';
import 'package:haxuvina/screens/filter.dart';
import 'package:haxuvina/screens/flash_deal/flash_deal_list.dart';
import 'package:haxuvina/screens/product/today_is_deal_products.dart';

import '../single_banner/single_banner_page.dart';

class Home extends StatefulWidget {
  final String? title;
  final bool show_back_button;
  final bool go_back;
  const Home({
    Key? key,
    this.title,
    this.show_back_button = false,
    this.go_back = true,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final HomePresenter homeData = HomePresenter();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeData.onRefresh();
      homeData.mainScrollListener();
      homeData.initPiratedAnimation(this);
    });
  }

  @override
  void dispose() {
    homeData.pirated_logo_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.go_back,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          child: Scaffold(
            appBar: _buildAppBar(context),
            backgroundColor: Colors.white,
            body: ListenableBuilder(
              listenable: homeData,
              builder: (_, __) => Stack(
                children: [
                  RefreshIndicator(
                    color: MyTheme.accent_color,
                    backgroundColor: Colors.white,
                    onRefresh: homeData.onRefresh,
                    child: CustomScrollView(
                      controller: homeData.mainScrollController,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        // Carousel
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: SizedBox(
                              height: 140,
                              child: HomeCarouselSlider(homeData: homeData),
                            ),
                          ),
                        ),

                        // Menu
                        if (homeData.isFlashDeal || homeData.isTodayDeal)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 0, 16),
                              child: _buildHomeMenu(context),
                            ),
                          ),

                        // Banner One
                        SliverToBoxAdapter(
                          child: HomeBannerOne(homeData: homeData),
                        ),

                        // Featured Categories
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 18, 0),
                            child: Text(
                              AppLocalizations.of(context)!.featured_categories_ucf,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 175,
                            child: FeaturedCategoriesWidget(homeData: homeData),
                          ),
                        ),

                        // Flash Deal & Today's Deal Banner
                        if (homeData.isFlashDeal)
                          SliverToBoxAdapter(
                            child: FlashDealBanner(homeData: homeData),
                          ),

                        // Pirated Widget/banner?
                        SliverToBoxAdapter(
                          child: PhotoWidget(),
                        ),

                        // Featured Products
                        SliverToBoxAdapter(
                          child: Container(
                            height: 305,
                            color: const Color(0xffF2F1F6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 22),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    AppLocalizations.of(context)!.featured_products_ucf,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: FeaturedProductHorizontalListWidget(
                                    homeData: homeData,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // All Products
                        SliverToBoxAdapter(
                          child: Container(
                            color: const Color(0xffF2F1F6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18),
                                  child: Text(
                                    AppLocalizations.of(context)!.all_products_ucf,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                HomeAllProducts2(homeData: homeData),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Loading More Indicator
                  Align(
                    alignment: Alignment.center,
                    child: _buildLoadingFooter(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (_) => Filter()),
            );
          },
          child: HomeSearchBox(
            context: context,
          ),
        ),
      ),
    );
  }

  Widget _buildHomeMenu(BuildContext context) {
    if (!homeData.isFlashDeal && !homeData.isTodayDeal) {
      return SizedBox(
        height: 40,
        child: ShimmerHelper().buildHorizontalGridShimmerWithAxisCount(
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          item_count: 4,
          mainAxisExtent: 40,
        ),
      );
    }

    final items = <Map<String, dynamic>>[];
    if (homeData.isTodayDeal) items.add({
      'title': AppLocalizations.of(context)!.today_is_deal_ucf,
      'onTap': () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => TodayIsDealProducts())),
      'color': const Color(0xffE62D05),
    });
    if (homeData.isFlashDeal) items.add({
      'title': AppLocalizations.of(context)!.flash_deal_ucf,
      'onTap': () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => FlashDealList())),
      'color': const Color(0xffF6941C),
    });
    items.add({
      'title': AppLocalizations.of(context)!.brands_ucf,
      'onTap': () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => Filter(selected_filter: 'brands'))),
      'color': const Color(0xFF0000FF),
    });

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final it = items[i];
          return GestureDetector(
            onTap: it['onTap'],
            child: Container(
              width: 106,
              decoration: BoxDecoration(
                color: it['color'],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  it['title'],
                  style: TextStyle(
                    color: it['color'] == const Color(0xffE9EAEB)
                        ? const Color(0xff263140)
                        : Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingFooter() {
    if (!homeData.showAllLoadingContainer) return const SizedBox.shrink();
    final isEnd = homeData.totalAllProductData == homeData.allProductList.length;
    return Container(
      height: 36,
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(isEnd
          ? AppLocalizations.of(context)!.no_more_products_ucf
          : AppLocalizations.of(context)!.loading_more_products_ucf),
    );
  }
}
