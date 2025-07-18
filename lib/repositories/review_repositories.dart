import 'package:haxuvina/app_config.dart';
import 'dart:convert';

import 'package:haxuvina/data_model/review_response.dart';
import 'package:haxuvina/data_model/review_submit_response.dart';

import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/repositories/api-request.dart';

import '../helpers/api_header.dart';

class ReviewRepository {
  Future<dynamic> getReviewResponse(int? product_id, {page = 1}) async {
    String url =
        ("${AppConfig.BASE_URL}/reviews/product/${product_id}?page=${page}");
    final response = await ApiRequest.get(
      url: url,
      headers: ApiHeader.build(
      withAuth: true,       // nếu cần token
      type: HeaderType.json,
    ),
    );

    return reviewResponseFromJson(response.body);
  }

  Future<dynamic> getReviewSubmitResponse(
    int? product_id,
    int rating,
    String comment,
  ) async {
    var post_body = jsonEncode({
      "product_id": "${product_id}",
      "user_id": "${user_id.$}",
      "rating": "$rating",
      "comment": "$comment"
    });

    String url = ("${AppConfig.BASE_URL}/reviews/submit");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        body: post_body);

    return reviewSubmitResponseFromJson(response.body);
  }
}
