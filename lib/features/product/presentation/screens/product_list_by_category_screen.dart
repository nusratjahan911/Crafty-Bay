import 'package:crafty_bay/features/category/data/models/category_model.dart';
import 'package:crafty_bay/features/common/presentation/widgets/center_circular_progress.dart';
import 'package:crafty_bay/features/common/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/screens/sign_up_screen.dart';
import '../../../common/presentation/widgets/snack_bar_message.dart';
import '../../../wish_list/presentation/provider/add_wish_list_provider.dart';
import '../provider/product_list_by_category_provider.dart';

class ProductListByCategoryScreen extends StatefulWidget {
  const ProductListByCategoryScreen({super.key, required this.categoryModel});

  static const String name = '/product-list-by-category';

  final CategoryModel categoryModel;

  @override
  State<ProductListByCategoryScreen> createState() =>
      _ProductListByCategoryScreenState();
}

class _ProductListByCategoryScreenState
    extends State<ProductListByCategoryScreen> {
  late final ProductListByCategoryProvider _productListByCategoryProvider =
      ProductListByCategoryProvider();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _productListByCategoryProvider.loadInitialProductList(widget.categoryModel.id);
      _scrollController.addListener(_loadMoreData);
    });
  }

  void _loadMoreData() {
    if (_productListByCategoryProvider.moreLoading) {
      return;
    }
    if (_scrollController.position.extentBefore < 300) {
      _productListByCategoryProvider.fetchProductList(widget.categoryModel.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryModel.title)),
      body: ChangeNotifierProvider(
        create: (_) => _productListByCategoryProvider,
        child: Consumer<ProductListByCategoryProvider>(
          builder: (context, _, _) {
            if (_productListByCategoryProvider.initialLoading) {
              return CenterCircularProgress();
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: _productListByCategoryProvider.productList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final product =
                      _productListByCategoryProvider.productList[index];
                  return FittedBox(child: ProductCard(productModel: product, onTapFavourite: () {  }, fromWishList: false,));
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _onTapAdToWishList({required String productId})async{
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
