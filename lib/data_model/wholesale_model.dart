import '../helpers/file_helper.dart';

class WholesaleProductModel {
  final bool result;
  final ProductData products;

  WholesaleProductModel({required this.result, required this.products});

  factory WholesaleProductModel.fromJson(Map<String, dynamic> json) {
    return WholesaleProductModel(
      result: json['result'],
      products: ProductData.fromJson(json['products']),
    );
  }
}

class ProductData {
  final List<Product> data;

  ProductData({required this.data});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Product> productList = list.map((i) => Product.fromJson(i)).toList();

    return ProductData(
      data: productList,
    );
  }

  bool get isEmpty => data.isEmpty; // Correctly implemented isEmpty getter
}

class Product {
  final int id;
  final String slug;
  final String name;
  final List<String> photos;
  final String thumbnail_image;
  final double base_price;
  final double base_discounted_price;
  final String discount_percentage;
  final bool today_is_deal;
  final bool featured;
  final String unit;
  final double discount;
  final String discount_type;
  final double rating;
  final int sales;
  final ProductLinks links;

  Product({
    required this.id,
    required this.slug,
    required this.name,
    required this.photos,
    required this.thumbnail_image,
    required this.base_price,
    required this.base_discounted_price,
    required this.discount_percentage,
    required this.today_is_deal,
    required this.featured,
    required this.unit,
    required this.discount,
    required this.discount_type,
    required this.rating,
    required this.sales,
    required this.links,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var photosList = List<String>.from(json['photos']);
    return Product(
      id: json['id'],
      slug: json['slug'],
      name: json['name'],
      photos: photosList,
      thumbnail_image: FileHelper.buildFullImageUrl(json['thumbnail_image']),
      base_price: json['base_price'].toDouble(),
      base_discounted_price: json['base_discounted_price'].toDouble(),
      discount_percentage: json['discount_percentage'],
      today_is_deal: json['today_is_deal'] == 1,
      featured: json['featured'] == 1,
      unit: json['unit'],
      discount: json['discount'].toDouble(),
      discount_type: json['discount_type'],
      rating: json['rating'].toDouble(),
      sales: json['sales'],
      links: ProductLinks.fromJson(json['links']),
    );
  }
}

class ProductLinks {
  final String details;
  final String reviews;

  ProductLinks({required this.details, required this.reviews});

  factory ProductLinks.fromJson(Map<String, dynamic> json) {
    return ProductLinks(
      details: json['details'],
      reviews: json['reviews'],
    );
  }
}
