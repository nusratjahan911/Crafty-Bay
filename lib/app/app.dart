import 'package:crafty_bay/app/app_routes.dart';
import 'package:crafty_bay/app/app_theme.dart';
import 'package:crafty_bay/app/providers/language_provider.dart';
import 'package:crafty_bay/app/providers/theme_provider.dart';
import 'package:crafty_bay/features/auth/presentation/screens/splash_screen.dart';
import 'package:crafty_bay/features/cart/presentation/provider/cart_item_list_provider.dart';
import 'package:crafty_bay/features/category/presentation/provider/category_list_provider.dart';
import 'package:crafty_bay/features/common/presentation/provider/main_nav_holder_provider.dart';
import 'package:crafty_bay/features/home/presentation/provider/home_products_provider.dart';
import 'package:crafty_bay/features/home/presentation/provider/home_slider_provider.dart';
import 'package:crafty_bay/features/home/presentation/provider/update_profile_provider.dart';
import 'package:crafty_bay/features/product_review/presentation/provider/product_review_provider.dart';
import 'package:crafty_bay/features/wish_list/presentation/provider/add_wish_list_provider.dart';
import 'package:crafty_bay/features/wish_list/presentation/provider/delete_wish_list_provider.dart';
import 'package:crafty_bay/features/wish_list/presentation/provider/wish_list_provider.dart';
import 'package:crafty_bay/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class CraftyBayApp extends StatefulWidget {
  const CraftyBayApp({super.key});

  @override
  State<CraftyBayApp> createState() => _CraftyBayAppState();
}

class _CraftyBayAppState extends State<CraftyBayApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()..loadInitialLanguage(),),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadInitialThemeMode(),),
        ChangeNotifierProvider(create: (_) => MainNavHolderProvider()),
        ChangeNotifierProvider(create: (_) => CategoryListProvider()),
        ChangeNotifierProvider(create: (_)=> HomeSliderProvider()),
        ChangeNotifierProvider(create: (_)=> CartItemListProvider()),
        ChangeNotifierProvider(create: (_)=> WishListProvider()),
        ChangeNotifierProvider(create: (_)=> HomeProductsProvider()),
        ChangeNotifierProvider(create: (_)=> ProductReviewProvider()),
        ChangeNotifierProvider(create: (_)=> AddWishListProvider()),
        ChangeNotifierProvider(create: (_)=> UpdateProfileProvider()),

      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(



                // router
                //navigatorKey: CraftyBayApp.navigatorKey,
                initialRoute: SplashScreen.name,
                onGenerateRoute: AppRoutes.routes,

                // theme
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                //themeMode: ThemeMode.dark,
                themeMode: context.read<ThemeProvider>().currentThemeMode,

                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],

                supportedLocales: [
                  Locale('en'), // English
                  Locale('bn'), //bangla
                  Locale('de'), //german
                ],
                locale: languageProvider.currentLocale,
              );
            },
          );
        },
      ),
    );
  }
}
