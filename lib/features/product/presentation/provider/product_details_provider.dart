import 'package:crafty_bay/app/set_up_network_caller.dart';
import 'package:crafty_bay/core/services/network_caller.dart';
import 'package:crafty_bay/features/product/data/models/product_details_model.dart';
import 'package:flutter/material.dart';

import '../../../../app/urls.dart';

class ProductDetailsProvider extends ChangeNotifier {
  bool _getProductDetailsInProgress = false;
  bool get getProductDetailsInProgress => _getProductDetailsInProgress;

  ProductDetailsModel? _productDetailsModel;
  ProductDetailsModel? get productDetailsModel => _productDetailsModel;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;



  //Method for api call
  Future<bool> getProductDetails(String productId) async {
    bool isSuccess = false;
    _getProductDetailsInProgress = true;
    notifyListeners();


    //api call
    final NetworkResponse response = await getNetworkCaller().getRequest(
      url: Urls.productDetailsUrl(productId), errMsg: 'Something went wrong'
    );

    if (response.isSuccess) {
      _productDetailsModel = ProductDetailsModel.fromJson(response.responseData['data']);
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }


_getProductDetailsInProgress= false;
    notifyListeners();
    return isSuccess;
  }

}
