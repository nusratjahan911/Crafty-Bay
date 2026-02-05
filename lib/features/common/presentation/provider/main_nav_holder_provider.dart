
import 'package:flutter/material.dart';



class MainNavHolderProvider extends ChangeNotifier {

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void changeItem(int index) async{
    if (_selectedIndex == index) return;

    _selectedIndex = index;
    notifyListeners();
  }

  void changeToCategories() {
    changeItem(1);
  }
  void backToHome() {
    changeItem(0);
  }

}