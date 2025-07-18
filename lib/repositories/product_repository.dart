import 'dart:convert';

import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/category.dart';
import 'package:haxuvina/data_model/product_details_response.dart';
import 'package:haxuvina/data_model/product_mini_response.dart';
import 'package:haxuvina/data_model/variant_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/helpers/system_config.dart';
import 'package:haxuvina/repositories/api-request.dart';
import 'package:haxuvina/data_model/wholesale_model.dart';
import 'package:haxuvina/helpers/api_header.dart';

import 'package:haxuvina/data_model/variant_price_response.dart';

class ProductRepository {
  Future<ProductMiniResponse> getFeaturedProducts({page = 1}) async {
    String url = ("${AppConfig.BASE_URL}/products/featured?page=${page}");
    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());

    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBestSellingProducts() async {
    String url = ("${AppConfig.BASE_URL}/products/best-seller");
    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getInHouseProducts({page}) async {
    String url = ("${AppConfig.BASE_URL}/products/inhouse?page=$page");
    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTodayIsDealProducts() async {
    String url = ("${AppConfig.BASE_URL}/products/today-deal");
    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());

    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFlashDealProducts(id) async {
    String url = ("${AppConfig.BASE_URL}/flash-deal-products/$id");
    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCategoryProducts({
    String? id = "",
    String name = "",
    int page = 1,
  }) async {
    final safeId = id ?? ""; // phòng khi null
    final safeName = Uri.encodeComponent(name); // encode nếu có ký tự đặc biệt

    String url =
        "${AppConfig.BASE_URL}/products/category/$safeId?page=$page&name=$safeName";

    final response = await ApiRequest.get(
      url: url,
      headers: ApiHeader.build(),
    );

    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBrandProducts(
      {required String slug, name = "", page = 1}) async {
    String url =
        ("${AppConfig.BASE_URL}/products/brand/$slug?page=${page}&name=${name}");
    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());

    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFilteredProducts(
      {name = "",
      sort_key = "",
      page = 1,
      brands = "",
      categories = "",
      min = "",
      max = ""}) async {
    String url = ("${AppConfig.BASE_URL}/products/search" +
        "?page=$page&name=${name}&sort_key=${sort_key}&brands=${brands}&categories=${categories}&min=${min}&max=${max}");

    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());

    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getDigitalProducts({
    page = 1,
  }) async {
    String url = ("${AppConfig.BASE_URL}/products/digital?page=$page");

    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());

    return productMiniResponseFromJson(response.body);
  }

  /// trong ProductRepository
  Future<ProductDetailsResponse> getProductDetails({
    required String slug,
    int userId = 0, // mặc định guest là 0
  }) async {
    final encodedSlug = Uri.encodeComponent(slug);
    final url = "${AppConfig.BASE_URL}/products/$encodedSlug/$userId";
    print("▶️ [ProductRepository] GET detail URL: $url");
    final response = await ApiRequest.get(
      url: url,
      headers: ApiHeader.build(withAuth: userId != 0),
    );
    print("▶️ [ProductRepository] statusCode: ${response.statusCode}");
    print("▶️ [ProductRepository] body: ${response.body}");
    return productDetailsResponseFromJson(response.body);
  }

  Future<ProductDetailsResponse> getDigitalProductDetails({int id = 0}) async {
    String url = ("${AppConfig.BASE_URL}/products/" + id.toString());

    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());

    return productDetailsResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFrequentlyBoughProducts(
      {required String slug}) async {
    String url = ("${AppConfig.BASE_URL}/products/frequently-bought/$slug");
    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());

    return productMiniResponseFromJson(response.body);
  }

  Future<VariantResponse> getVariantWiseInfo(
      {required String slug, color = '', variants = '', qty = 1}) async {
    String url = ("${AppConfig.BASE_URL}/products/variant/price");

    var postBody = jsonEncode(
        {'slug': slug, "color": color, "variants": variants, "quantity": qty});

    final response = await ApiRequest.post(
        url: url,
        headers: ApiHeader.build(),
        body: postBody);

    return variantResponseFromJson(response.body);
  }

  Future<VariantPriceResponse> getVariantPrice({id, quantity}) async {
    String url = ("${AppConfig.BASE_URL}/varient-price");

    var post_body = jsonEncode({"id": id, "quantity": quantity});

    final response = await ApiRequest.post(
        url: url,
        headers: ApiHeader.build(),
        body: post_body);

    return variantPriceResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> lastViewProduct() async {
    String url = ("${AppConfig.BASE_URL}/products/last-viewed");
    final response = await ApiRequest.get(
        url: url,
        headers: ApiHeader.build());

    return productMiniResponseFromJson(response.body);
  }

  Future<WholesaleProductModel> getWholesaleProducts() async {
    String url = "${AppConfig.BASE_URL}/wholesale/all-products";
    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());
    if (response.statusCode == 200) {
      return WholesaleProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load products");
    }
  }
}
