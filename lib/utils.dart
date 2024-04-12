import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension MapExtension<E> on List<E> {
  Iterable<T> mapIndexed<T>(T Function(MapEntry<int, E> e) toElement) =>
      asMap().entries.map(toElement);
}

class Utils {
  static getWidth(BuildContext context) => MediaQuery.of(context).size.width;

  static getHeight(BuildContext context) => MediaQuery.of(context).size.height;
}
