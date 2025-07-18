import 'package:flutter/material.dart';
import '../data_model/affiliate_response.dart';
import '../repositories/affiliate_repository.dart';

class AffiliateProvider with ChangeNotifier {
  final AffiliateRepository _repository = AffiliateRepository();

  bool _isLoading = true;
  String? _error;
  bool _isAffiliate = false;
  AffiliateDashboardData? _dashboardData;
  List<AffiliateEarning> _earnings = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAffiliate => _isAffiliate;
  AffiliateDashboardData? get dashboardData => _dashboardData;
  List<AffiliateEarning> get earnings => _earnings;

  Future<void> loadAffiliateData() async {
    debugPrint("🔄 Bắt đầu gọi loadAffiliateData");
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dashboardResponse = await _repository.getAffiliateDashboard();
      debugPrint("✅ Kết quả dashboard: ${dashboardResponse.success}, message: ${dashboardResponse.message}");

      if (dashboardResponse.success && dashboardResponse.data != null) {
        _isAffiliate = true;
        _dashboardData = dashboardResponse.data;

        final earningsResponse = await _repository.getEarningHistory();
        _earnings = earningsResponse.earnings;
        debugPrint("💰 Lấy earnings: ${_earnings.length} dòng");
      } else {
        _isAffiliate = false;
        _dashboardData = null;
        _earnings = [];
        debugPrint("⚠️ Không phải affiliate hoặc lỗi dữ liệu: ${dashboardResponse.message}");

        if (dashboardResponse.message == null || !dashboardResponse.message!.contains("User is not an affiliate")) {
          _error = dashboardResponse.message ?? "Không tải được dữ liệu affiliate.";
        }
      }
    } catch (e) {
      _error = "Đã xảy ra lỗi: $e";
      _isAffiliate = false;
      debugPrint("❌ Lỗi không mong đợi: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createWithdrawRequest(double amount) async {
    try {
      final success = await _repository.submitWithdrawRequest(amount);
      if (success) {
        // Refresh data on successful withdrawal
        await loadAffiliateData();
        return true;
      }
      return false;
    } catch (e) {
      // Handle or log the error
      return false;
    }
  }
}
