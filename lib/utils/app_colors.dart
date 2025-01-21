import "package:flutter/material.dart";

abstract class AppColors {
  static Color get backgroundColor => const Color.fromARGB(255, 12, 0, 19);
  static Color get appBarColor => Color.fromARGB(255, 26, 0, 41);
  static Color get scoreButton => Color.fromRGBO(122, 12, 49, 100);
  static Color get scoreContainer => Color.fromRGBO(74, 7, 48, 100);
  static Color get scoreText => Color.fromRGBO(105, 77, 124, 100);
  static Color get cancelButtonModal => Color.fromRGBO(74, 74, 74, 100);
  static Color get confirmButtonModal => Color.fromRGBO(122, 12, 49, 100);
  static Color get hintTextColor => Color.fromRGBO(120, 66, 99, 100);
}
