
class CartItemModel{
  final String id;
  final String title;
  final String photoUrl;
  final String? color;
  final String? size;
  final int selectedQuantity ;
  final int availableProduct;
  final int currentPrice;

  CartItemModel({
    required this.id,
    required this.title,
    required this.photoUrl,
    required this.color,
    required this.size,
    required this.selectedQuantity,
    required this.availableProduct,
    required this.currentPrice

});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json["_id"] ,
      title: json["product"]['title'],
      photoUrl: json["product"]['photos'][0] ?? '' ,
      color: json["color"],
      size: json['size'],
      selectedQuantity: json['quantity'],
      availableProduct: json['product']['quantity'],
      currentPrice: json['product']['current_price'],

    );
  }
}