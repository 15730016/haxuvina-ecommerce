import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/flash_deal_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/repositories/api-request.dart';
import 'package:haxuvina/helpers/api_header.dart';

import 'package:haxuvina/helpers/system_config.dart';

class FlashDealRepository {
  Future<FlashDealResponse> getFlashDeals() async {
    String url = ("${AppConfig.BASE_URL}/flash-deals");
    final response = await ApiRequest.get(
      url: url,
      headers: ApiHeader.build(),
    );

    return flashDealResponseFromJson(response.body.toString());
  }

  Future<FlashDealResponse> getFlashDealInfo(slug) async {
    String url = ("${AppConfig.BASE_URL}/flash-deals/info/$slug");
    final response = await ApiRequest.get(
      url: url,
      headers: ApiHeader.build(),
    );
    return flashDealResponseFromJson(response.body.toString());
  }
}
