import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class Utils {
  static getWidth(BuildContext context) => MediaQuery.of(context).size.width;

  static getHeight(BuildContext context) => MediaQuery.of(context).size.height;
}
