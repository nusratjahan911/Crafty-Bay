import 'package:crafty_bay/features/auth/presentation/providers/auth_controller.dart';
import 'package:crafty_bay/features/cart/presentation/widgets/inc_dec_button.dart';
import 'package:crafty_bay/features/common/presentation/provider/add_to_cart_provider.dart';
import 'package:crafty_bay/features/common/presentation/widgets/center_circular_progress.dart';
import 'package:crafty_bay/features/common/presentation/widgets/rating_view.dart';
import 'package:crafty_bay/features/product/data/models/product_model.dart';
import 'package:crafty_bay/features/product_review/data/models/review_model.dart';
import 'package:crafty_bay/features/product/presentation/provider/product_details_by_slug_provider.dart';
import 'package:crafty_bay/features/product/presentation/provider/product_details_provider.dart';
import 'package:crafty_bay/features/product_review/presentation/screens/product_review_screen.dart';
import 'package:crafty_bay/features/product/presentation/widgets/color_picker.dart';
import 'package:crafty_bay/features/product/presentation/widgets/product_image_slider.dart';
import 'package:crafty_bay/features/product/presentation/widgets/size_picker.dart';
import 'package:crafty_bay/features/wish_list/presentation/provider/delete_wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/constants.dart';
import '../../../auth/presentation/screens/sign_up_screen.dart';
import '../../../common/presentation/widgets/favourite_button.dart';
import '../../../common/presentation/widgets/snack_bar_message.dart';
import '../../../wish_list/presentation/provider/add_wish_list_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId, required this.fromWishList, this.wishlistId});

  static const name = '/product-details';
  final String productId;
  final bool fromWishList;
  final String? wishlistId;

  

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductDetailsProvider _productDetailsProvider = ProductDetailsProvider();
  final AddToCartProvider _addToCartProvider = AddToCartProvider();

  int quantity = 1;
  String? size;
  String? color;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _productDetailsProvider.getProductDetails(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => _productDetailsProvider),
          ChangeNotifierProvider(create: (_) => _addToCartProvider)
        ],
        child: Consumer<ProductDetailsProvider>(
          builder: (context, productDetailsProvider, _) {
            if (_productDetailsProvider.getProductDetailsInProgress) {
              return CenterCircularProgress();
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ProductImageSlider(
                          imageUrls:
                              _productDetailsProvider
                                  .productDetailsModel
                                  ?.photos ??
                              [],
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _productDetailsProvider
                                              .productDetailsModel
                                              ?.title ??
                                          '',
                                      style: textTheme.titleMedium,
                                    ),
                                  ),
                                  IncDecButton(
                                    maxvalue:
                                        _productDetailsProvider
                                            .productDetailsModel
                                            ?.quantity ??
                                        20,
                                    onChange: (newValue) {
                                      quantity = newValue;
                                    }, quantity: quantity,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  RatingView(),
                                  TextButton(
                                    onPressed: _onTapReviewButton,
                                    child: Text('Reviews'),
                                  ),
                                  ///FavouriteButton(pro),
                                ],
                              ),
                              if (_productDetailsProvider
                                      .productDetailsModel
                                      ?.colors
                                      .isNotEmpty ??
                                  false)
                                Text('Color', style: textTheme.titleMedium),
                              SizedBox(height: 8),
                              ColorPicker(
                                colors:
                                    _productDetailsProvider
                                        .productDetailsModel
                                        ?.colors ??
                                    [],
                                onChange: (selectedColor) {},
                              ),
                              SizedBox(height: 16),
                              if (_productDetailsProvider
                                      .productDetailsModel
                                      ?.sizes
                                      .isNotEmpty ??
                                  false)
                                Text('Size', style: textTheme.titleMedium),
                              SizedBox(height: 8),
                              SizePicker(
                                sizes:
                                    _productDetailsProvider
                                        .productDetailsModel
                                        ?.sizes ??
                                    [],
                                onChange: (selectedSize) {
                                  size = selectedSize;
                                },
                              ),
                              SizedBox(height: 16),
                              Text('Description', style: textTheme.titleMedium),
                              SizedBox(height: 8),
                              Text(
                                _productDetailsProvider
                                        .productDetailsModel
                                        ?.description ??
                                    '',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildPriceAndAddToCartSection(textTheme),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPriceAndAddToCartSection(TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: AppColours.themeColor.withAlpha(40),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price', style: textTheme.bodyLarge),
              Text(
                '${Constants.takaSign}${_productDetailsProvider.productDetailsModel?.price ?? ''}',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColours.themeColor,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 120,
            child: Consumer<AddToCartProvider>(
              builder: (context,provider, _) {
                if(provider.addToCartInProgress){
                  return CenterCircularProgress();
                }
                return FilledButton(
                  onPressed: _onTapAddToCartButton,
                  child: Text('Add to cart'),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onTapAddToCartButton() async {
    if (await AuthController.isAlreadyLoggedIn()) {
      final bool isSuccess = await _addToCartProvider.addToCart(productId: widget.productId, quantity:quantity,size:size,color: color);
      if(isSuccess){
        ShowSnackBarMessage(context, 'Added to Cart!');
      }else{
        ShowSnackBarMessage(context, _addToCartProvider.errorMessage!);
      }
    } else {
      Navigator.pushNamed(context, SignUpScreen.name);
    }
  }
  

  void _onTapReviewButton() {
    Navigator.pushNamed(context, ProductReviewScreen.name,arguments: widget.productId);
  }
  
  
  
  Future<void> _onTapAddToWishList()async{
    if(widget.fromWishList){
      bool isSuccess = await context.read<DeleteWishListProvider>().deleteWishListItem(wishListId: widget.wishlistId!, deleteProductId: widget.productId);

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
