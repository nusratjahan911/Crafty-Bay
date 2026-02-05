class ProductModel {
  final String id;
  final String title;
  final String photos;
  final int currentPrice;




  ProductModel({
    required this.id,
    required this.title,
    required this.photos,
    required this.currentPrice,


  });


  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final List photos = json['photos'] ?? [];
    return ProductModel(
      id: json['_id'],
      title: json['title'],
      photos: photos.isNotEmpty ? photos.first : null,//json['photos'][0]
      currentPrice: json['current_price'],
    );
  }



}
