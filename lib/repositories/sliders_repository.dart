import 'dart:convert';

import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/flash_deal_response.dart';
import 'package:haxuvina/data_model/slider_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/repositories/api-request.dart';
import 'package:haxuvina/helpers/api_header.dart';

import 'dart:convert';

import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/flash_deal_response.dart';
import 'package:haxuvina/data_model/slider_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/repositories/api-request.dart';
import 'package:haxuvina/helpers/api_header.dart';

class SlidersRepository {
  Future<SliderResponse> getSliders() async {
    String url = ("${AppConfig.BASE_URL}/sliders");
    try {
      final response = await ApiRequest.get(
        url: url,
        headers: ApiHeader.build(),
      );
      if (response.statusCode == 200) {
        return sliderResponseFromJson(response.body);
      } else {
        throw Exception('Failed to load sliders: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getSliders: $e');
      rethrow;
    }
  }

  Future<SliderResponse> getBannerOneImages() async {
    String url = ("${AppConfig.BASE_URL}/banners-one");
    try {
      final response = await ApiRequest.get(
        url: url,
        headers: ApiHeader.build(),
      );
      if (response.statusCode == 200) {
        return sliderResponseFromJson(response.body);
      } else {
        throw Exception('Failed to load banner one images: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getBannerOneImages: $e');
      rethrow;
    }
  }

  Future<SliderResponse> getFlashDealBanner() async {
    String url = ("${AppConfig.BASE_URL}/flash-deals-banners");
    try {
      final response = await ApiRequest.get(
        url: url,
        headers: ApiHeader.build(),
      );
      if (response.statusCode == 200) {
        return sliderResponseFromJson(response.body);
      } else {
        throw Exception('Failed to load flash deal banners: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getFlashDealBanner: $e');
      rethrow;
    }
  }

  Future<SliderResponse> getBannerTwoImages() async {
    String url = ("${AppConfig.BASE_URL}/banners-two");
    try {
      final response = await ApiRequest.get(
        url: url,
        headers: ApiHeader.build(),
      );
      if (response.statusCode == 200) {
        return sliderResponseFromJson(response.body);
      } else {
        throw Exception('Failed to load banner two images: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getBannerTwoImages: $e');
      rethrow;
    }
  }

  Future<SliderResponse> getBannerThreeImages() async {
    String url = ("${AppConfig.BASE_URL}/banners-three");
    try {
      final response = await ApiRequest.get(
        url: url,
        headers: ApiHeader.build(),
      );
      if (response.statusCode == 200) {
        return sliderResponseFromJson(response.body);
      } else {
        throw Exception('Failed to load banner three images: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getBannerThreeImages: $e');
      rethrow;
    }
  }

  Future<List<FlashDealResponseDatum>> fetchBanners() async {
    String url = ("${AppConfig.BASE_URL}/flash-deals");
    try {
      final response = await ApiRequest.get(
        url: url,
        headers: ApiHeader.build(),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null) {
          return (jsonData['data'] as List)
              .map((banner) => FlashDealResponseDatum.fromJson(banner))
              .toList();
        } else {
          throw Exception('Failed to load banners: Data is null');
        }
      } else {
        throw Exception('Failed to load banners: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchBanners: $e');
      rethrow;
    }
  }
}
