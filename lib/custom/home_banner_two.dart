import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../app_config.dart';
import '../helpers/shimmer_helper.dart';
import '../my_theme.dart';
import '../presenter/home_presenter.dart';
import 'aiz_image.dart'; // Nếu dùng AIZImage

class HomeBannerTwo extends StatelessWidget {
  final HomePresenter? homeData;
  final BuildContext? context;

  const HomeBannerTwo({Key? key, this.homeData, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (homeData == null) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text('Không có dữ liệu')),
      );
    }

    if (homeData!.isBannerTwoInitial && homeData!.bannerTwoImageList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
        child: ShimmerHelper().buildBasicShimmer(height: 196),
      );
    }

    if (homeData!.bannerTwoImageList.isNotEmpty) {
      return SizedBox(
        height: 166,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 166,
            viewportFraction: .43,
            initialPage: 0,
            padEnds: false,
            enableInfiniteScroll: true,
            autoPlay: true,
          ),
          items: homeData!.bannerTwoImageList.map((i) {
            return Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 24, top: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      final url = i.url?.split(AppConfig.DOMAIN_PATH).last;
                      if (url != null && url.isNotEmpty) {
                        GoRouter.of(context).go(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid URL')),
                        );
                      }
                    },
                    child: AIZImage.radiusImage(i.photo, 6),
                    // Nếu chưa có ảnh thật thì dùng tạm:
                    // child: Image.asset('assets/placeholder.png', fit: BoxFit.cover),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    if (!homeData!.isBannerTwoInitial && homeData!.bannerTwoImageList.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.no_carousel_image_found,
            style: TextStyle(color: MyTheme.font_grey),
          ),
        ),
      );
    }

    return const SizedBox(height: 100);
  }
}
