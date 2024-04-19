import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/add_task.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/ui/column_text.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';

class BoardColumn extends StatefulWidget {
  final bool showArchived;
  final ColumnModel column;
  final List<GlobalKey<EditableState>> keysEditableText;
  final int baseIdx;
  final AppBarActionListener abActionListener;

  const BoardColumn(
      {super.key,
      required this.column,
      required this.showArchived,
      required this.keysEditableText,
      required this.baseIdx,
      required this.abActionListener});

  @override
  State<StatefulWidget> createState() => BoardColumnState();
}

class BoardColumnState extends State<BoardColumn> {
  late List<TaskModel> tasks;
  late int tasksLength;
  late bool showArchived;
  late ColumnModel column;
  late List<GlobalKey<EditableState>> keysEditableText;
  late int baseIdx;
  late AppBarActionListener abActionListener;

  @override
  void initState() {
    super.initState();
    column = widget.column;
    showArchived = widget.showArchived;
    tasks = (showArchived
        ? (column.isActive ? column.inactiveTasks : column.tasks)
        : column.activeTasks);
    // TODO: fix incorrect positioning (when remove a middle task, add new one, sometimes doesn't update position correctly)
    // moveTaskPosition or updateTask for all tasks?
    tasks.sort((a, b) {
      // ascending
      if (a.position > b.position) {
        return 1;
      }
      return -1;
    });
    tasksLength =
        (showArchived ? tasks.length : tasks.length + 1); // Add new task
    keysEditableText = widget.keysEditableText;
    baseIdx = widget.baseIdx;
    abActionListener = widget.abActionListener;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: "columnBg".themed(context),
        margin: const EdgeInsets.all(10),
        clipBehavior: Clip.hardEdge,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ColumnText(
                  key: keysEditableText[baseIdx],
                  columnModel: column,
                  abActionListener: abActionListener),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: tasksLength,
                      itemBuilder: (context, index) {
                        if (!showArchived && index == tasks.length) {
                          return SizedBox(
                              child: AddTask(
                                  key: keysEditableText[baseIdx + 1],
                                  columnModel: column,
                                  abActionListener: abActionListener));
                        }
                        return SizedBox(
                            child: buildBoardTask(
                                tasks.elementAt(index), column, context));
                      }))
            ])));
  }

  Widget buildBoardTask(
      TaskModel task, ColumnModel columnModel, BuildContext context) {
    // log("Board task: ${task.title} at ${task.position}");
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        clipBehavior: Clip.hardEdge,
        color: "taskBg".themed(context),
        child: InkWell(
            splashColor: "primary".themed(context).withAlpha(30),
            onTap: () {
              Navigator.pushNamed(context, routeTask,
                  arguments: [task.id, columnModel.projectId]);
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
}
