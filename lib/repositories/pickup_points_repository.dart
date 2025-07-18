import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/pickup_points_response.dart';
import 'package:haxuvina/repositories/api-request.dart';

class PickupPointRepository {
  Future<PickupPointListResponse> getPickupPointListResponse() async {
    String url = ('${AppConfig.BASE_URL}/pickup-list');

    final response = await ApiRequest.get(url: url);

    return pickupPointListResponseFromJson(response.body);
  }
}
