import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/repositories/api-request.dart';
import 'package:haxuvina/data_model/language_list_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/helpers/api_header.dart';

class LanguageRepository {
  Future<LanguageListResponse> getLanguageList() async {
    String url = ("${AppConfig.BASE_URL}/languages");
    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());

    return languageListResponseFromJson(response.body);
  }
}
