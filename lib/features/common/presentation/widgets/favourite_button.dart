import 'package:crafty_bay/features/wish_list/presentation/provider/delete_wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_colors.dart';
import '../../../wish_list/presentation/provider/add_wish_list_provider.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({
    super.key,
    required this.productId,
    required this.onTapFavoriteIcon,
  });

  final String productId;
  final VoidCallback onTapFavoriteIcon;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: AppColours.themeColor,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: GestureDetector(
          onTap: widget.onTapFavoriteIcon,
          child: Consumer<AddWishListProvider>(
            builder: (context,provider,_) {

              if(provider.addWishListInProgress){
                return SizedBox(
                  width: 18,
                  height: 18,
                  child: Center(child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2,),),
                );
              }
              return Consumer<DeleteWishListProvider>(
                builder: (context,provider,_) {
                  if(provider.deleteWishListItemInProgress){
                    if(provider.deleteProductId == widget.productId){
                      return SizedBox(
                        width: 18,
                        height: 18,
                        child: Center(child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2,),),
                      );
                    }
                  }
                  return Icon(
                    Icons.favorite_border_rounded,
                    size: 18,
                    color: Colors.white,
                  );
                }
              );
            }
          ),
        ),
      ),
    );
  }
}
