import 'package:crafty_bay/app/set_up_network_caller.dart';
import 'package:crafty_bay/core/services/network_caller.dart';
import 'package:crafty_bay/features/product_review/data/models/review_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../app/urls.dart';

class ProductReviewProvider extends ChangeNotifier {

  final int _pageSize = 20;
  int _currentPageNo = 0;
  int? _lastPageNo;

  int _totalReviewCount = 0;
  int get totalReviewCount => _totalReviewCount;

  bool _reviewListInProgress = false;
  bool _loadingMoreData = false;
  bool get reviewListInProgress => _reviewListInProgress;
  bool get loadingMoreData => _loadingMoreData;

  String? _errorMessage = '';

  String? get errorMessage => _errorMessage;

  List<ReviewModel> _reviewList = [];
  List<ReviewModel> get reviewList => _reviewList;

  Future<bool> fetchReviewList(String productId) async {

    bool isSuccess = false;

    if(_currentPageNo == 0){
      _reviewList.clear();
      _reviewListInProgress = true;
    }else if(_currentPageNo < _lastPageNo!){
      _loadingMoreData = true;
    }else{
      return false;
    }
    notifyListeners();
    _currentPageNo++;


    final NetworkResponse response = await getNetworkCaller().getRequest(
        url: Urls.reviewListUrl(_pageSize, _currentPageNo, productId), errMsg: 'Review not found');

    if (response.isSuccess) {
      _lastPageNo ??= response.responseData['data']['last_page'];
      _totalReviewCount = response.responseData['data']['total'];

      List<ReviewModel> list = [];
      for(Map<String, dynamic> product in response.responseData['data']['results']){
        list.add(ReviewModel.fromJson(product));
      }

      _reviewList.addAll(list);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    if(_reviewListInProgress){
      _reviewListInProgress = false;
    }else{
      _loadingMoreData = false;
    }
    notifyListeners();
    return isSuccess;
  }

  Future<void> loadInitialReviewList(String productId)async{
    _currentPageNo = 0;
    _lastPageNo = null;
    await fetchReviewList(productId);
  }
}
