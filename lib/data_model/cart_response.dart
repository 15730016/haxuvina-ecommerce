// To parse this JSON data, do
//
//     final cartResponse = cartResponseFromJson(jsonString);

import 'dart:convert';

import '../helpers/file_helper.dart';

CartResponse cartResponseFromJson(String str) =>
    CartResponse.fromJson(json.decode(str));

String cartResponseToJson(CartResponse data) => json.encode(data.toJson());

class CartResponse {
  String? grandTotal;
  List<CartItem>? cartItems;

  CartResponse({
    this.grandTotal,
    this.cartItems,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    List<CartItem> allCartItems = [];
    if (json["data"] != null && json["data"] is List) {
      allCartItems = List<CartItem>.from(
        json["data"].map((x) => CartItem.fromJson(x)),
      );
    }

    return CartResponse(
      grandTotal: json["grand_total"],
      cartItems: allCartItems,
    );
  }

  Map<String, dynamic> toJson() => {
        "grand_total": grandTotal,
        "cart_items": cartItems == null
            ? []
            : List<dynamic>.from(cartItems!.map((x) => x.toJson())),
      };
}


class CartItem {
  int? id;
  int? ownerId;
  int? userId;
  int? productId;
  String? productName;
  int? auctionProduct;
  String? productThumbnailImage;
  String? variation;
  String? price;
  String? currencySymbol;
  String? tax;
  int? shippingCost;
  int? quantity;
  int? lowerLimit;
  int? upperLimit;

  CartItem({
    this.id,
    this.ownerId,
    this.userId,
    this.productId,
    this.productName,
    this.auctionProduct,
    this.productThumbnailImage,
    this.variation,
    this.price,
    this.currencySymbol,
    this.tax,
    this.shippingCost,
    this.quantity,
    this.lowerLimit,
    this.upperLimit,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json["id"],
        ownerId: json["owner_id"],
        userId: json["user_id"],
        productId: json["product_id"],
        productName: json["product_name"],
        auctionProduct: json["auction_product"],
        productThumbnailImage: FileHelper.buildFullImageUrl(json['product_thumbnail_image']),
        variation: json["variation"],
        price: json["price"],
        currencySymbol: json["currency_symbol"],
        tax: json["tax"],
        shippingCost: json["shipping_cost"],
        quantity: json["quantity"],
        lowerLimit: json["lower_limit"],
        upperLimit: json["upper_limit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "owner_id": ownerId,
        "user_id": userId,
        "product_id": productId,
        "product_name": productName,
        "auction_product": auctionProduct,
        "product_thumbnail_image": productThumbnailImage,
        "variation": variation,
        "price": price,
        "currency_symbol": currencySymbol,
        "tax": tax,
        "shipping_cost": shippingCost,
        "quantity": quantity,
        "lower_limit": lowerLimit,
        "upper_limit": upperLimit,
      };
}
