import 'package:crafty_bay/app/set_up_network_caller.dart';
import 'package:crafty_bay/core/services/network_caller.dart';
import 'package:flutter/widgets.dart';

import '../../../../app/urls.dart';
import '../../data/models/product_model.dart';

class ProductDetailsBySlugProvider extends ChangeNotifier {
  final int _pageSize = 20;
  int _currentPageNo = 0;
  int? _lastPageNo;

  bool _productBySlugInProgress = false;
  bool _loadingMoreData = false;

  bool get productBySlugInProgress => _productBySlugInProgress;

  bool get loadingMoreData => _loadingMoreData;
  final List<ProductModel> _productList = [];

  List<ProductModel> get productList => _productList;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;


  Future<bool> ProductDetailsBySlug(String productSlug) async {
    bool isSuccess = false;

    if (_currentPageNo == 0) {
      _productList.clear();
      _productBySlugInProgress = true;
    } else if (_currentPageNo < _lastPageNo!) {
      _loadingMoreData = true;
    } else {
      return false;
    }

    notifyListeners();
    _currentPageNo++;


    final NetworkResponse response = await getNetworkCaller().getRequest(
        url: Urls.productDetailsBySlugUrl(_pageSize,_currentPageNo,productSlug),
        errMsg: 'Something went wrong'
    );


    if (response.isSuccess) {
      _lastPageNo ??= response.responseData['data']['last_page'];

      List<ProductModel> list = [];
      for (Map<String, dynamic> product in response
          .responseData['data']['results']) {
        list.add(ProductModel.fromJson(product));
      }
        _productList.addAll(list);
        isSuccess = true;
      } else {
      _errorMessage = response.errorMessage;
    }

    if (_productBySlugInProgress) {
      _productBySlugInProgress = false;
    } else {
      _loadingMoreData = false;
    }
    notifyListeners();

    return isSuccess;
  }

  Future<void> loadInitialProductList(String slug)async{
    _currentPageNo = 0;
    _lastPageNo = null;
    await ProductDetailsBySlug(slug);
  }

}