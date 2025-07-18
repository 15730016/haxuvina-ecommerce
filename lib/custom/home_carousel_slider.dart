import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../app_config.dart';
import '../helpers/shimmer_helper.dart';
import '../my_theme.dart';
import '../presenter/home_presenter.dart';
import 'aiz_image.dart';

class HomeCarouselSlider extends StatelessWidget {
  final HomePresenter? homeData;
  final BuildContext? context;
  const HomeCarouselSlider({Key? key, this.homeData, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Show shimmer effect while carousel is loading initially
    if (homeData == null || (homeData!.isCarouselInitial && homeData!.carouselImageList.isEmpty)) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ShimmerHelper().buildBasicShimmer(height: 120),
      );
    }
    // Show carousel slider when images are available
    else if (homeData!.carouselImageList.isNotEmpty) {
      return SizedBox(
        height: 166, // Fixed height for carousel
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 0.5,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: CarouselSlider(
            key: ValueKey(homeData!.carouselImageList.length),
            options: CarouselOptions(
              height: 166,
              viewportFraction: 1,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              autoPlayCurve: Curves.easeInExpo,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                homeData!.incrementCurrentSlider(index);
              },
            ),
            items: homeData!.carouselImageList.map((i) {
              return InkWell(
                onTap: () {
                  var url = i.url?.split(AppConfig.DOMAIN_PATH).last ?? "";
                  if (url.isNotEmpty) {
                    GoRouter.of(context).go(url);
                  }
                },
                child: AIZImage.radiusImage(i.photo, 0),
              );
            }).toList(),
          ),
        ),
      );
    }
    // Show message when no carousel images found after initial load
    else if (!homeData!.isCarouselInitial && homeData!.carouselImageList.isEmpty) {
      return Container(
        height: 100,
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.no_carousel_image_found,
            style: TextStyle(color: MyTheme.font_grey),
          ),
        ),
      );
    }
    // Fallback empty space
    else {
      return SizedBox(height: 100);
    }
  }
}
