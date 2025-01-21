import "package:flutter/material.dart";
import "package:truco/utils/app_colors.dart";

class ScoreColorsStateManeger extends ChangeNotifier {
  Color _defaultColor = AppColors.scoreContainer;

  Color get defaultColor => _defaultColor;

  void changeColor(Color newcolor) {
    _defaultColor = newcolor;
    notifyListeners();
  }
}
