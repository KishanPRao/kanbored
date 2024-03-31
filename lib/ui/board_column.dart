import 'package:flutter/material.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/ui/app_theme.dart';
import 'package:kanbored/utils.dart';

Widget buildBoardColumn(ColumnModel column, BuildContext context) {
  return Card(
      color: context.theme.appColors.cardBg,
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.hardEdge,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(column.title) as Widget,
                SizedBox(
                    height: Utils.getHeight(context) * 0.7,
                    child: ListView(
                      // shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: column.tasks
                            .map((column) => SizedBox(
                                width: Utils.getWidth(context) * 0.7,
                                // height: 500.0,
                                child: buildBoardTask(column, context)))
                            .toList()))
              ])));
}

Widget buildBoardTask(TaskModel task, BuildContext context) {
  return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
          splashColor: context.theme.appColors.primary.withAlpha(30),
          onTap: () {},
          child: SizedBox(
            height: 60,
            child: Center(child: Text(task.title)),
          )));
}
