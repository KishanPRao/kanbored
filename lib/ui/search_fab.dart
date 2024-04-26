import 'package:flutter/material.dart';
import 'package:kanbored/utils/strings.dart';

Widget buildSearchFab(BuildContext context, VoidCallback onPressed) {
  return FloatingActionButton(
    // foregroundColor: customizations[index].$1,
    backgroundColor: "primary".themed(context),
    shape: const CircleBorder(),
    onPressed: onPressed,
    child: const Icon(Icons.search),
  );
}