import 'package:haxuvina/custom/btn.dart';
import 'package:haxuvina/custom/device_info.dart';
import 'package:haxuvina/custom/lang_text.dart';
import 'package:haxuvina/custom/toast_component.dart';
import 'package:haxuvina/custom/useful_elements.dart';
import 'package:haxuvina/helpers/shared_value_helper.dart';
import 'package:haxuvina/helpers/shimmer_helper.dart';
import 'package:haxuvina/my_theme.dart';
import 'package:haxuvina/repositories/club_point_repository.dart';
import 'package:haxuvina/screens/wallet.dart';
import 'package:flutter/material.dart';
import 'package:haxuvina/gen_l10n/app_localizations.dart';

import '../helpers/main_helpers.dart';

class ClubPoint extends StatefulWidget {
  @override
  _ClubPointState createState() => _ClubPointState();
}

class _ClubPointState extends State<ClubPoint> {
  ScrollController _scrollController = ScrollController();

  List<dynamic> _list = [];
  List<dynamic> _converted_ids = [];
  bool _isInitial = true;
  int _page = 1;
  int? _totalData = 0;
  bool _showLoadingContainer = false;

  late VoidCallback _scrollListener;

  @override
  void initState() {
    super.initState();
    fetchData();

    _scrollListener = () {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("📜 Scroll tới cuối, tải thêm trang ${_page + 1}");
        setState(() {
          _page++;
        });
        _showLoadingContainer = true;
        fetchData();
      }
    };

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  fetchData() async {
    print("🟢 Gọi fetchData() - page $_page");

    var clubPointResponse = await ClubPointRepository().getClubPointListResponse(page: _page);

    if (clubPointResponse == null) {
      print("❌ clubPointResponse is null or invalid JSON");
      return;
    }

    print("✅ Số lượng điểm nhận được: ${clubPointResponse.clubPoints?.length}");
    print("➡️ Tổng số điểm: ${clubPointResponse.meta?.total}");

    if (mounted) {
      setState(() {
        if (clubPointResponse.clubPoints != null) {
          _list.addAll(clubPointResponse.clubPoints!);
        }
        _isInitial = false;
        _totalData = clubPointResponse.meta?.total ?? 0;
        _showLoadingContainer = false;
      });
    }
  }

  reset() {
    setState(() {
      _list.clear();
      _converted_ids.clear();
      _isInitial = true;
      _totalData = 0;
      _page = 1;
      _showLoadingContainer = false;
    });
  }

  Future<void> _onRefresh() async {
    print("🔄 Làm mới ClubPoint");
    reset();
    fetchData();
  }

  onPressConvert(item_id, SnackBar _convertedSnackbar) async {
    print("➡️ Chuyển điểm: $item_id");

    var clubPointsToWalletResponse =
    await ClubPointRepository().getClubPointToWalletResponse(item_id);

    if (clubPointsToWalletResponse.result == false) {
      print("❌ Lỗi chuyển điểm: ${clubPointsToWalletResponse.message}");
      ToastComponent.showDialog(clubPointsToWalletResponse.message);
    } else {
      print("✅ Đã chuyển thành công điểm đơn: $item_id");
      ScaffoldMessenger.of(context).showSnackBar(_convertedSnackbar);
      if (mounted) {
        setState(() {
          _converted_ids.add(item_id);
        });
      }
    }
  }

  onPopped(value) async {
    reset();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    SnackBar _convertedSnackbar = SnackBar(
      content: Text(
        AppLocalizations.of(context)?.points_converted_to_wallet ?? "Đổi điểm vào ví",
        style: TextStyle(color: MyTheme.font_grey),
      ),
      backgroundColor: MyTheme.soft_accent_color,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: AppLocalizations.of(context)?.show_wallet_all_capital ?? "Hiển thị ví",
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Wallet();
          })).then((value) {
            onPopped(value);
          });
        },
        textColor: MyTheme.accent_color,
        disabledTextColor: Colors.grey,
      ),
    );

    return Scaffold(
      appBar: buildAppBar(context),
      resizeToAvoidBottomInset: true, // giữ dòng này
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        child: _isInitial
                            ? ShimmerHelper().buildListShimmer(item_count: 10, item_height: 100.0)
                            : _list.isEmpty
                            ? Center(
                          child: Text(
                            AppLocalizations.of(context)?.no_data_is_available ?? "Không có dữ liệu",
                            style: TextStyle(color: MyTheme.font_grey),
                          ),
                        )
                            : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(bottom: 80),
                          itemCount: _list.length + 2,
                          itemBuilder: (context, index) {
                            if (index == 0) return SizedBox(height: 12);
                            if (index == _list.length + 1) return buildLoadingContainer();
                            return buildItemCard(index - 1, _convertedSnackbar);
                          },
                        ),
                      ),
                      buildBottomBar(), // luôn nằm ở cuối và không bị che
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

  Widget buildBottomBar() {
    final totalPoints = _list.fold<double>(
      0.00,
          (sum, item) => sum + (item.points ?? 0.00),
    );

    final formattedPoints = formatPoints(totalPoints.toInt()); // sử dụng hàm của bạn

    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: MyTheme.light_grey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${AppLocalizations.of(context)?.total_club_point_ucf ?? "Tổng điểm"}: $formattedPoints",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: MyTheme.accent_color,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyTheme.accent_color,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: _onRefresh,
            child: Text(
              AppLocalizations.of(context)?.refresh_ucf ?? "Làm mới",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  Container buildLoadingContainer() {
    return Container(
      height: _showLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalData == _list.length
            ? AppLocalizations.of(context)?.no_more_items_ucf ?? "Không còn gì nữa"
            : AppLocalizations.of(context)?.loading_more_items_ucf ??
            "Đang tải thêm..."),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: UsefulElements.backButton(context, color: "black"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppLocalizations.of(context)?.earned_points_ucf ?? "Điểm tích được",
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.dark_font_grey,
            fontWeight: FontWeight.bold),
      ),
      titleSpacing: 0,
    );
  }

  Widget buildList(SnackBar _convertedSnackbar) {
    if (_isInitial && _list.isEmpty) {
      return ShimmerHelper()
          .buildListShimmer(item_count: 10, item_height: 100.0);
    } else if (_list.isNotEmpty) {
      return ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemCount: _list.length,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return buildItemCard(index, _convertedSnackbar);
        },
      );
    } else if (_totalData == 0) {
      return Center(
          heightFactor: 5,
          child: Text(AppLocalizations.of(context)?.no_data_is_available ??
              "Không có dữ liệu", style: TextStyle(color: MyTheme.font_grey),));
    } else {
      return Container(); // should never happen
    }
  }

  Widget buildItemCard(int index, SnackBar _convertedSnackbar) {
    final item = _list[index];
    print("📦 ClubPoint Item $index → OrderCode: ${item.orderCode}, Points: ${item.points}, Converted: ${item.convert_status}");
    bool isConverted = item.convert_status == 1 || _converted_ids.contains(item.id);
    bool canBeConverted = !isConverted && (item.convertible_club_point ?? 0) > 0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      shadowColor: MyTheme.light_grey.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      item.orderCode ?? "N/A",
                      style: TextStyle(
                          color: MyTheme.dark_font_grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)?.status_converted_ucf ?? "Trạng thái chuyển đổi"}:",
                          style: TextStyle(fontSize: 12, color: MyTheme.font_grey),
                        ),
                        Text(
                          isConverted
                              ? LangText(context).local.has_converted_ucf
                              : LangText(context).local.unconverted_ucf,
                          style: TextStyle(
                            fontSize: 12,
                            color: isConverted ? Colors.green : MyTheme.font_grey,
                            fontWeight: isConverted ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)?.date_converted_ucf ?? "Ngày chuyển đổi"}:",
                          style: TextStyle(fontSize: 12, color: MyTheme.font_grey),
                        ),
                        Text(
                          item.date ?? "",
                          style: TextStyle(
                              fontSize: 12, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              VerticalDivider(color: MyTheme.light_grey, thickness: 1),
              SizedBox(width: 10),
              SizedBox(
                width: DeviceInfo(context).width! * 0.25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.club_point_ucf ?? "Điểm",
                      style: TextStyle(fontSize: 12, color: MyTheme.font_grey),
                    ),
                    Text(
                      formatPoints(item.points),
                      style: TextStyle(
                          color: MyTheme.accent_color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    if(canBeConverted)
                      SizedBox(
                        height: 28,
                        width: double.infinity,
                        child: Btn.basic(
                          color: MyTheme.accent_color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)
                          ),
                          child: Text(
                            AppLocalizations.of(context)
                                ?.convert_now_ucf ??
                                "Đổi điểm",
                            style: TextStyle(
                                color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            onPressConvert(item.id, _convertedSnackbar);
                          },
                        ),
                      )
                    else
                      Text(
                        isConverted ? (AppLocalizations.of(context)?.done_all_capital ??
                            "Hoàn thành") : (AppLocalizations.of(context)?.refunded_ucf ??
                            "Hoàn lại tiền"),
                        style: TextStyle(
                            color: isConverted ? Colors.green : MyTheme.grey_153,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
