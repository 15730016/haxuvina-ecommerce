import 'dart:async';
import 'dart:convert';
import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';

import 'package:haxuvina/single_banner/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/api_header.dart';

class PhotoProvider with ChangeNotifier {
  List<SingleBanner> _singleBanner = [];

  List<SingleBanner> get singleBanner => _singleBanner;

  Future<void> fetchPhotos() async {
    const url = "${AppConfig.BASE_URL}/banners-two";

    try {
      final response = await http.get(
          Uri.parse(url),
          headers: ApiHeader.build()
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success']) {
          _singleBanner = (responseData['data'] as List)
              .map((data) => SingleBanner.fromJson(data))
              .toList();
        } else {
          _singleBanner = [];
        }

        notifyListeners();
      } else {
        throw Exception(
            "Failed to load photos. Status code: ${response.statusCode}");
      }
    } on TimeoutException catch (_) {
      print("Request timed out");
      _singleBanner = [];
      notifyListeners();
    } catch (error) {
      print("Error fetching photos: $error");
      _singleBanner = [];
      notifyListeners();
    }
  }
}
