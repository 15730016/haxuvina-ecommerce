import 'dart:convert';

// Dashboard Response
AffiliateDashboardResponse affiliateDashboardResponseFromJson(String str) =>
    AffiliateDashboardResponse.fromJson(json.decode(str));

String affiliateDashboardResponseToJson(AffiliateDashboardResponse data) =>
    json.encode(data.toJson());

class AffiliateDashboardResponse {
  final bool success;
  final AffiliateDashboardData? data;
  final String? message;

  AffiliateDashboardResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory AffiliateDashboardResponse.fromJson(Map<String, dynamic> json) =>
      AffiliateDashboardResponse(
        success: json["success"],
        data: json["data"] == null ? null : AffiliateDashboardData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}

class AffiliateDashboardData {
  final double balance;
  final AffiliateStats stats;
  final String referralCode;
  final String referralUrl;

  AffiliateDashboardData({
    required this.balance,
    required this.stats,
    required this.referralCode,
    required this.referralUrl,
  });

  factory AffiliateDashboardData.fromJson(Map<String, dynamic> json) =>
      AffiliateDashboardData(
        balance: json["balance"]?.toDouble() ?? 0.0,
        stats: AffiliateStats.fromJson(json["stats"]),
        referralCode: json["referral_code"],
        referralUrl: json["referral_url"],
      );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "stats": stats.toJson(),
    "referral_code": referralCode,
    "referral_url": referralUrl,
  };
}

class AffiliateStats {
  final int countClick;
  final int countItem;
  final int countDelivered;
  final int countCancel;

  AffiliateStats({
    required this.countClick,
    required this.countItem,
    required this.countDelivered,
    required this.countCancel,
  });

  factory AffiliateStats.fromJson(Map<String, dynamic> json) => AffiliateStats(
    countClick: json["count_click"] ?? 0,
    countItem: json["count_item"] ?? 0,
    countDelivered: json["count_delivered"] ?? 0,
    countCancel: json["count_cancel"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "count_click": countClick,
    "count_item": countItem,
    "count_delivered": countDelivered,
    "count_cancel": countCancel,
  };
}

// Earning History Response
class AffiliateEarningHistoryResponse {
    final List<AffiliateEarning> earnings;
    // Add pagination info if needed

    AffiliateEarningHistoryResponse({
        required this.earnings,
    });

    factory AffiliateEarningHistoryResponse.fromJson(Map<String, dynamic> json) => AffiliateEarningHistoryResponse(
        earnings: List<AffiliateEarning>.from(json["data"]["logs"].map((x) => AffiliateEarning.fromJson(x))),
    );
}


class AffiliateEarning {
    final int id;
    final int? userId;
    final int referredByUser;
    final double amount;
    final int? orderId;
    final String affiliateType;
    final DateTime createdAt;

    AffiliateEarning({
        required this.id,
        this.userId,
        required this.referredByUser,
        required this.amount,
        this.orderId,
        required this.affiliateType,
        required this.createdAt,
    });

    factory AffiliateEarning.fromJson(Map<String, dynamic> json) => AffiliateEarning(
        id: json["id"],
        userId: json["user_id"],
        referredByUser: json["referred_by_user"],
        amount: json["amount"]?.toDouble(),
        orderId: json["order_id"],
        affiliateType: json["affiliate_type"],
        createdAt: DateTime.parse(json["created_at"]),
    );
}
