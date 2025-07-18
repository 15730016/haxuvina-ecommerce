import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:haxuvina/providers/affiliate_provider.dart';
import 'package:haxuvina/widgets/affiliate/affiliate_dashboard_card.dart';
import 'package:haxuvina/widgets/affiliate/affiliate_stats_card.dart';
import 'package:haxuvina/widgets/affiliate/affiliate_earning_item.dart';
import 'package:haxuvina/widgets/common/custom_app_bar.dart';
import 'package:haxuvina/widgets/common/loading_widget.dart';
import 'package:haxuvina/widgets/common/error_display.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/utils/dimensions.dart';
import 'package:haxuvina/helpers/money_text_field.dart';

import '../../helpers/main_helpers.dart';

class AffiliateScreen extends StatefulWidget {
  const AffiliateScreen({Key? key}) : super(key: key);

  @override
  State<AffiliateScreen> createState() => _AffiliateScreenState();
}

class _AffiliateScreenState extends State<AffiliateScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        debugPrint("📦 Gọi loadAffiliateData từ AffiliateScreen");
        context.read<AffiliateProvider>().loadAffiliateData();
      } catch (e) {
        debugPrint("❌ Không tìm thấy AffiliateProvider: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🎯 AffiliateScreen build đang chạy");

    return Scaffold(
      backgroundColor: MyTheme.mainColor,
      appBar: const CustomAppBar(
        title: 'Tiếp thị liên kết',
        showBackButton: true,
      ),
      body: Consumer<AffiliateProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const LoadingWidget();
          }

          if (provider.error != null) {
            return ErrorDisplay(
              message: provider.error!,
              onRetry: () => provider.loadAffiliateData(),
            );
          }

          if (!provider.isAffiliate) {
            return ErrorDisplay(
              message: "Không thể tải dữ liệu affiliate của bạn. Vui lòng thử lại.",
              onRetry: () => provider.loadAffiliateData(),
            );
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: RefreshIndicator(
                onRefresh: () => provider.loadAffiliateData(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDashboardSection(provider),
                      SizedBox(height: Dimensions.paddingSizeLarge),
                      _buildReferralSection(provider),
                      SizedBox(height: Dimensions.paddingSizeLarge),
                      _buildStatsSection(provider),
                      SizedBox(height: Dimensions.paddingSizeLarge),
                      _buildEarningsSection(provider),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboardSection(AffiliateProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bảng điều khiển',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MyTheme.dark_font_grey,
          ),
        ),
        SizedBox(height: Dimensions.paddingSizeDefault),
        AffiliateDashboardCard(
          balance: provider.dashboardData?.balance ?? 0,
          onWithdrawTap: () => _showWithdrawDialog(provider),
        ),
      ],
    );
  }

  Widget _buildReferralSection(AffiliateProvider provider) {
    final referralUrl = provider.dashboardData?.referralUrl ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Link giới thiệu của bạn',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyTheme.dark_font_grey,
          ),
        ),
        SizedBox(height: Dimensions.paddingSizeSmall),
        Container(
          padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chia sẻ liên kết này để nhận hoa hồng:',
                style: TextStyle(
                  fontSize: 14,
                  color: MyTheme.dark_font_grey.withOpacity(0.7),
                ),
              ),
              SizedBox(height: Dimensions.paddingSizeSmall),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      referralUrl,
                      style: TextStyle(
                        fontSize: 12,
                        color: MyTheme.accent_color,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: referralUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã sao chép link giới thiệu'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(AffiliateProvider provider) {
    final stats = provider.dashboardData?.stats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thống kê hiệu suất',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyTheme.dark_font_grey,
          ),
        ),
        SizedBox(height: Dimensions.paddingSizeSmall),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          mainAxisSpacing: Dimensions.paddingSizeSmall,
          crossAxisSpacing: Dimensions.paddingSizeSmall,
          children: [
            AffiliateStatsCard(
              title: 'Tổng số nhấp chuột',
              value: stats?.countClick.toString() ?? '0',
              icon: Icons.touch_app,
              color: MyTheme.accent_color,
            ),
            AffiliateStatsCard(
              title: 'Sản phẩm đã đặt',
              value: stats?.countItem.toString() ?? '0',
              icon: Icons.shopping_bag,
              color: MyTheme.green,
            ),
            AffiliateStatsCard(
              title: 'Đã giao hàng',
              value: stats?.countDelivered.toString() ?? '0',
              icon: Icons.check_circle,
              color: MyTheme.golden,
            ),
            AffiliateStatsCard(
              title: 'Đã hủy',
              value: stats?.countCancel.toString() ?? '0',
              icon: Icons.cancel,
              color: MyTheme.brick_red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEarningsSection(AffiliateProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thu nhập gần đây',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyTheme.dark_font_grey,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Xem tất cả',
                style: TextStyle(
                  color: MyTheme.accent_color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.paddingSizeSmall),
        if (provider.earnings.isEmpty)
          Container(
            padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Center(
              child: Text(
                'Chưa có thu nhập',
                style: TextStyle(
                  color: MyTheme.dark_font_grey.withOpacity(0.5),
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.earnings.take(5).length,
            separatorBuilder: (context, index) => SizedBox(
              height: Dimensions.paddingSizeSmall,
            ),
            itemBuilder: (context, index) {
              return AffiliateEarningItem(
                earning: provider.earnings[index],
              );
            },
          ),
      ],
    );
  }

  void _showWithdrawDialog(AffiliateProvider provider) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Yêu cầu rút tiền'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Số dư khả dụng: ${formatCurrencyBank((provider.dashboardData?.balance ?? 0).toString())}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              // 👉 Gọi MoneyTextField ở đây
              MoneyTextField(controller: amountController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final raw = amountController.text.replaceAll(RegExp(r'[^\d]'), '');
                final amount = double.tryParse(raw) ?? 0;

                if (amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Số tiền phải lớn hơn 0'),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }

                if (amount > (provider.dashboardData?.balance ?? 0)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Số dư không đủ'),
                    backgroundColor: Colors.red,
                  ));
                  return;
                }

                Navigator.pop(dialogContext);
                final success = await provider.createWithdrawRequest(amount);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(success
                        ? 'Gửi yêu cầu rút tiền thành công'
                        : 'Gửi yêu cầu thất bại'),
                    backgroundColor: success ? MyTheme.green : Colors.red,
                  ));
                }
              },
              child: const Text('Yêu cầu'),
            ),
          ],
        );
      },
    );
  }
}
