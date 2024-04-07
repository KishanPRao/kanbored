import 'package:flutter/material.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/add_task.dart';
import 'package:kanbored/ui/sizes.dart';

Widget buildBoardColumn(ColumnModel column, BuildContext context,
    bool showActive, Function(String) createTaskCb) {
  var tasks = (showActive ? column.activeTasks : column.tasks);
  var tasksLength = (showActive ? tasks.length + 1 : tasks.length);
  return Card(
      color: "columnBg".themed(context),
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
                    itemCount: tasksLength,
                    itemBuilder: (context, index) {
                      if (showActive && index == tasks.length) {
                        return SizedBox(
                            child: buildBoardAddTaskAction(
                                context, column, createTaskCb));
                      }
                      return SizedBox(
                          child:
                              buildBoardTask(tasks.elementAt(index), context));
                    }))
          ])));
}

Widget buildBoardAddTaskAction(
    BuildContext context, ColumnModel column, Function(String) createTaskCb) {
  return AddTask(column: column, createTaskCb: createTaskCb);
}

Widget buildBoardTask(TaskModel task, BuildContext context) {
  return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      clipBehavior: Clip.hardEdge,
      color: "taskBg".themed(context),
      child: InkWell(
          splashColor: "primary".themed(context).withAlpha(30),
          onTap: () {
            Navigator.pushNamed(context, routeTask, arguments: task);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
                height: Sizes.kTaskHeight,
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
