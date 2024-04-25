import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/project_model.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/add_subtask.dart';
import 'package:kanbored/ui/checklist.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/ui/subtask.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/utils/utils.dart';

List<Widget> buildSubtasks(
    BuildContext context,
    TaskModel task,
    List<SubtaskModel> subtasks,
    TaskMetadataModel taskMetadata,
    List<GlobalKey<EditableState>> keysEditableText,
    AppBarActionListener abActionListener,
    Function(SubtaskModel, bool) toggleCb) {
  if (taskMetadata.checklists.isEmpty) {
    return [Utils.emptyUi()];
  }
  // TODO: use `flutter_sticky_header` for multi-header checklist & `SliverReorderableList`
  var currentIndex = 1; // start after `description`
  return taskMetadata.checklists.map((checklist) {
    log("checklist: $checklist: $currentIndex");
    return Column(
        children: <Widget>[
              buildChecklistHeader(checklist, taskMetadata, task,
                  keysEditableText, currentIndex++, abActionListener)
            ] +
            checklist.items.map((item) {
              var subtask =
                  subtasks.singleWhere((element) => element.id == item.id);
              log("subtask: ${subtask.title}: $currentIndex");
              return buildSingleSubtask(
                  context,
                  subtask,
                  checklist,
                  taskMetadata,
                  keysEditableText,
                  currentIndex++,
                  abActionListener,
                  toggleCb);
            }).toList() +
            <Widget>[
              buildAddSubtask(checklist, taskMetadata, task, keysEditableText,
                  currentIndex++, abActionListener)
            ]);
  }).toList();
}

Widget buildSingleSubtask(
    BuildContext context,
    SubtaskModel subtask,
    CheckListMetadata checklist,
    TaskMetadataModel taskMetadata,
    List<GlobalKey<EditableState>> keysEditableText,
    int index,
    AppBarActionListener abActionListener,
    Function(SubtaskModel, bool) toggleCb) {
  return Subtask(
      key: keysEditableText[index],
      subtask: subtask,
      checklist: checklist,
      taskMetadata: taskMetadata,
      abActionListener: AppBarActionListener(
        onChange: abActionListener.onChange,
        onEditStart: (_, actions) =>
            abActionListener.onEditStart(index, actions),
        onEditEnd: abActionListener.onEditEnd,
        onDelete: abActionListener.onDelete,
        refreshUi: abActionListener.refreshUi,
      ));
  // return Row(children: [
  //   Checkbox(
  //     checkColor: Colors.white, // TODO: themed color!
  //     fillColor: MaterialStateProperty.resolveWith((states) {
  //       if (states.contains(MaterialState.selected)) {
  //         return "primary".themed(context);
  //       }
  //       return Colors.transparent;
  //     }),
  //     value: subtask.status == SubtaskModel.kStatusFinished,
  //     onChanged: (value) => toggleCb(subtask, value!),
  //   ),
  //   Expanded(
  //       child: Subtask(
  //           key: keysEditableText[index],
  //           subtask: subtask,
  //           abActionListener: TaskActionListener(
  //             onChange: abActionListener.onChange,
  //             onEditStart: (_) => abActionListener.onEditStart(index),
  //             onEditEnd: abActionListener.onEditEnd,
  //             onDelete: abActionListener.onDelete,
  //             refreshUi: abActionListener.refreshUi,
  //           )))
  // ]);
}

Widget buildAddSubtask(
  CheckListMetadata checklist,
  TaskMetadataModel taskMetadata,
  TaskModel task,
  List<GlobalKey<EditableState>> keysEditableText,
  int index,
  AppBarActionListener abActionListener,
) =>
    AddSubtask(
        key: keysEditableText[index],
        checklist: checklist,
        taskMetadata: taskMetadata,
        task: task,
        abActionListener: AppBarActionListener(
          onChange: abActionListener.onChange,
          onEditStart: (_, actions) =>
              abActionListener.onEditStart(index, actions),
          onEditEnd: abActionListener.onEditEnd,
          onDelete: abActionListener.onDelete,
          refreshUi: abActionListener.refreshUi,
        ));

Widget buildChecklistHeader(
        CheckListMetadata checklist,
        TaskMetadataModel taskMetadata,
        TaskModel task,
        List<GlobalKey<EditableState>> keysEditableText,
        int index,
        AppBarActionListener abActionListener) =>
    Checklist(
        key: keysEditableText[index],
        checklist: checklist,
        task: task,
        taskMetadata: taskMetadata,
        abActionListener: AppBarActionListener(
          onChange: abActionListener.onChange,
          onEditStart: (_, actions) =>
              abActionListener.onEditStart(index, actions),
          onEditEnd: abActionListener.onEditEnd,
          onDelete: abActionListener.onDelete,
          refreshUi: abActionListener.refreshUi,
        ));
//
// Widget buildBoardTask(TaskModelData task, BuildContext context) {
//   // log("Board task: ${task.title} at ${task.position}");
//   return Card(
//       margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
//       clipBehavior: Clip.hardEdge,
//       color: "taskBg".themed(context),
//       child: InkWell(
//           splashColor: "cardHighlight".themed(context),
//           highlightColor: "cardHighlight".themed(context),
//           onTap: () {
//             Navigator.pushNamed(context, routeTask, arguments: task);
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: SizedBox(
//                 height: Sizes.kTaskHeight,
//                 child: Center(
//                     child: Text(
//                   task.title,
//                   textAlign: TextAlign.center, // horizontal
//                 ))),
//           )));
// }

Widget buildBoardColumn(ColumnModel model,
    BuildContext context, VoidCallback onTap) {
  // log("Board task: ${task.title} at ${task.position}");
  return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      clipBehavior: Clip.hardEdge,
      color: "taskBg".themed(context),
      child: InkWell(
          splashColor: "cardHighlight".themed(context),
          highlightColor: "cardHighlight".themed(context),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
                height: Sizes.kColumnHeight,
                child: Center(
                    child: Text(
                  model.title,
                  textAlign: TextAlign.center, // horizontal
                ))),
          )));
}
