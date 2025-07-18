import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../app_config.dart';
import '../helpers/shimmer_helper.dart';
import '../my_theme.dart';
import '../presenter/home_presenter.dart';
import 'aiz_image.dart';

class HomeBannerOne extends StatelessWidget {
  final HomePresenter? homeData;
  final BuildContext? context;

  const HomeBannerOne({Key? key, this.homeData, this.context}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Nếu chưa có dữ liệu
    if (homeData == null) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text('Không có dữ liệu')),
      );
    }

    // Đang tải dữ liệu lần đầu
    if (homeData!.isBannerOneInitial && homeData!.bannerOneImageList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ShimmerHelper().buildBasicShimmer(height: 140),
      );
    }

    // Đã có dữ liệu carousel
    if (homeData!.bannerOneImageList.isNotEmpty) {
      // Chia banner thành các nhóm 3 ảnh
      final chunks = <List<dynamic>>[];
      final originalList = homeData!.bannerOneImageList;
      for (var i = 0; i < originalList.length; i += 3) {
        chunks.add(originalList.sublist(
          i,
          (i + 3) > originalList.length ? originalList.length : (i + 3),
        ));
      }

      return SizedBox(
        height: 120,
        child: CarouselSlider.builder(
          options: CarouselOptions(
            height: 120,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: false,
            viewportFraction: 1.0,
          ),
          itemCount: chunks.length,
          itemBuilder: (context, index, realIndex) {
            final group = chunks[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: group.map<Widget>((item) {
                final url = item.url?.split(AppConfig.DOMAIN_PATH).last;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: InkWell(
                      onTap: () {
                        if (url != null && url.isNotEmpty) {
                          GoRouter.of(context).go(url);
                        }
                      },
                      child: AspectRatio(
                        aspectRatio: 1.6,
                        child: AIZImage.radiusImage(item.photo, 8),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      );
    }

    // Dữ liệu trống sau khi tải
    if (!homeData!.isBannerOneInitial && homeData!.bannerOneImageList.isEmpty) {
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

    // Dự phòng
    return const SizedBox(height: 100);
  }
}
