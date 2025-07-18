import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/all_brands_response.dart';
import 'package:haxuvina/data_model/brand_response.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/repositories/api-request.dart';
import 'package:haxuvina/helpers/api_header.dart';

class BrandRepository {
  Future<BrandResponse> getFilterPageBrands() async {
    String url = ("${AppConfig.BASE_URL}/filter/brands");
    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());
    return brandResponseFromJson(response.body);
  }

  Future<BrandResponse> getBrands({name = "", page = 1}) async {
    String url = ("${AppConfig.BASE_URL}/brands" + "?page=$page&name=$name");
    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());
    return brandResponseFromJson(response.body);
  }

  Future<AllBrandsResponse> getAllBrands() async {
    String url = ("${AppConfig.BASE_URL}/all-brands");
    final response = await ApiRequest.get(url: url, headers: ApiHeader.build());

    return allBrandsResponseFromJson(response.body);
  }
}
