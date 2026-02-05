import 'package:crafty_bay/app/set_up_network_caller.dart';
import 'package:crafty_bay/core/services/network_caller.dart';
import 'package:crafty_bay/features/product_review/data/models/review_model.dart';
import 'package:flutter/material.dart';

import '../../../../app/urls.dart';
import '../../../auth/presentation/providers/auth_controller.dart';

class UpdateReviewProvider extends ChangeNotifier {
  bool _updateReviewInProgress = false;

  bool get updateReviewInProgress => _updateReviewInProgress;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> updateReview({required String reviewId, required String newReview, required String rating}) async {
    bool isSuccess = false;
    _updateReviewInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "comment":newReview,
      "rating":rating
    };


    final NetworkResponse response = await getNetworkCaller().patchRequest(
      url: Urls.updateReviewUrl(reviewId),
      errMsg: 'Profile not updated',
      body: requestBody,
    );


    if (response.isSuccess) {
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _updateReviewInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
