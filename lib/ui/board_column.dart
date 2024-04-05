import 'package:flutter/material.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/ui/app_theme.dart';
import 'package:kanbored/utils.dart';

Widget buildBoardColumn(
    ColumnModel column, BuildContext context, bool showActive) {
  return Card(
      color: context.theme.appColors.cardBg,
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.hardEdge,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(column.title) as Widget,
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount:
                        (showActive ? column.activeTasks : column.tasks).length,
                    itemBuilder: (context, index) => SizedBox(
                        child: buildBoardTask(
                            (showActive ? column.activeTasks : column.tasks)
                                .elementAt(index),
                            context))))
          ])));
}

Widget buildBoardTask(TaskModel task, BuildContext context) {
  return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
          splashColor: context.theme.appColors.primary.withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, routeTask, arguments: task);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
                height: 50,
                child: Center(
                    child: Text(
                  task.title,
                  textAlign: TextAlign.center, // horizontal
                ))),
          )));
}

Widget buildSubtask(SubtaskModel subtask, BuildContext context) {
  bool isChecked = false;
  return Row(children: [
    Checkbox(
      value: isChecked,
      onChanged: (value) {
        isChecked = value!;
      },
    ),
    Text(subtask.title)
  ]);
}
