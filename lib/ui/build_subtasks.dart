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

List<Widget> buildSingleListSubtasks(
    BuildContext context,
    TaskModel task,
    List<SubtaskModel> subtasks,
    List<GlobalKey<EditableState>> keysEditableText,
    TaskActionListener taskActionListener,
    Function(SubtaskModel, bool) toggleCb) {
  var currentIndex = 1; // start after `description`
  return subtasks.map((subtask) {
        return buildSingleSubtask(context, subtask, keysEditableText,
            currentIndex++, taskActionListener, toggleCb);
      }).toList() +
      <Widget>[
        buildAddSubtask(null, null, task, keysEditableText, currentIndex++,
            taskActionListener)
      ];
}

List<Widget> buildMultiListSubtasks(
    BuildContext context,
    TaskModel task,
    List<SubtaskModel> subtasks,
    TaskMetadataModel taskMetadata,
    List<GlobalKey<EditableState>> keysEditableText,
    TaskActionListener taskActionListener,
    Function(SubtaskModel, bool) toggleCb) {
  var currentIndex = 1; // start after `description`
  return taskMetadata.checklists.map((checklist) {
    log("checklist: $checklist: $currentIndex");
    return Column(
        children: <Widget>[
              buildChecklistHeader(checklist, keysEditableText, currentIndex++,
                  taskActionListener)
            ] +
            checklist.items.map((item) {
              var subtask =
                  subtasks.singleWhere((element) => element.id == item.id);
              log("subtask: ${subtask.title}: $currentIndex");
              return buildSingleSubtask(context, subtask, keysEditableText,
                  currentIndex++, taskActionListener, toggleCb);
            }).toList() +
            <Widget>[
              buildAddSubtask(checklist, taskMetadata, task, keysEditableText,
                  currentIndex++, taskActionListener)
            ]);
  }).toList();
}

List<Widget> buildSubtasks(
    BuildContext context,
    TaskModel task,
    List<SubtaskModel> subtasks,
    TaskMetadataModel? taskMetadata,
    List<GlobalKey<EditableState>> keysEditableText,
    TaskActionListener taskActionListener,
    Function(SubtaskModel, bool) toggleCb) {
  // if (subtasks.isEmpty) {
  //   return [const SizedBox.shrink()];
  // }
  return taskMetadata != null
      ? buildMultiListSubtasks(context, task, subtasks, taskMetadata,
          keysEditableText, taskActionListener, toggleCb)
      : buildSingleListSubtasks(context, task, subtasks, keysEditableText,
          taskActionListener, toggleCb);
}

Widget buildSingleSubtask(
    BuildContext context,
    SubtaskModel subtask,
    List<GlobalKey<EditableState>> keysEditableText,
    int index,
    TaskActionListener taskActionListener,
    Function(SubtaskModel, bool) toggleCb) {
  return Row(children: [
    Checkbox(
      checkColor: Colors.white, // TODO: themed color!
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return "primary".themed(context);
        }
        return Colors.transparent;
      }),
      value: subtask.status == SubtaskModel.kStatusFinished,
      onChanged: (value) => toggleCb(subtask, value!),
    ),
    Expanded(
        child: Subtask(
            key: keysEditableText[index],
            subtask: subtask,
            taskActionListener: TaskActionListener(
              onChange: taskActionListener.onChange,
              onEditStart: (_) => taskActionListener.onEditStart(index),
              onEditEnd: taskActionListener.onEditEnd,
              refreshUi: taskActionListener.refreshUi,
            )))
  ]);
}

Widget buildAddSubtask(
  CheckListMetadata? checklist,
  TaskMetadataModel? taskMetadata,
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
          onEditStart: (_) => taskActionListener.onEditStart(index),
          onEditEnd: taskActionListener.onEditEnd,
          refreshUi: taskActionListener.refreshUi,
        ));

Widget buildChecklistHeader(
        CheckListMetadata checklist,
        List<GlobalKey<EditableState>> keysEditableText,
        int index,
        TaskActionListener taskActionListener) =>
    Checklist(
        key: keysEditableText[index],
        checklist: checklist,
        taskActionListener: TaskActionListener(
          onChange: taskActionListener.onChange,
          onEditStart: (_) => taskActionListener.onEditStart(index),
          onEditEnd: taskActionListener.onEditEnd,
          refreshUi: taskActionListener.refreshUi,
        ));
