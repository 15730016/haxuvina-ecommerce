import 'package:haxuvina/custom/device_info.dart';
import 'package:haxuvina/custom/lang_text.dart';
import 'package:haxuvina/repositories/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:haxuvina/screens/notification/widgets/notification_card.dart';

import '../../../../custom/loading.dart';
import '../../../../custom/toast_component.dart';
import '../../../../helpers/shimmer_helper.dart';
import '../../../../my_theme.dart';
import '../../data_model/notification_model.dart';
import '../../helpers/shared_value_helper.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<dynamic> _notificationList = [];
  bool _isFetching = true;
  List<String> notificationIds = [];
  bool isAllSelected = false;

  fetch() async {
    var notificationResponse =
    await NotificationRepository().getAllNotification();

    if (notificationResponse.data != null) {
      for (var item in notificationResponse.data!) {
        print('🧩 ID = ${item.id} (${item.id.runtimeType})');
      }

      _notificationList.addAll(notificationResponse.data!);
    }

    _isFetching = false;
    setState(() {});
  }

  cleanAll() {
    _isFetching = true;
    notificationIds = [];
    _notificationList = [];
    isAllSelected = false;
    setState(() {});
  }

  resetAll() {
    cleanAll();
    fetch();
  }

  @override
  void initState() {
    super.initState();

    print("DEBUG: notificationShowType = ${notificationShowType.$}");

    if (notificationShowType.$ == "password_account_created") {
      print("DEBUG: Hiển thị thông báo tạo tài khoản");

      _notificationList.insert(0, NotificationModel.localSuccessAccountCreated());

      notificationShowType.$ = "";
      notificationShowType.save();

      setState(() {}); // ⚠️ BẮT BUỘC để cập nhật giao diện
    }

    fetch();
  }

  @override
  Widget build(BuildContext context) {

    try {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyTheme.white,
          iconTheme: IconThemeData(color: MyTheme.dark_grey),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LangText(context).local.notification_ucf,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.dark_font_grey),
              ),
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text(LangText(context).local.delete_selection),
                  ),
                ],
                onSelected: (value) async {
                  if (notificationIds.isEmpty) {
                    ToastComponent.showDialog(
                      LangText(context).local.nothing_selected,
                    );
                    return;
                  }
                  Loading.show(context);
                  var notificationResponse = await NotificationRepository()
                      .notificationBulkDelete(notificationIds);
                  Loading.close();
                  if (notificationResponse.result == true) {
                    final msg = notificationResponse.message;
                    if (msg != null) {
                      String message;
                      if (msg is List) {
                        message = msg.join('\n');
                      } else {
                        message = msg.toString();
                      }
                      ToastComponent.showDialog(message);
                    }
                    resetAll();
                  }
                },
              )
            ],
          ),
        ),
        body: SafeArea(
            child: _isFetching == false
                ? buildShowNotificationSection()
                : ShimmerHelper().buildListShimmer(
              item_count: 10,
              item_height: 60.0,
            )),
      );
    } catch (e, s) {
      print('❌ ERROR in NotificationList build: $e');
      print('📍 Stack: $s');
      return Scaffold(
        body: Center(child: Text('Đã xảy ra lỗi: $e')),
      );
    }
  }

  buildShowNotificationSection() {
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _notificationList.isNotEmpty
                ? Container(
                    height: 50,
                    width: DeviceInfo(context).width,
                    child: CheckboxListTile(
                      title: Text(LangText(context).local.select_all),
                      value: isAllSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          isAllSelected = value!;
                          _notificationList.forEach((notification) {
                            notification.isChecked = isAllSelected;
                          });
                          if (isAllSelected) {
                            notificationIds = _notificationList.map((e) => e.id.toString()).toList();
                            print('📌 isAllSelected = $isAllSelected');
                            print('📌 id list = ${_notificationList.map((e) => e.id).toList()}');
                            print('📌 id runtime types: ${_notificationList.map((e) => e.id.runtimeType).toList()}');
                          } else {
                            notificationIds = [];
                          }
                        });
                      },
                    ),
                  )
                : SizedBox.shrink(),
            _notificationList.isNotEmpty
                ? Flexible(
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _notificationList.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        try {
                          return NotificationListCard(
                            id: _notificationList[index].id!.toString(), // chuyển sang String nếu cần
                            type: _notificationList[index].type!,
                            status: getTranslatedStatus(context, _notificationList[index].data!.status),
                            orderId: _notificationList[index].data!.orderId,
                            orderCode: _notificationList[index].data!.orderCode,
                            notificationText: _notificationList[index].notificationText,
                            link: _notificationList[index].data!.link,
                            dateTime: _notificationList[index].date,
                            image: _notificationList[index].image,
                            isChecked: _notificationList[index].isChecked,
                            onSelect: (String id, bool isChecked) {
                              setState(() {
                                _notificationList[index].isChecked = isChecked;
                              });
                              if (isChecked) {
                                notificationIds.add(id);
                              } else {
                                notificationIds.remove(id);
                              }
                            },
                          );
                        } catch (e, s) {
                          print('❌ ERROR in NotificationListCard: $e');
                          print('📍 Stack: $s');
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  )
                : Center(
                    child: Text(
                    LangText(context).local.no_notification_ucf,
                  )),
          ],
        ));
  }

  String getTranslatedStatus(BuildContext context, String? status) {
    final local = LangText(context).local;

    switch (status) {
      case 'placed':
        return local.status_placed ?? 'Đã đặt hàng';
      case 'confirmed':
        return local.status_confirmed ?? 'Đã xác nhận';
      case 'on_delivery':
        return local.status_on_delivery ?? 'Đang giao hàng';
      case 'delivered':
        return local.status_delivered ?? 'Đã giao';
      case 'cancelled':
        return local.status_cancelled ?? 'Đã huỷ';
      case 'pending':
        return local.status_pending ?? 'Chờ xử lý';
      default:
        return status ?? '';
    }
  }

}
