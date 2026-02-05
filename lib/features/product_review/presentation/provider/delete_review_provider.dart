import 'package:flutter/cupertino.dart';

import '../../../../app/set_up_network_caller.dart';
import '../../../../app/urls.dart';
import '../../../../core/services/network_caller.dart';

class DeleteReviewProvider extends ChangeNotifier{

  bool _deleteReviewInProgress = false;
  bool get deleteReviewInProgress => _deleteReviewInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> deleteReview({required String reviewId})async{
    bool isSuccess = true;

    _deleteReviewInProgress = true;
    notifyListeners();

    NetworkResponse response = await getNetworkCaller().deleteRequest(url: Urls.deleteReviewUrl(reviewId));

    if(response.isSuccess){
      isSuccess = true;
      _errorMessage = null;
    }else{
      _errorMessage = response.errorMessage ?? '';
    }

    _deleteReviewInProgress = false;
    notifyListeners();

    return isSuccess;
  }

}