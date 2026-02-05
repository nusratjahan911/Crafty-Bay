import 'package:crafty_bay/app/set_up_network_caller.dart';
import 'package:crafty_bay/app/urls.dart';
import 'package:crafty_bay/core/services/network_caller.dart';
import 'package:crafty_bay/features/cart/data/models/cart_model.dart';
import 'package:flutter/material.dart';

class CartItemListProvider extends ChangeNotifier {
  bool _cartItemInProgress = false;
  String? _errorMessage;

  bool get cartItemInProgress => _cartItemInProgress;

  String? get errorMessage => _errorMessage;
  List<CartItemModel> _cartItemList = [];

  List<CartItemModel> get cartItemList => _cartItemList;
  double _totalAmount = 0;

  double get totalAmount => _totalAmount;

  Future<bool> getCartItemList() async {
    bool isSuccess = false;

    _cartItemInProgress = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().getRequest(
      url: Urls.cartItemListUrl,
      errMsg: 'Item not found',

    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;

      _totalAmount = 0;

      List<CartItemModel> list = [];
      for (Map<String, dynamic> cartList
          in response.responseData['data']['results']) {
        var productPrice = cartList['product']['current_price'];
        var quantity = cartList['quantity'];
        _totalAmount = _totalAmount + productPrice * quantity;
        list.add(CartItemModel.fromJson(cartList));
      }
      _cartItemList = list;
      _cartItemInProgress = false;
      notifyListeners();
    } else {
      _errorMessage = response.errorMessage;
    }

    return isSuccess;
  }


  ///update cart item
  Future<void> updateCartItem({
    required String cartId,
    required int quantity,
  }) async {
    Map<String, dynamic> requestBody = {"quantity": quantity};

    NetworkResponse response = await getNetworkCaller().patchRequest(
      url: Urls.updateCartItemUrl(cartId),
      body: requestBody,
      errMsg: 'Item not updated',
    );

    if(response.isSuccess){
      getCartItemList();
    }
  }


  ///delete cart item

bool _deleteCartItemInProgress = false;
  bool get deleteCartItemInProgress => _deleteCartItemInProgress;
  String? _deleteCartId;
  String? get deleteCartId => _deleteCartId;

  Future<void> deleteCartItem({required String cartId})async{
    _deleteCartItemInProgress = true;
    _deleteCartId = cartId;
    notifyListeners();

    NetworkResponse response = await getNetworkCaller().deleteRequest(url: Urls.deleteCartItemUrl(cartId));

    _deleteCartItemInProgress = false;
    notifyListeners();

    if(response.isSuccess){
      getCartItemList();
    }
  }


}
