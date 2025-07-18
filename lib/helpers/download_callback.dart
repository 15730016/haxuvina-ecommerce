// lib/helpers/download_callback.dart
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_filex/open_filex.dart';

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
}

@pragma('vm:entry-point')
Future<void> openDownloadedFile(String filePath) async {
await OpenFilex.open(filePath);
}
