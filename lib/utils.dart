import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/strings.dart';

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
  // UI helpers
  static getWidth(BuildContext context) => MediaQuery.of(context).size.width;

  static getHeight(BuildContext context) => MediaQuery.of(context).size.height;

  static Widget emptyUi() => const SizedBox.shrink();

  // Alerts
  static showErrorSnackbar(BuildContext context, dynamic e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } else {
      log("[Error snackbar] unmounted; $e");
    }
  }

  static showAlertDialog(BuildContext context, String title, String content,
      VoidCallback onPressed) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
              canPop: false,
              child: AlertDialog(
                title: Text(title, maxLines: 1),
                content: Text(content),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onPressed();
                      },
                      child: Text("ok".resc())),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("cancel".resc())),
                ],
              ));
        });
  }

  static showInputAlertDialog(BuildContext context, String title,
      String content, String initText, Function(String) onPressed) {
    TextEditingController controller = TextEditingController();
    controller.text = initText;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
              canPop: false,
              child: AlertDialog(
                title: Text(title, maxLines: 1),
                content: TextField(
                  autofocus: true,
                  controller: controller,
                  decoration: InputDecoration(hintText: content),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          Navigator.pop(context);
                          onPressed(controller.text);
                        }
                      },
                      child: Text("ok".resc())),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("cancel".resc())),
                ],
              ));
        });
  }

  static void printStacktrace() {
    log("[stacktrace] ${StackTrace.current}");
  }
}
