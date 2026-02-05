import 'package:crafty_bay/features/common/presentation/widgets/favourite_button.dart';
import 'package:crafty_bay/features/common/presentation/widgets/rating_view.dart';
import 'package:crafty_bay/features/product/data/models/product_model.dart';
import 'package:crafty_bay/features/product/presentation/screens/product_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/constants.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.productModel, required this.onTapFavourite, required this.fromWishList, this.wishListId});

  final ProductModel productModel;
  final VoidCallback onTapFavourite;
  final bool fromWishList;
  final String? wishListId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Map<String, dynamic> arguments = {
          "productId" : productModel.id,
          "fromWishList" : fromWishList,
          "wishListId" : wishListId
        };
        Navigator.pushNamed(context, ProductDetailsScreen.name,arguments:arguments );
      },
      child: SizedBox(
        width: 150,
        child: Card(
          elevation: 3,
          shadowColor: AppColours.themeColor.withAlpha(50),
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Container(
                width: 160,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                  color: AppColours.themeColor.withAlpha(30),
                  image: DecorationImage(
                    image: NetworkImage(productModel.photos),fit: BoxFit.cover
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productModel.title,
                      maxLines: 1,
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${Constants.takaSign}${productModel.currentPrice}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColours.themeColor,
                          ),
                        ),
                        RatingView(),
                        FavouriteButton(productId: productModel.id, onTapFavoriteIcon: onTapFavourite),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


