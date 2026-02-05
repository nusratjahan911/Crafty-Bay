import 'package:crafty_bay/app/set_up_network_caller.dart';
import 'package:crafty_bay/app/urls.dart';
import 'package:crafty_bay/core/services/network_caller.dart';
import 'package:crafty_bay/features/auth/data/models/verify_otp_params.dart';
import 'package:flutter/material.dart';

class VerifyOtpProvider extends ChangeNotifier{
  bool _verifyOtpInProgress = false;
  bool get verifyOtpInProgress => _verifyOtpInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;


  Future<bool>  verifyOtp(VerifyOtpParams params) async{
    bool isSuccess = false;
    _verifyOtpInProgress = true;
    notifyListeners();

   final NetworkResponse response = await getNetworkCaller().postRequest(
       url: Urls.verifyOtpUrl,
     body: params.toJson(), errMsg: 'Something went wrong',
   );

   if (response.isSuccess) {
     isSuccess = true;
     _errorMessage = null;
   }else{
     _errorMessage = response.errorMessage;
   }

   _verifyOtpInProgress = false;
   notifyListeners();


    return isSuccess;
  }
}