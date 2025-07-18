import 'dart:convert';

import '../helpers/file_helper.dart';

ProductMiniResponse productMiniResponseFromJson(String str) =>
    ProductMiniResponse.fromJson(json.decode(str));

String productMiniResponseToJson(ProductMiniResponse data) =>
    json.encode(data.toJson());

class ProductMiniResponse {
  ProductMiniResponse({
    required this.products,
    required this.meta,
    required this.success,
    required this.status,
  });

  /// Luôn luôn non-null list (ít nhất là rỗng)
  final List<Product> products;

  /// Nếu API không có meta thì tạo default
  final Meta meta;

  /// Luôn luôn boolean
  final bool success;

  /// always int
  final int status;

  factory ProductMiniResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>?;
    return ProductMiniResponse(
      products: dataList == null
          ? <Product>[]
          : dataList.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList(),
      meta: json['meta'] == null
          ? Meta.empty()
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
      success: json['success'] == true,
      status: (json['status'] is int) ? json['status'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': products.map((x) => x.toJson()).toList(),
    'meta': meta.toJson(),
    'success': success,
    'status': status,
  };
}

class Product {
  Product({
    required this.id,
    required this.slug,
    required this.name,
    required this.thumbnail_image,
    required this.main_price,
    required this.stroked_price,
    required this.has_discount,
    required this.discount,
    required this.rating,
    required this.sales,
    required this.links,
    required this.is_wholesale,
  });

  final int id;
  final String slug;
  final String name;
  final String thumbnail_image;
  final String main_price;
  final String stroked_price;
  final bool has_discount;
  final String discount;
  final int rating;
  final int sales;
  final Links links;
  final bool is_wholesale;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int? ?? 0,
    slug: json['slug'] as String? ?? '',
    name: json['name'] as String? ?? '',
    thumbnail_image: FileHelper.buildFullImageUrl(json['thumbnail_image']),
    main_price: json['main_price'] as String? ?? '',
    stroked_price: json['stroked_price'] as String? ?? '',
    has_discount: json['has_discount'] == true,
    discount: json['discount']?.toString() ?? '',
    rating: (json['rating'] as num?)?.toInt() ?? 0,
    sales: json['sales'] as int? ?? 0,
    links: json['links'] != null
        ? Links.fromJson(json['links'] as Map<String, dynamic>)
        : Links(details: ''),
    is_wholesale: json['is_wholesale'] == true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'slug': slug,
    'name': name,
    'thumbnail_image': thumbnail_image,
    'main_price': main_price,
    'stroked_price': stroked_price,
    'has_discount': has_discount,
    'discount': discount,
    'rating': rating,
    'sales': sales,
    'links': links.toJson(),
    'is_wholesale': is_wholesale,
  };
}

class Links {
  Links({required this.details});
  final String details;

  factory Links.fromJson(Map<String, dynamic> json) =>
      Links(details: json['details'] as String? ?? '');
  Map<String, dynamic> toJson() => {'details': details};
}

class Meta {
  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  final int currentPage;
  final int from;
  final int lastPage;
  final String path;
  final int perPage;
  final int to;
  final int total;

  /// factory tạo meta rỗng
  factory Meta.empty() => Meta(
    currentPage: 1,
    from: 0,
    lastPage: 1,
    path: '',
    perPage: 0,
    to: 0,
    total: 0,
  );

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json['current_page'] as int? ?? 1,
    from: json['from'] as int? ?? 0,
    lastPage: json['last_page'] as int? ?? 1,
    path: json['path'] as String? ?? '',
    perPage: json['per_page'] as int? ?? 0,
    to: json['to'] as int? ?? 0,
    total: json['total'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'from': from,
    'last_page': lastPage,
    'path': path,
    'per_page': perPage,
    'to': to,
    'total': total,
  };
}
