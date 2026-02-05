import 'package:crafty_bay/app/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        brightness: Brightness.light,
      colorSchemeSeed: AppColours.themeColor,
      scaffoldBackgroundColor: Colors.white,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColours.themeColor
      ),
      inputDecorationTheme: _getInputDecorationTheme(),
      filledButtonTheme: _getFilledButtonThemeData()
    );
  }

  static ThemeData get darkTheme{
    return ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: AppColours.themeColor,
        scaffoldBackgroundColor: Colors.white,
        progressIndicatorTheme: ProgressIndicatorThemeData(
            color: AppColours.themeColor
        ),
      inputDecorationTheme: _getInputDecorationTheme(),
      filledButtonTheme: _getFilledButtonThemeData()
    );
  }

  static InputDecorationTheme _getInputDecorationTheme(){
    return InputDecorationTheme(
      hintStyle: TextStyle(
        fontWeight: FontWeight.w300
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      border: OutlineInputBorder(
        borderSide: BorderSide(
            color: AppColours.themeColor
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: AppColours.themeColor
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: AppColours.themeColor,width: 2
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.red
        ),
      ),
    );
  }

  static FilledButtonThemeData _getFilledButtonThemeData() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
          fixedSize: Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: AppColours.themeColor,
          textStyle: TextStyle(
              fontWeight: FontWeight.w700
          )
      ),
    );
  }
}