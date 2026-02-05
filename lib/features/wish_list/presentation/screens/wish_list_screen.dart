import 'package:crafty_bay/features/common/presentation/widgets/center_circular_progress.dart';
import 'package:crafty_bay/features/common/presentation/widgets/snack_bar_message.dart';
import 'package:crafty_bay/features/wish_list/data/models/wish_list_model.dart';
import 'package:crafty_bay/features/wish_list/presentation/provider/delete_wish_list_provider.dart';
import 'package:crafty_bay/features/wish_list/presentation/provider/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/presentation/provider/main_nav_holder_provider.dart';
import '../../../common/presentation/widgets/product_card.dart';


class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {

  final ScrollController _scrollController = ScrollController();




  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, __){
        context.read<MainNavHolderProvider>().backToHome();
      },
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            context.read<MainNavHolderProvider>().backToHome();
          }, icon: Icon(Icons.arrow_back)),
          title: Text('Wish list '),),

        body: Consumer<WishListProvider>(
          builder: (context,provider,_) {
            if(provider.wishListInProgress){
              return CenterCircularProgress();
            }
            return Column(
              children: [
                Expanded(
                  child: Consumer<WishListProvider>(
                    builder: (context,wishListProvider,_) {
                      if(wishListProvider.wishListInProgress){
                        return CenterCircularProgress();
                      }
                      return GridView.builder(
                        controller: _scrollController,
                        itemCount: wishListProvider.wishList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          WishListModel model = wishListProvider.wishList[index];
                         return FittedBox(child: ProductCard( productModel: model.productModel, onTapFavourite: () { onTapFavoriteButton(wishListId: model.id, deleteProductId: model.productModel.id); }, fromWishList: true,wishListId: model.id, ));
                        },
                      );
                    }
                  ),
                ),
                if(context.read<WishListProvider>().loadMoreData)CenterCircularProgress(),

              ],
            );
          }
        ),
      ),

    );
  }


  ///delete wish list item from wish list
  Future<void> onTapFavoriteButton({required String wishListId, required String deleteProductId})async{
    bool isSuccess = await context.read<DeleteWishListProvider>().deleteWishListItem(wishListId: wishListId, deleteProductId: deleteProductId);

    if(isSuccess){
      ShowSnackBarMessage(context, 'Delete from wishlist!!!');
      context.read<WishListProvider>().loadInitialWishList();
    }
  }
}
