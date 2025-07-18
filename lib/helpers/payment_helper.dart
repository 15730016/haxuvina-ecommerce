import 'package:flutter/material.dart';
import 'package:haxuvina/custom/loading.dart';
import 'package:haxuvina/custom/toast_component.dart';
import 'package:haxuvina/repositories/payment_repository.dart';
import 'package:haxuvina/screens/payment_method_screen/bank_screen.dart';
import 'package:haxuvina/custom/enum_classes.dart';

Future<void> payByBank({
  required BuildContext context,
  required int orderId,
  required String paymentMethodName,
  double rechargeAmount = 0.0,
  PaymentFor paymentFor = PaymentFor.Order,
  Function()? onComplete,
}) async {
  Loading.show(context);

  try {
    final response = await PaymentRepository().getOrderCreateResponseFromBank(
      paymentMethodName,
      orderId: orderId,
      amount: rechargeAmount,
      paymentFor: paymentFor.name, // hoặc .toString()
    );
    Navigator.pop(context);

    if (response['result'] != true) {
      ToastComponent.showDialog(response['message'] ?? 'Đã có lỗi xảy ra');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BankScreen(
          order_id: response['order_id'],
          rechargeAmount: double.tryParse(response['grand_total'].toString()) ?? rechargeAmount,
          transferNote: response['transfer_note'],
          vietQrUrl: response['viet_qr_url'],
          bankName: response['bank_name'],
          branchName: response['branch_name'],
          accountName: response['account_name'],
          accountNumber: response['account_number'],
          paymentMethod: paymentMethodName,
          paymentFor: paymentFor,
        ),
      ),
    ).then((value) {
      if (onComplete != null) onComplete();
    });
  } catch (e) {
    Navigator.pop(context);
    ToastComponent.showDialog("Đã có lỗi xảy ra. Vui lòng thử lại sau.");
  }
}
