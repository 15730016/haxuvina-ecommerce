import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/helpers/system_config.dart';
import 'package:haxuvina/repositories/auth_repository.dart';

import '../data_model/login_response.dart';

class AuthHelper {
  setUserData(LoginResponse loginResponse) {
    if (loginResponse.result == true) {
      SystemConfig.systemUser = loginResponse.user;
      is_logged_in.$ = true;
      is_logged_in.save();
      access_token.$ = loginResponse.access_token;
      access_token.save();
      user_id.$ = loginResponse.user?.id;
      user_id.save();
      user_name.$ = loginResponse.user?.name;
      user_name.save();
      user_email.$ = loginResponse.user?.email ?? "";
      user_email.save();
      user_phone.$ = loginResponse.user?.phone ?? "";
      user_phone.save();
      avatar_original.$ = loginResponse.user?.avatar_original;
      avatar_original.save();
    }
  }

  clearUserData() {
    SystemConfig.systemUser = null;

    // ❗ Đăng xuất người dùng
    is_logged_in.$ = false; // ❌ Đừng để là true
    is_logged_in.save();

    access_token.$ = "";
    access_token.save();

    user_id.$ = 0;
    user_id.save();

    user_name.$ = "";
    user_name.save();

    user_email.$ = "";
    user_email.save();

    user_phone.$ = "";
    user_phone.save();

    avatar_original.$ = "";
    avatar_original.save();

    // ✅ Kích hoạt chế độ khách
    guest_checkout_status.$ = true;
    guest_checkout_status.save();

    // ✅ Nếu chưa có temp_user_id thì tạo mới
    if ((temp_user_id.$ ?? "").isEmpty) {
      temp_user_id.$ = DateTime.now().millisecondsSinceEpoch.toString();
      temp_user_id.save();
    }
  }

  fetch_and_set() async {
    var userByTokenResponse = await AuthRepository().getUserByTokenResponse();
    if (userByTokenResponse.result == true) {
      setUserData(userByTokenResponse);
    } else {
      clearUserData();
    }
  }
}
