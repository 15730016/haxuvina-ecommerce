import 'package:haxuvina/data_model/guest_customer_info_check_response.dart';
import 'package:haxuvina/data_model/login_response.dart';

import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/middlewares/banned_user.dart';
import 'api-request.dart';
import 'package:haxuvina/helpers/api_header.dart';

class GuestCheckoutRepository {
  Future<GuestCustomerInfoCheckResponse> guestCustomerInfoCheck(
      postBody) async {
    String url = ("${AppConfig.BASE_URL}/guest-customer-info-check");
    final response = await ApiRequest.post(
      url: url,
      headers: ApiHeader.build(),
      body: postBody,
      middleware: BannedUser(),
    );
    return guestCustomerInfoCheckResponseFromJson(response.body);
  }

  Future<dynamic> guestUserAccountCreate(postBody) async {
    String url = ("${AppConfig.BASE_URL}/guest-user-account-create");

    final response = await ApiRequest.post(
      url: url,
      body: postBody,
      headers: ApiHeader.build(
      withAuth: true,       // nếu cần token
      type: HeaderType.json,
    ),
    );
    return loginResponseFromJson(response.body);
  }
}
