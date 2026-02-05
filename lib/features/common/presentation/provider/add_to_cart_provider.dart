import 'package:crafty_bay/app/set_up_network_caller.dart';
import 'package:crafty_bay/core/services/network_caller.dart';
import 'package:flutter/cupertino.dart';

import '../../../../app/urls.dart';

class AddToCartProvider extends ChangeNotifier {
  bool _addToCartInProgress = false;

  bool get addToCartInProgress => _addToCartInProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> addToCart({required String productId,required int quantity, String? color, String? size}) async {
    bool isSuccess = false;

    _addToCartInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      'product': productId,
      'quantity': quantity,
      'color': color,
      'size': size
    };

    final NetworkResponse response = await getNetworkCaller().postRequest(
      url: Urls.addToCartUrl,
      errMsg: 'Something went wrong',
      body: requestBody
    );


    if(response.isSuccess){
      isSuccess = true;
      _errorMessage = null;

    }else{
      _errorMessage = response.errorMessage;

    }

    _addToCartInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
