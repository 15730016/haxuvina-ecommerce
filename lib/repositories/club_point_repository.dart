import 'dart:convert';

import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/club_point_response.dart';
import 'package:haxuvina/data_model/club_point_to_wallet_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/middlewares/banned_user.dart';
import 'package:haxuvina/repositories/api-request.dart';

class ClubPointRepository {
  Future<ClubPointResponse?> getClubPointListResponse({page = 1}) async {
    String url = "${AppConfig.BASE_URL}/club-point/get-list?page=$page";

    try {
      final response = await ApiRequest.get(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        middleware: BannedUser(),
      );

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return clubPointResponseFromJson(response.body);
      } else {
        print("❌ Invalid response: ${response.statusCode}, body: ${response.body}");
      }
    } catch (e, stack) {
      print("❌ Exception in getClubPointListResponse: $e");
    }

    return null;
  }

  Future<dynamic> getClubPointToWalletResponse(int? id) async {
    var post_body = jsonEncode({
      "id": "${id}",
    });
    String url = ("${AppConfig.BASE_URL}/club-point/convert-into-wallet");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());
    return clubPointsToWalletResponseFromJson(response.body);
  }
}
