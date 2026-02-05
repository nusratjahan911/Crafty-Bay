import 'package:crafty_bay/app/app_colors.dart';
import 'package:crafty_bay/app/constants.dart';
import 'package:crafty_bay/features/cart/presentation/provider/cart_item_list_provider.dart';
import 'package:crafty_bay/features/common/presentation/provider/main_nav_holder_provider.dart';
import 'package:crafty_bay/features/common/presentation/widgets/center_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';


class CartListScreen extends StatefulWidget {
  const CartListScreen({super.key});

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {

 final CartItemListProvider _cartItemListProvider = CartItemListProvider();

 @override
  void initState() {
    super.initState();
    _cartItemListProvider.getCartItemList();
  }



  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return PopScope(
      onPopInvokedWithResult: (_, __) {
        context.read<MainNavHolderProvider>().backToHome();
      },
      canPop: false,
      
      child: Scaffold(
        appBar: AppBar(
            leading:IconButton(onPressed: (){
              context.read<MainNavHolderProvider>().backToHome();
            }, icon: Icon(Icons.arrow_back)),
            title: Text('Cart list')),

        body: Consumer<CartItemListProvider>(
          builder: (context,_,_) {
            if(_cartItemListProvider.cartItemInProgress){
              return CenterCircularProgress();
            }
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: _cartItemListProvider.cartItemList.length,
                      itemBuilder: (context, index) {
                        return CartItem(cartItemModel: _cartItemListProvider.cartItemList[index],
                        );
                      },
                    ),
                  ),
                ),
                _buildTotalPriceAndCheckoutSection(textTheme),
              ],
            );
          }
        ),
      ),
    );
  }

  Consumer<CartItemListProvider> _buildTotalPriceAndCheckoutSection(TextTheme textTheme) {
    return Consumer<CartItemListProvider>(
      builder: (context,provider,_) {

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
                  Text('Total Price', style: textTheme.bodyLarge),
                  Text(
                    '${Constants.takaSign}${provider.totalAmount}',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColours.themeColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 120,
                child: FilledButton(
                  onPressed: () {},
                  child: Text('Checkout'),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

