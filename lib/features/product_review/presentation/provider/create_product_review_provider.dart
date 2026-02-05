import 'package:crafty_bay/app/set_up_network_caller.dart';
import 'package:crafty_bay/core/services/network_caller.dart';
import 'package:crafty_bay/features/product_review/data/models/create_review_model.dart';
import 'package:flutter/material.dart';

import '../../../../app/urls.dart';

class CreateProductReviewProvider extends ChangeNotifier {
  bool _createReviewInProgress = false;

  bool get createReviewInProgress => _createReviewInProgress;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> createProductReview({required String productId, required String review, required String rating}) async {
    bool isSuccess = false;
    _createReviewInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "product": productId,
      "comment":review,
      "rating":rating
    };

     NetworkResponse response = await getNetworkCaller().postRequest(
      url: Urls.createReviewUrl,
      body: requestBody,
      errMsg: 'Review not created',
    );

    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _createReviewInProgress = true;
    notifyListeners();

    return isSuccess;
  }
}
