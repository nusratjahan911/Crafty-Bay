import 'package:crafty_bay/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:crafty_bay/features/auth/presentation/screens/splash_screen.dart';
import 'package:crafty_bay/features/category/data/models/category_model.dart';
import 'package:crafty_bay/features/common/presentation/screens/main_nav_holder_screen.dart';
import 'package:crafty_bay/features/home/presentation/screens/update_profile_screen.dart';
import 'package:crafty_bay/features/product_review/data/models/review_model.dart';
import 'package:crafty_bay/features/product_review/presentation/screens/create_product_review_screen.dart';
import 'package:crafty_bay/features/product/presentation/screens/product_details_by_slug_screen.dart';
import 'package:crafty_bay/features/product/presentation/screens/product_details_screen.dart';
import 'package:crafty_bay/features/product/presentation/screens/product_list_by_category_screen.dart';
import 'package:crafty_bay/features/product_review/presentation/screens/product_review_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/auth/presentation/screens/sign_in_screen.dart';

class AppRoutes {
  static Route<dynamic> routes(RouteSettings settings){
    Widget widget = SizedBox();

    if (settings.name == SplashScreen.name) {
      widget = SplashScreen();
    }else if (settings.name == SignUpScreen.name) {
      widget = SignUpScreen();
    }else if (settings.name == OTPScreen.name) {
      final email = settings.arguments as String;
      widget = OTPScreen(email: email);
    }else if (settings.name == SignInScreen.name) {
      widget = SignInScreen();
    }else if (settings.name == MainNavHolderScreen.name) {
      widget = MainNavHolderScreen();
    }else if (settings.name == ProductListByCategoryScreen.name) {
      final CategoryModel categoryModel = settings.arguments as CategoryModel;
      widget = ProductListByCategoryScreen(categoryModel: categoryModel);
    }else if (settings.name == ProductDetailsScreen.name) {
      final Map<String, dynamic> map = settings.arguments as Map<String,dynamic>;
      final String productId = map['productId'];
      final bool fromWishList = map['fromWishList'];
      final String? wishListId = map['wishListId'];
      widget = ProductDetailsScreen(productId: productId, fromWishList: fromWishList,wishlistId: wishListId ?? '',);
    }else if(settings.name == ProductReviewScreen.name){
      final productId = settings.arguments as String;
      widget = ProductReviewScreen(productId: productId);
    }else if(settings.name == CreateProductReviewScreen.name){
      final Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
      final String productId = map['productId'];
      final ReviewModel? model = map['reviewModel'];
      widget = CreateProductReviewScreen(productId: productId,reviewModel: model);
    }else if(settings.name == UpdateProfileScreen) {
      widget = UpdateProfileScreen();
    }else if(settings.name == ProductDetailsBySlugScreen.name){
      final Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
      final String title = map['title'];
      final String slug = map['slug'];
      widget = ProductDetailsBySlugScreen(slug: slug, title: title,);

    }


    return MaterialPageRoute(builder: (ctx) => widget);
  }
}