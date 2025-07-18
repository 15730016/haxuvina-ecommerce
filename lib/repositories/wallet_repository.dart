import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/wallet_balance_response.dart';
import 'package:haxuvina/data_model/wallet_recharge_response.dart';
import 'package:haxuvina/helpers/api_header.dart';
import 'package:haxuvina/middlewares/banned_user.dart';
import 'package:haxuvina/repositories/api-request.dart';

class WalletRepository {
  Future<dynamic> getBalance() async {
    String url = ("${AppConfig.BASE_URL}/wallet/balance");

    final response = await ApiRequest.get(
        url: url, headers: ApiHeader.build(withAuth: true), middleware: BannedUser());
    return walletBalanceResponseFromJson(response.body);
  }

  Future<dynamic> getRechargeList({int page = 1}) async {
    String url = ("${AppConfig.BASE_URL}/wallet/history?page=$page");
    final response = await ApiRequest.get(
        url: url, headers: ApiHeader.build(withAuth: true), middleware: BannedUser());

    return walletRechargeResponseFromJson(response.body);
  }
}
