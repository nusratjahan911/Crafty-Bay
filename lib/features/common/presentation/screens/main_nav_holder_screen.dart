import 'package:crafty_bay/app/app_colors.dart';
import 'package:crafty_bay/features/auth/presentation/providers/auth_controller.dart';
import 'package:crafty_bay/features/cart/presentation/screens/cart_list_screen.dart';
import 'package:crafty_bay/features/category/presentation/provider/category_list_provider.dart';
import 'package:crafty_bay/features/category/presentation/screens/category_list_screen.dart';
import 'package:crafty_bay/features/common/presentation/provider/main_nav_holder_provider.dart';
import 'package:crafty_bay/features/home/presentation/provider/home_products_provider.dart';
import 'package:crafty_bay/features/home/presentation/provider/home_slider_provider.dart';
import 'package:crafty_bay/features/home/presentation/screens/home_screen.dart';
import 'package:crafty_bay/features/more/settings_screen.dart';
import 'package:crafty_bay/features/wish_list/presentation/screens/wish_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/presentation/screens/sign_up_screen.dart';

class MainNavHolderScreen extends StatefulWidget {
  const MainNavHolderScreen({super.key});


  static const String name = '/main-bottom-nav-holder';


  @override
  State<MainNavHolderScreen> createState() => _MainNavHolderScreenState();
}

class _MainNavHolderScreenState extends State<MainNavHolderScreen> {

  final token = SharedPreferences.getInstance().then((prefs) => prefs.getString('token') ?? '');

  final List<Widget> _screens = [
    HomeScreen(),
    CategoryListScreen(),
    CartListScreen(),
    WishListScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<CategoryListProvider>().fetchCategoryList();
    context.read<HomeSliderProvider>().getHomeSliders();
    context.read<HomeProductsProvider>().getPopularProductList();
    context.read<HomeProductsProvider>().getSpecialProductList();
    context.read<HomeProductsProvider>().getNewProductList();
  }

  @override
  Widget build(BuildContext context){
    return Consumer<MainNavHolderProvider>(
      builder: (context, mainNavHolderProvider, _ ) {
        return Scaffold(
          body: _screens[mainNavHolderProvider.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor:Colors.grey,
            selectedItemColor: AppColours.themeColor,
            currentIndex: mainNavHolderProvider.selectedIndex,
            onTap: (int index) async {
              if(index ==2 || index == 3){
                if(await AuthController.isAlreadyLoggedIn() == false){
                 Navigator.pushNamed(context, SignUpScreen.name);
                 return;
              }
              }
              mainNavHolderProvider.changeItem(index);
            } ,
            showSelectedLabels: true,

            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_customize),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard_outlined),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'More',
              ),
            ],
          ),
        );
      }
    );
  }
}

