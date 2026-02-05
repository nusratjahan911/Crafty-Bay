import 'dart:convert';
import 'dart:io';

import 'package:crafty_bay/app/set_up_network_caller.dart';
import 'package:crafty_bay/core/services/network_caller.dart';
import 'package:crafty_bay/features/home/data/models/update_profile_models.dart';
import 'package:flutter/material.dart';

import '../../../../app/urls.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/providers/auth_controller.dart';

class UpdateProfileProvider extends ChangeNotifier {
  bool _updateProfileInProgress = false;
  String? _errorMessage;
  File? _selectedImage;

  bool get updateProfileInProgress => _updateProfileInProgress;

  String? get errorMessage => _errorMessage;

  File? get selectedImage => _selectedImage;

  Future<bool> updateProfile(UpdateProfileModel profileModel) async {
    bool isSuccess = false;
    _updateProfileInProgress = true;

    final requestBody = await profileModel.toRequestBody();

    final NetworkResponse response = await getNetworkCaller().patchRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
      errMsg: 'Something went wrong',
    );

    _updateProfileInProgress = false;
    notifyListeners();

    if (response.isSuccess) {
      /// update user data to shared preference
      final model = UserModel.fromJson(response.responseData['data']);
      await AuthController.updateUserData(model);

      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }

    _updateProfileInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
