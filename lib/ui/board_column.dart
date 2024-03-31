import 'package:flutter/material.dart';
import 'package:kanbored/models/column_model.dart';

Widget buildBoardColumn(ColumnModel column) {
  return Card(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        child:
        Center(child: Text(column.title)), // swimlane
      ));
}