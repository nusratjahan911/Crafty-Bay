import 'package:crafty_bay/app/asset_paths.dart';
import 'package:crafty_bay/features/category/presentation/provider/category_list_provider.dart';
import 'package:crafty_bay/features/common/presentation/provider/main_nav_holder_provider.dart';
import 'package:crafty_bay/features/common/presentation/widgets/center_circular_progress.dart';
import 'package:crafty_bay/features/common/presentation/widgets/snack_bar_message.dart';
import 'package:crafty_bay/features/home/presentation/provider/home_products_provider.dart';
import 'package:crafty_bay/features/home/presentation/provider/home_slider_provider.dart';
import 'package:crafty_bay/features/home/presentation/screens/update_profile_screen.dart';
import 'package:crafty_bay/features/home/presentation/widgets/home_carousel_slider.dart';
import 'package:crafty_bay/features/product/data/models/product_details_model.dart';
import 'package:crafty_bay/features/product/data/models/product_model.dart';
import 'package:crafty_bay/features/product/presentation/provider/product_details_provider.dart';
import 'package:crafty_bay/features/product/presentation/provider/product_list_by_category_provider.dart';
import 'package:crafty_bay/features/product/presentation/screens/product_details_by_slug_screen.dart';
import 'package:crafty_bay/features/wish_list/presentation/provider/add_wish_list_provider.dart';
import 'package:crafty_bay/features/wish_list/presentation/provider/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/screens/sign_up_screen.dart';
import '../../../common/presentation/widgets/category_card.dart';
import '../../../common/presentation/widgets/product_card.dart';
import '../widgets/circle_icon_button.dart';
import '../widgets/product_search_field.dart';
import '../widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar method
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 8,
            children: [
              // search widget
              ProductSearchField(),
              Consumer<HomeSliderProvider>(
                builder: (context, homeSliderProvider, _) {
                  if (homeSliderProvider.getHomeSliderInProgress) {
                    return SizedBox(
                      height: 200,
                      child: CenterCircularProgress(),
                    );
                  }
                  return HomeCarouselSlider(
                    sliders: homeSliderProvider.homeSliders,
                  );
                },
              ),
              SectionHeader(
                title: 'Categories',
                onTapSeeAll: () {
                  context.read<MainNavHolderProvider>().changeToCategories();
                },
              ),
              _buildCategoryList(),
              SectionHeader(
                title: 'Popular',
                onTapSeeAll: () {
                  Map<String, dynamic> map = {"title":"Popular", 'slug': '67c35af85e8a445235de197b'};
                  Navigator.pushNamed(context, ProductDetailsBySlugScreen.name, arguments: map);
                },
              ),
              _buildPopularProductList(),
              SectionHeader(title: 'Special', onTapSeeAll: () {
                Map<String, dynamic> map = {"title":"Special", 'slug': '67c35af85e8a445235de197b'};
                Navigator.pushNamed(context, ProductDetailsBySlugScreen.name, arguments: map);
              }),
              _buildSpecialProductList(),
              SectionHeader(title: 'New', onTapSeeAll: () {
                Map<String, dynamic> map = {"title":"New", 'slug': '67c35af85e8a445235de197b'};
                Navigator.pushNamed(context, ProductDetailsBySlugScreen.name, arguments: map);
              }),
              _buildNewProductList(),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildNewProductList() {
    return SizedBox(
      height: 170,
      child: Consumer<HomeProductsProvider>(
        builder: (context, provider,_) {
          final List<ProductModel> productList = provider.newProductList;
          if(provider.getNewListInProgress){
            return CenterCircularProgress();
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return ProductCard(productModel: product, onTapFavourite: () { _onTapAddToWishList(productId: product.id); }, fromWishList: false,);
            },
          );
        }
      ),
    );
  }

  Widget _buildSpecialProductList() {
    return SizedBox(
      height: 170,
      child: Consumer<HomeProductsProvider>(
        builder: (context, provider,_) {
          final List<ProductModel> productList = provider.specialProductList;
          if(provider.getSpecialListInProgress){
            return CenterCircularProgress();
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return ProductCard(productModel: product, onTapFavourite: () { _onTapAddToWishList(productId: product.id); }, fromWishList: false,);
            },
          );
        }
      ),
    );
  }

  Widget _buildPopularProductList() {
    return _buildSpecialProductList();
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 85,
      child: Consumer<CategoryListProvider>(
        builder: (context, categoryListProvider, _) {
          if (categoryListProvider.initialLoading) {
            return CenterCircularProgress();
          }
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categoryListProvider.categoryList.length > 10
                ? 10
                : categoryListProvider.categoryList.length,
            itemBuilder: (context, index) {
              return CategoryCard(
                categoryModel: categoryListProvider.categoryList[index],
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 8),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        spacing: 4,
        children: [
          SvgPicture.asset(AssetPaths.navLogoSvg),
          Spacer(),
          CircleIconButton(onTap: () {
           _onTapUpdateProfileButton();
          }, icon: Icons.person),
          CircleIconButton(onTap: () {}, icon: Icons.call),
          CircleIconButton(onTap: () {}, icon: Icons.notifications_active_outlined,),
        ],
      ),
    );
  }

  void _onTapUpdateProfileButton(){
    Navigator.push(context, MaterialPageRoute(builder: (_)=> UpdateProfileScreen()));
    
  }


  Future<void> _onTapAddToWishList({required String productId})async{
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
