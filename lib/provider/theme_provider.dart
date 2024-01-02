


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{

  ThemeData themeData = ThemeData.light();

  ThemeData getTheme() => themeData;

  void setDarkTheme() {
    themeData = ThemeData.dark();
   notifyListeners();
  }

  void setLightTheme() {
    themeData = ThemeData.light();
    notifyListeners();
  }
}