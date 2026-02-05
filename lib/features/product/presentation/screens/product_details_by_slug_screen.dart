import 'package:crafty_bay/features/common/presentation/widgets/center_circular_progress.dart';
import 'package:crafty_bay/features/product/presentation/provider/product_details_by_slug_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/screens/sign_up_screen.dart';
import '../../../common/presentation/widgets/product_card.dart';
import '../../../common/presentation/widgets/snack_bar_message.dart';
import '../../../wish_list/presentation/provider/add_wish_list_provider.dart';

class ProductDetailsBySlugScreen extends StatefulWidget {
  const ProductDetailsBySlugScreen({super.key, required this.slug, required this.title});

  static final String name = '/product-list-by-slug';

  final String slug;
  final String title;

  @override
  State<ProductDetailsBySlugScreen> createState() => _ProductDetailsBySlugScreenState();
}

class _ProductDetailsBySlugScreenState extends State<ProductDetailsBySlugScreen> {

  final ProductDetailsBySlugProvider _productDetailsBySlugProvider = ProductDetailsBySlugProvider();
  final ScrollController _scrollController = ScrollController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ChangeNotifierProvider(
        create: (context) => _productDetailsBySlugProvider,
        child: Consumer<ProductDetailsBySlugProvider>(
            builder: (context, _, _) {
              if(_productDetailsBySlugProvider.productBySlugInProgress){
                return CenterCircularProgress();
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        itemCount: _productDetailsBySlugProvider.productList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 0
                        ),
                        itemBuilder: (context, index) {
                          final product = _productDetailsBySlugProvider.productList[index];
                          return FittedBox(child: ProductCard(productModel: product, onTapFavourite: ()=> _onTapAddWishList(productId: product.id), fromWishList: false));
                        },
                      ),
                    ),
                    if(_productDetailsBySlugProvider.loadingMoreData)
                      CenterCircularProgress()
                  ],
                ),
              );
            }
        ),
      ),
    );
  }

  Future<void> _onTapAddWishList({required String productId}) async {
    if(await AuthController.isAlreadyLoggedIn()){
      final bool isSuccess = await context.read<AddWishListProvider>().addWishList(productId: productId);
      if(isSuccess){
        ShowSnackBarMessage(context, 'Added to wish list!');
      }else{
        ShowSnackBarMessage(context, context.read<AddWishListProvider>().errorMessage!);
      }
    }else{
      Navigator.pushNamed(context, SignUpScreen.name);
    }
  }
}
