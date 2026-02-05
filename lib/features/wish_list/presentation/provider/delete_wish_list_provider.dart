import 'package:crafty_bay/app/set_up_network_caller.dart';
import 'package:crafty_bay/core/services/network_caller.dart';
import 'package:flutter/cupertino.dart';

import '../../../../app/urls.dart';

class DeleteWishListProvider extends ChangeNotifier{
  bool _deleteWishListItemInProgress = false;
  String? _deleteProductId;

  bool get deleteWishListItemInProgress => _deleteWishListItemInProgress;
  String? get deleteProductId => _deleteProductId;

  Future<bool> deleteWishListItem({required String wishListId, required String deleteProductId})async{
    bool isSuccess = false;
    _deleteProductId = deleteProductId;

    _deleteWishListItemInProgress = true;
    notifyListeners();

    NetworkResponse response = await getNetworkCaller().deleteRequest(url: Urls.deleteWishListItemUrl(wishListId));

    _deleteWishListItemInProgress = false;
    notifyListeners();

    if (response.isSuccess){
      isSuccess = true;
    }

    return isSuccess;


  }
}