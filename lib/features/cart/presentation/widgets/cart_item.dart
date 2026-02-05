import 'package:crafty_bay/features/cart/data/models/cart_model.dart';
import 'package:crafty_bay/features/cart/presentation/provider/cart_item_list_provider.dart';
import 'package:crafty_bay/features/common/presentation/widgets/center_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/constants.dart';
import 'inc_dec_button.dart';

class CartItem extends StatefulWidget {
  const CartItem({
    super.key, required this.cartItemModel,
  });
  final CartItemModel cartItemModel;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    var payAmount = widget.cartItemModel.currentPrice * widget.cartItemModel.selectedQuantity;


    return Card(
      elevation: 3,
      color: Colors.white,
      shadowColor: AppColours.themeColor.withAlpha(50),
      child: Row(
        spacing: 4,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Image.network(
              widget.cartItemModel.photoUrl,
              width: 70,
              height: 90,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cartItemModel.title,
                              maxLines: 1,
                              style: textTheme.bodyLarge?.copyWith(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              'Color: ${widget.cartItemModel.color ?? '_'}  Size: ${widget.cartItemModel.size ?? '_'}',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),


                     ///delete button
                      Consumer<CartItemListProvider>(
                        builder: (context,provider,_) {
                          if(widget.cartItemModel.id == provider.deleteCartId){
                            return SizedBox(
                              width: 24,
                              height: 24,
                              child: CenterCircularProgress(),
                            );
                          }
                          return IconButton(
                            onPressed: () {
                              provider.deleteCartItem(cartId: widget.cartItemModel.id);
                            },
                            icon: Icon(Icons.delete, color: Colors.grey),
                          );
                        }
                      ),
                    ],
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                    '${Constants.takaSign}$payAmount',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColours.themeColor,
                        ),
                      ),

                      ///update button
                      IncDecButton(onChange: (int value) {
                        context.read<CartItemListProvider>().updateCartItem(cartId: widget.cartItemModel.id, quantity: value);
                      },
                        quantity: widget.cartItemModel.selectedQuantity,
                        maxvalue: widget.cartItemModel.availableProduct,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}