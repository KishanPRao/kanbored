import 'dart:convert';
import 'package:flutter/services.dart';

extension Strings on String {
  static late Map<String, dynamic> _strings;

  static Future<void> initialize() async {
    var jsonString = await rootBundle.loadString("assets/strings.json");
    _strings = jsonDecode(jsonString);
  }

  String resc() => _strings[this] ?? "";
}
