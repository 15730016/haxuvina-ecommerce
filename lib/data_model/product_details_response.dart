// To parse this JSON data, do
//
//     final productDetailsResponse = productDetailsResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

import '../helpers/file_helper.dart';

ProductDetailsResponse productDetailsResponseFromJson(String str) =>
    ProductDetailsResponse.fromJson(json.decode(str));

String productDetailsResponseToJson(ProductDetailsResponse data) =>
    json.encode(data.toJson());

class ProductDetailsResponse {
  ProductDetailsResponse({
    this.detailed_products,
    this.success,
    this.status,
  });

  List<DetailedProduct>? detailed_products;
  bool? success;
  int? status;

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) =>
      ProductDetailsResponse(
        detailed_products: json["data"] == null
            ? []
            : (json["data"] is List)
            ? List<DetailedProduct>.from((json["data"] as List)
            .map((x) => DetailedProduct.fromJson(x as Map<String, dynamic>)))
            : [DetailedProduct.fromJson(json["data"] as Map<String, dynamic>)],
        success: json["success"] is bool ? json["success"] as bool : false,
        status: json["status"] is int ? json["status"] as int : 0,
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(
        detailed_products!.map((x) => x.toJson())),
    "success": success,
    "status": status,
  };
}

class DetailedProduct {
  DetailedProduct({
    this.id,
    this.name,
    required this.photos,

    this.thumbnail_image,
    required this.tags,
    this.price_high_low,
    required this.choice_options,
    required this.colors,
    this.has_discount,
    this.discount,
    this.stroked_price,
    this.main_price,
    this.calculable_price,
    this.currency_symbol,
    this.current_stock,
    this.unit,
    this.rating,
    this.rating_count,
    this.earn_point,
    this.description,
    this.downloads,
    this.video_link,
    this.link,
    this.brand,
    required this.wholesale,
    this.estShippingTime,
  });

  int? id;
  String? name;
  List<Photo> photos;

  String? thumbnail_image;
  List<String> tags;
  String? price_high_low;
  List<ChoiceOption> choice_options;
  List<String> colors;
  bool? has_discount;
  dynamic discount;
  String? stroked_price;
  String? main_price;
  dynamic calculable_price;
  String? currency_symbol;
  int? current_stock;
  String? unit;
  int? rating;
  int? rating_count;
  int? earn_point;
  String? description;
  String? downloads;
  String? video_link;
  String? link;
  Brand? brand;
  List<Wholesale> wholesale;
  int? estShippingTime;

  factory DetailedProduct.fromJson(Map<String, dynamic> json) =>
      DetailedProduct(
        id: json["id"],
        name: json["name"],
        estShippingTime: json["est_shipping_time"],

        photos: (json["photos"] as List<dynamic>?)
            ?.map((x) => Photo.fromJson(x as Map<String, dynamic>))
            .toList() ?? <Photo>[],
        thumbnail_image: FileHelper.buildFullImageUrl(json['thumbnail_image']),
        tags: (json["tags"] as List<dynamic>?)
            ?.map((x) => x.toString())
            .toList() ?? <String>[],
        price_high_low: json["price_high_low"],
        choice_options: (json["choice_options"] as List<dynamic>?)
            ?.map((x) => ChoiceOption.fromJson(x as Map<String, dynamic>))
            .toList() ?? <ChoiceOption>[],
        colors: (json["colors"] as List<dynamic>?)
            ?.map((x) => x.toString())
            .toList() ?? <String>[],
        has_discount: json["has_discount"],
        discount: json["discount"],
        stroked_price: json["stroked_price"],
        main_price: json["main_price"],
        calculable_price: json["calculable_price"],
        currency_symbol: json["currency_symbol"],
        current_stock: json["current_stock"],
        unit: json["unit"],
        rating: json["rating"] is int
            ? json["rating"]
            : (json["rating"] as num?)?.toInt(),
        rating_count: json["rating_count"],
        earn_point: json["earn_point"] is int
            ? json["earn_point"]
            : (json["earn_point"] as num?)?.toInt(),
        description: (json["description"] as String?)?.isNotEmpty == true
            ? json['description']
            : "No Description is available",
        downloads: json["downloads"],
        video_link: json["video_link"],
        link: json["link"],
        brand: json["brand"] != null
            ? Brand.fromJson(json["brand"] as Map<String, dynamic>)
            : null,
        wholesale: (json["wholesale"] as List<dynamic>?)
            ?.map((x) => Wholesale.fromJson(x as Map<String, dynamic>))
            .toList() ?? <Wholesale>[],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "est_shipping_time": estShippingTime,
    "photos": List<dynamic>.from(photos.map((x) => x.toJson())),

    "thumbnail_image": thumbnail_image,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "price_high_low": price_high_low,
    "choice_options":
    List<dynamic>.from(choice_options.map((x) => x.toJson())),
    "colors": List<dynamic>.from(colors.map((x) => x)),
    "has_discount": has_discount,
    "discount": discount,
    "stroked_price": stroked_price,
    "main_price": main_price,
    "calculable_price": calculable_price,
    "currency_symbol": currency_symbol,
    "current_stock": current_stock,
    "unit": unit,
    "rating": rating,
    "rating_count": rating_count,
    "earn_point": earn_point,
    "description": description,
    "downloads": downloads,
    "video_link": video_link,
    "link": link,
    if (brand != null) "brand": brand!.toJson(),
    "wholesale": List<dynamic>.from(wholesale.map((x) => x.toJson())),
  };
}

class Brand {
  Brand({
    this.id,
    this.slug,
    this.name,
    this.logo,
  });

  int? id;
  String? slug;
  String? name;
  String? logo;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    slug: json["slug"],
    name: json["name"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "name": name,
    "logo": logo,
  };
}

class Photo {
  Photo({
    this.variant,
    this.path,
  });

  String? variant;
  String? path;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    variant: json["variant"],
    path: json["path"],
  );

  Map<String, dynamic> toJson() => {
    "variant": variant,
    "path": path,
  };
}

class ChoiceOption {
  ChoiceOption({
    this.name,
    this.title,
    required this.options,
  });

  String? name;
  String? title;
  List<String> options;

  factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
    name: json["name"],
    title: json["title"],
    options: (json["options"] as List<dynamic>?)
        ?.map((x) => x.toString())
        .toList() ?? <String>[],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "title": title,
    "options": List<dynamic>.from(options.map((x) => x)),
  };
}

class Wholesale {
  Wholesale({
    this.minQty,
    this.maxQty,
    this.price,
  });

  dynamic minQty;
  dynamic maxQty;
  dynamic price;

  factory Wholesale.fromJson(Map<String, dynamic> json) => Wholesale(
    minQty: json["min_qty"],
    maxQty: json["max_qty"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "min_qty": minQty,
    "max_qty": maxQty,
    "price": price,
  };
}
