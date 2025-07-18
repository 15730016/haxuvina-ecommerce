import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/search_suggestion_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/repositories/api-request.dart';
import 'package:haxuvina/helpers/api_header.dart';

class SearchRepository {
  Future<List<SearchSuggestionResponse>> getSearchSuggestionListResponse(
      {query_key = "", type = "product"}) async {
    String url =
        ("${AppConfig.BASE_URL}/get-search-suggestions?query_key=$query_key&type=$type");
    final response = await ApiRequest.get(
      url: url,
      headers: ApiHeader.build(),
    );
    return searchSuggestionResponseFromJson(response.body);
  }
}
