import 'package:flutter/material.dart';

class MyTheme extends ChangeNotifier{
  bool _isLightTheme = true;

  void ChangeTheme(){
    _isLightTheme = !_isLightTheme;
    notifyListeners();
  }

  bool get isLightTheme => _isLightTheme;

  bool _IsStudent = true;

  void changeToStudent(){
    _IsStudent = true;
    notifyListeners();
  }

  void changeToStaff(){
    _IsStudent = false;
    notifyListeners();
  }
  bool get isStudent => _IsStudent;
}