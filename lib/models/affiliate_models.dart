class AffiliateDashboard {
  final double balance;
  final Map<String, dynamic> stats;
  final String referralUrl;

  AffiliateDashboard({
    required this.balance,
    required this.stats,
    required this.referralUrl,
  });

  factory AffiliateDashboard.fromJson(Map<String, dynamic> json) {
    return AffiliateDashboard(
      balance: (json['balance'] ?? 0).toDouble(),
      stats: json['stats'] ?? {},
      referralUrl: json['referral_url'] ?? '',
    );
  }
}

class AffiliateEarning {
  final String id;
  final String referralUser;
  final double amount;
  final String orderId;
  final String type;
  final String product;
  final DateTime date;

  AffiliateEarning({
    required this.id,
    required this.referralUser,
    required this.amount,
    required this.orderId,
    required this.type,
    required this.product,
    required this.date,
  });

  factory AffiliateEarning.fromJson(Map<String, dynamic> json) {
    return AffiliateEarning(
      id: json['id'] ?? '',
      referralUser: json['referral_user'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      orderId: json['order_id'] ?? '',
      type: json['type'] ?? '',
      product: json['product'] ?? '',
      date: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
    );
  }
}

class AffiliatePayment {
  final String id;
  final double amount;
  final String method;
  final DateTime date;
  final String status;

  AffiliatePayment({
    required this.id,
    required this.amount,
    required this.method,
    required this.date,
    required this.status,
  });

  factory AffiliatePayment.fromJson(Map<String, dynamic> json) {
    return AffiliatePayment(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      method: json['payment_method'] ?? '',
      date: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      status: json['status'] ?? 'pending',
    );
  }
}

class AffiliateWithdrawal {
  final String id;
  final double amount;
  final DateTime date;
  final String status;

  AffiliateWithdrawal({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory AffiliateWithdrawal.fromJson(Map<String, dynamic> json) {
    return AffiliateWithdrawal(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      status: _getStatusText(json['status'] ?? 0),
    );
  }

  static String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Approved';
      case 2:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }
}

class PaymentSettings {
  final String? paypalEmail;
  final String? bankName;
  final String? bankAccName;
  final String? bankAccNumber;
  final String? bankRoutingNumber;
  final String? bankIban;
  final String? bankSwift;

  PaymentSettings({
    this.paypalEmail,
    this.bankName,
    this.bankAccName,
    this.bankAccNumber,
    this.bankRoutingNumber,
    this.bankIban,
    this.bankSwift,
  });

  factory PaymentSettings.fromJson(Map<String, dynamic> json) {
    return PaymentSettings(
      paypalEmail: json['paypal_email'],
      bankName: json['bank_name'],
      bankAccName: json['bank_acc_name'],
      bankAccNumber: json['bank_acc_number'],
      bankRoutingNumber: json['bank_routing_number'],
      bankIban: json['bank_iban'],
      bankSwift: json['bank_swift'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paypal_email': paypalEmail,
      'bank_name': bankName,
      'bank_acc_name': bankAccName,
      'bank_acc_number': bankAccNumber,
      'bank_routing_number': bankRoutingNumber,
      'bank_iban': bankIban,
      'bank_swift': bankSwift,
    };
  }
}
