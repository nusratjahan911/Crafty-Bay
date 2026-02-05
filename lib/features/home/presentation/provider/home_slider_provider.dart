import 'package:crafty_bay/app/set_up_network_caller.dart';
import 'package:crafty_bay/app/urls.dart';
import 'package:crafty_bay/core/services/network_caller.dart';
import 'package:crafty_bay/features/home/data/models/slider_models.dart';
import 'package:flutter/widgets.dart';

class HomeSliderProvider extends ChangeNotifier {
  bool _getHomeSliderInProgress = false;

  bool get getHomeSliderInProgress => _getHomeSliderInProgress;

  List<SliderModel> _homeSliders = [];

  List<SliderModel> get homeSliders => _homeSliders;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> getHomeSliders() async {
    bool isSuccess = false;
    _getHomeSliderInProgress = true;
    notifyListeners();

    final NetworkResponse response = await getNetworkCaller().getRequest(
      url: Urls.homeSliderUrl,
      errMsg: '',
    );

    if (response.isSuccess) {
      List<SliderModel> sliders = [];
      for (Map<String, dynamic> slider
          in response.responseData['data']['results']) {
        sliders.add(SliderModel.fromJson(slider));
      }
      _homeSliders = sliders;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _getHomeSliderInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
