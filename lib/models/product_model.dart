// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

class Product {
    int id;
    String title;
    double price;
    String thumbnail;

    Product({
        required this.id,
        required this.title,
        required this.price,
        required this.thumbnail,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        price: json["price"]?.toDouble(),
        thumbnail: json["thumbnail"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "thumbnail": thumbnail,
    };
}
