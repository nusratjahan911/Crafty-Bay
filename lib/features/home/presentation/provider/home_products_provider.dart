
import 'package:flutter/cupertino.dart';

import '../../../../app/set_up_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/services/network_caller.dart';
import '../../../product/data/models/product_model.dart';

class HomeProductsProvider extends ChangeNotifier{
  ///popular
  bool _popularListInProgress = false;
  bool get popularListInProgress => _popularListInProgress;

  List<ProductModel> _popularProductList = [];
  List<ProductModel> get popularProductList => _popularProductList;

  Future<void> getPopularProductList()async{

    _popularListInProgress = true;
    notifyListeners();

    NetworkResponse response = await getNetworkCaller().getRequest(url: Urls.get10ProductInHomePageUrl('679a06ad8ddf463f174f0df6'), errMsg: 'Something went wrong');

    if(response.isSuccess){

      List<ProductModel> list = [];
      for(Map<String, dynamic> map in response.responseData['data']['results']){
        list.add(ProductModel.fromJson(map));
      }

      _popularProductList = list;
    }

    _popularListInProgress = false;
    notifyListeners();
  }

  ///special products
  bool _getSpecialListInProgress = false;
  bool get getSpecialListInProgress => _getSpecialListInProgress;

  List<ProductModel> _specialProductList = [];
  List<ProductModel> get specialProductList => _specialProductList;

  Future<void> getSpecialProductList()async{

    _getSpecialListInProgress = true;
    notifyListeners();

    NetworkResponse response = await getNetworkCaller().getRequest(url: Urls.get10ProductInHomePageUrl('679a06ad8ddf463f174f0df6'), errMsg: '');

    if(response.isSuccess){

      List<ProductModel> list = [];
      for(Map<String, dynamic> map in response.responseData['data']['results']){
        list.add(ProductModel.fromJson(map));
      }

      _specialProductList = list;
    }

    _getSpecialListInProgress = false;
    notifyListeners();
  }


  /// new products

  bool _newProductListInProgress = false;
  bool get getNewListInProgress => _newProductListInProgress;

  List<ProductModel> _newProductList = [];
  List<ProductModel> get newProductList => _newProductList;

  Future<void> getNewProductList()async{

    _newProductListInProgress = true;
    notifyListeners();

    NetworkResponse response = await getNetworkCaller().getRequest(url: Urls.get10ProductInHomePageUrl('679a06ad8ddf463f174f0df6'), errMsg: '');

    if(response.isSuccess){

      List<ProductModel> list = [];
      for(Map<String, dynamic> map in response.responseData['data']['results']){
        list.add(ProductModel.fromJson(map));
      }

      _newProductList = list;
    }

    _newProductListInProgress = false;
    notifyListeners();
  }



}