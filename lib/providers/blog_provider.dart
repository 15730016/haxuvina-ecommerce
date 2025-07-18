import 'package:haxuvina/app_config.dart';
import 'package:haxuvina/data_model/blog_mode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../helpers/api_header.dart';

class BlogProvider with ChangeNotifier {
  List<BlogModel> _blogs = [];

  List<BlogModel> get blogs {
    return _blogs;
  }

  Future<void> fetchBlogs() async {
    final url = Uri.parse("${AppConfig.BASE_URL}/blog-list");
    try {
      final response = await http.get(
          url,
          headers: ApiHeader.build()
      );

      // 1. Kiểm tra xem server có trả về mã thành công không
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // 2. Kiểm tra an toàn cấu trúc JSON trước khi truy cập
        if (jsonData['blogs'] != null && jsonData['blogs']['data'] is List) {
          final List<dynamic> blogDataList = jsonData['blogs']['data'];

          final List<BlogModel> loadedBlogs = [];

          // 3. Phân tích từng mục và xử lý lỗi riêng lẻ
          for (var blogData in blogDataList) {
            try {
              loadedBlogs.add(BlogModel.fromJson(blogData));
            } catch (e) {
              // In ra lỗi của từng mục để dễ dàng gỡ rối
              print("Lỗi phân tích một mục blog: $e");
              print("Dữ liệu blog bị lỗi: $blogData");
            }
          }

          _blogs = loadedBlogs;
          notifyListeners();
        } else {
          // Ném lỗi nếu cấu trúc JSON không như mong đợi
          throw Exception('Cấu trúc dữ liệu JSON không hợp lệ.');
        }
      } else {
        // Ném lỗi nếu server không trả về mã 200 OK
        throw Exception('Lỗi tải dữ liệu từ server: ${response.statusCode}');
      }
    } catch (error) {
      // 4. Bắt tất cả các lỗi khác (mạng, phân tích cú pháp, v.v.)
      print("Lỗi xảy ra trong fetchBlogs: $error");
      // Ném lại lỗi để FutureBuilder trong UI có thể bắt và hiển thị thông báo
      rethrow;
    }
  }
}
