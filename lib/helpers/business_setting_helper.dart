import 'package:haxuvina/data_model/business_setting_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/repositories/business_setting_repository.dart';

class BusinessSettingHelper {
  Future<void> setBusinessSettingData() async {
    final response = await BusinessSettingRepository().getBusinessSettingList();

    if (response.data == null) return;

    for (final element in response.data!) {
      final valueStr = element.value.toString();
      final isActive = valueStr == "1";

      switch (element.type) {
        case 'facebook_login':
          allow_facebook_login.$ = isActive;
          break;

        case 'google_login':
          allow_google_login.$ = isActive;
          break;

        case 'apple_login':
          allow_apple_login.$ = isActive;
          break;

        case 'pickup_point':
          pick_up_status.$ = isActive;
          break;

        case 'wallet_system':
          wallet_system_status.$ = isActive;
          break;

        case 'email_verification':
          mail_verification_status.$ = isActive;
          break;

        case 'conversation_system':
          conversation_system_status.$ = isActive;
          break;

        case 'classified_product':
          classified_product_status.$ = isActive;
          break;

        case 'shipping_type':
          carrier_base_shipping.$ = valueStr == "carrier_wise_shipping";
          break;

        case 'google_recaptcha':
          google_recaptcha.$ = isActive;
          break;

        case 'vendor_system_activation':
          vendor_system.$ = isActive;
          break;

        case 'guest_checkout_activation':
          guest_checkout_status.$ = isActive;
          break;

        case 'last_viewed_product_activation':
          last_viewed_product_status.$ = isActive;
          break;

        case 'notification_show_type':
          notificationShowType.$ = valueStr;
          break;

        default:
        // Unknown or unused setting
          break;
      }
    }
  }
}
