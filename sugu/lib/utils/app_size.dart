import 'dart:math';

import 'package:flutter/material.dart';

class AppSizes {
  // Méthode pour rendre les valeurs responsives
  static double responsiveValue(BuildContext context, double baseValue) {
    return baseValue / 360;
  }
}