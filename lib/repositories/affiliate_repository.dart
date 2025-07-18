import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data_model/affiliate_response.dart';
import '../helpers/api_header.dart';
import '../app_config.dart';

class AffiliateRepository {
  Future<AffiliateDashboardResponse> getAffiliateDashboard() async {
    final Uri url = Uri.parse("${AppConfig.BASE_URL}/affiliate/dashboard");
    final response = await http.get(
      url,
      headers: ApiHeader.build(withAuth: true),
    );

    return affiliateDashboardResponseFromJson(response.body);
  }

  Future<AffiliateEarningHistoryResponse> getEarningHistory() async {
     final Uri url = Uri.parse("${AppConfig.BASE_URL}/affiliate/earning-history");
    final response = await http.get(
      url,
      headers: ApiHeader.build(withAuth: true),
    );
    return AffiliateEarningHistoryResponse.fromJson(json.decode(response.body));
  }

  Future<bool> submitWithdrawRequest(double amount) async {
    final Uri url = Uri.parse("${AppConfig.BASE_URL}/affiliate/withdraw-request");

    final response = await http.post(
      url,
      headers: ApiHeader.build(withAuth: true, type: HeaderType.json),
      body: json.encode({
        "amount": amount,
      }),
    );

    final responseBody = json.decode(response.body);
    return responseBody['success'] ?? false;
  }
}
