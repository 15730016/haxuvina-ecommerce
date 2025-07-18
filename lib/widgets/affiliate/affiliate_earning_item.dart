import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data_model/affiliate_response.dart';
import '../../my_theme.dart';

class AffiliateEarningItem extends StatelessWidget {
  final AffiliateEarning earning;

  const AffiliateEarningItem({
    Key? key,
    required this.earning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: MyTheme.green,
          child: Icon(Icons.attach_money, color: Colors.white),
        ),
        title: Text('Hoa hồng từ đơn hàng #${earning.orderId}'),
        subtitle: Text(DateFormat('dd/MM/yyyy, hh:mm a').format(earning.createdAt)),
        trailing: Text(
          '+\$${earning.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: MyTheme.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
