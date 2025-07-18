import 'dart:convert';

import 'package:haxuvina/data_model/common_response.dart';

import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/helpers/main_helpers.dart';
import 'package:haxuvina/middlewares/banned_user.dart';
import 'package:haxuvina/screens/notification/models/all_notification_list_response.dart';
import 'package:haxuvina/screens/notification/models/unread_notification_list_response.dart';
import 'api-request.dart';

class NotificationRepository {
  Future<AllNotificationListResponse> getAllNotification() async {
    String url = ("${AppConfig.BASE_URL}/all-notification");
    Map<String, String> header = commonHeader;
    header.addAll(authHeader);
    final response = await ApiRequest.get(
        url: url, headers: header, middleware: BannedUser());

    return allNotificationListResponseFromJson(response.body);
  }

  Future<UnreadNotificationListResponse> getUnreadNotification() async {
    String url = ("${AppConfig.BASE_URL}/unread-notifications");
    Map<String, String> header = commonHeader;
    header.addAll(authHeader);
    final response = await ApiRequest.get(
        url: url, headers: header, middleware: BannedUser());

    // print('response body for notification');
    // print(response.body);

    return unreadNotificationListResponseFromJson(response.body);
  }

  Future<CommonResponse> notificationBulkDelete(notificationIds) async {
    var post_body = jsonEncode({"notification_ids": "$notificationIds"});

    print(post_body);
    String url = ("${AppConfig.BASE_URL}/notifications/bulk-delete");
    Map<String, String> header = commonHeader;
    header.addAll(authHeader);
    final response = await ApiRequest.post(
        url: url, headers: header, middleware: BannedUser(), body: post_body);

    // print('response body for notification');
    // print(response.body);

    return commonResponseFromJson(response.body);
  }
}
