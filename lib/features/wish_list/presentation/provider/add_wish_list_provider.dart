import 'package:flutter/cupertino.dart';

import '../../../../app/set_up_network_caller.dart';
import '../../../../app/urls.dart';

import '../../../../core/services/network_caller.dart';

class AddWishListProvider extends ChangeNotifier{
  bool _addWishListInProgress = false;
  bool get addWishListInProgress => _addWishListInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _selectedId;
  String? get selectedId => _selectedId;

  Future<bool> addWishList({required String productId})async{
    bool isSuccess = false;
    _selectedId = productId;

    _addWishListInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {"product" : productId};

    NetworkResponse response = await getNetworkCaller().postRequest(url: Urls.addToWishListUrl, body: requestBody, errMsg: 'Something went wrong');

    if(response.isSuccess){
      isSuccess = true;
      _errorMessage = null;
    }else{
      _errorMessage = response.errorMessage!;
    }

    _addWishListInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}