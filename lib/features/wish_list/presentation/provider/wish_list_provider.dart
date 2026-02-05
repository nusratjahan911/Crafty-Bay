import 'package:crafty_bay/app/set_up_network_caller.dart';
import 'package:crafty_bay/core/services/network_caller.dart';
import 'package:crafty_bay/features/wish_list/data/models/wish_list_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../app/urls.dart';

class WishListProvider extends ChangeNotifier{

  final int _pageSize = 18;
  int _currentPageNo = 0;
  int? _lastPageNo;

  bool _wishListInProgress = false;
  bool _loadMoreData = false;
  String? _errorMessage;

  final List<WishListModel> _wishList = [];
  List<WishListModel> get wishList => _wishList;

  bool get wishListInProgress => _wishListInProgress;
  bool get loadMoreData => _loadMoreData;
  String? get errorMessage => _errorMessage;


  Future<bool> WishList() async{
    bool isSuccess = false;

    if(_currentPageNo == 0){
      _wishList.clear();
      _wishListInProgress = true;
    }else if(_currentPageNo < _lastPageNo!){
     _loadMoreData = true;
    }else{
      return false;
    }
    notifyListeners();
    _currentPageNo++;
    
    
    ///api call
    final NetworkResponse response = await getNetworkCaller().getRequest(url: Urls.wishListUrl(_pageSize, _currentPageNo), errMsg: 'Something went wrong');

    if(response.isSuccess){
      _lastPageNo ??= response.responseData['data']['last_page'];

      List<WishListModel> list = [];
      for(Map<String, dynamic> wishItem in response.responseData['data']['results']){
        list.add(WishListModel.fromJson(wishItem));
      }

      _wishList.addAll(list);
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    if(_wishListInProgress){
      _wishListInProgress = false;
    }else{
      _loadMoreData = false;
    }

    notifyListeners();
    return isSuccess;
  }

  Future<void> loadInitialWishList()async{
    _currentPageNo = 0;
    _lastPageNo = null;
    await WishList();
  }
}
