import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/add_subtask.dart';
import 'package:kanbored/ui/checklist.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/subtask.dart';
import 'package:kanbored/ui/task_action_listener.dart';

List<Widget> buildSubtasks(
    BuildContext context,
    TaskModel task,
    List<SubtaskModel> subtasks,
    TaskMetadataModel taskMetadata,
    List<GlobalKey<EditableState>> keysEditableText,
    TaskActionListener taskActionListener,
    Function(SubtaskModel, bool) toggleCb) {
  if (taskMetadata.checklists.isEmpty) {
    return [const SizedBox.shrink()];
  }
  // TODO: use `flutter_sticky_header` for multi-header checklist & `SliverReorderableList`
  var currentIndex = 1; // start after `description`
  return taskMetadata.checklists.map((checklist) {
    log("checklist: $checklist: $currentIndex");
    return Column(
        children: <Widget>[
              buildChecklistHeader(checklist, taskMetadata, task,
                  keysEditableText, currentIndex++, taskActionListener)
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
                  taskActionListener,
                  toggleCb);
            }).toList() +
            <Widget>[
              buildAddSubtask(checklist, taskMetadata, task, keysEditableText,
                  currentIndex++, taskActionListener)
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
    TaskActionListener taskActionListener,
    Function(SubtaskModel, bool) toggleCb) {
  return Subtask(
      key: keysEditableText[index],
      subtask: subtask,
      checklist: checklist,
      taskMetadata: taskMetadata,
      taskActionListener: TaskActionListener(
        onChange: taskActionListener.onChange,
        onEditStart: (_, actions) =>
            taskActionListener.onEditStart(index, actions),
        onEditEnd: taskActionListener.onEditEnd,
        onDelete: taskActionListener.onDelete,
        refreshUi: taskActionListener.refreshUi,
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
  //           taskActionListener: TaskActionListener(
  //             onChange: taskActionListener.onChange,
  //             onEditStart: (_) => taskActionListener.onEditStart(index),
  //             onEditEnd: taskActionListener.onEditEnd,
  //             onDelete: taskActionListener.onDelete,
  //             refreshUi: taskActionListener.refreshUi,
  //           )))
  // ]);
}

Widget buildAddSubtask(
  CheckListMetadata checklist,
  TaskMetadataModel taskMetadata,
  TaskModel task,
  List<GlobalKey<EditableState>> keysEditableText,
  int index,
  TaskActionListener taskActionListener,
) =>
    AddSubtask(
        key: keysEditableText[index],
        checklist: checklist,
        taskMetadata: taskMetadata,
        task: task,
        taskActionListener: TaskActionListener(
          onChange: taskActionListener.onChange,
          onEditStart: (_, actions) =>
              taskActionListener.onEditStart(index, actions),
          onEditEnd: taskActionListener.onEditEnd,
          onDelete: taskActionListener.onDelete,
          refreshUi: taskActionListener.refreshUi,
        ));

Widget buildChecklistHeader(
        CheckListMetadata checklist,
        TaskMetadataModel taskMetadata,
        TaskModel task,
        List<GlobalKey<EditableState>> keysEditableText,
        int index,
        TaskActionListener taskActionListener) =>
    Checklist(
        key: keysEditableText[index],
        checklist: checklist,
        task: task,
        taskMetadata: taskMetadata,
        taskActionListener: TaskActionListener(
          onChange: taskActionListener.onChange,
          onEditStart: (_, actions) =>
              taskActionListener.onEditStart(index, actions),
          onEditEnd: taskActionListener.onEditEnd,
          onDelete: taskActionListener.onDelete,
          refreshUi: taskActionListener.refreshUi,
        ));
