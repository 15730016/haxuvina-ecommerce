import 'dart:convert';

BlogModel blogModelFromJson(String str) => BlogModel.fromJson(json.decode(str));

String blogModelToJson(BlogModel data) => json.encode(data.toJson());

class BlogModel {
  int id;
  String title;
  String slug;
  String shortDescription;
  String description;
  String banner;
  String categoryName;
  bool? status;
  String? createdAt;
  String? updatedAt;

  BlogModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.shortDescription,
    required this.description,
    required this.banner,
    required this.categoryName,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
    id: json["id"],
    title: json["title"] ?? '',
    slug: json["slug"] ?? '',
    shortDescription: json["short_description"] ?? '',
    description: json["description"] ?? '',
    banner: json["banner"] ?? '',
    categoryName: json["category_name"] ?? '',
    // SỬA LỖI: Chuyển đổi trạng thái từ int (0 hoặc 1) sang bool một cách an toàn
    status: json["status"] == null ? null : json["status"] == 1,
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "slug": slug,
    "short_description": shortDescription,
    "description": description,
    "banner": banner,
    "category_name": categoryName,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
