import 'package:crafty_bay/features/product/data/models/product_model.dart';

class WishListModel {
  final String id;
  final ProductModel productModel;

  WishListModel({required this.id, required this.productModel});

  factory WishListModel.fromJson(Map<String, dynamic> json) {
    return WishListModel(
      id: json['_id'],
      productModel: ProductModel.fromJson(json['product']),
    );
  }
}