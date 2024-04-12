import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/checklist.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/subtask.dart';
import 'package:kanbored/utils.dart';

Widget buildSingleSubtask(
    BuildContext context,
    SubtaskModel subtask,
    List<GlobalKey<EditableState>> keysEditableText,
    int index,
    Function(String) onChange,
    Function(int) onEditStart,
    Function(bool) onEditEnd,
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
            onChange: onChange,
          onEditStart: () => onEditStart(index),
          onEditEnd: onEditEnd,))
  ]);
}

List<Widget> buildSingleListSubtasks(
    BuildContext context,
    List<SubtaskModel> subtasks,
    List<GlobalKey<EditableState>> keysEditableText,
    Function(String) onChange,
    Function(int) onEditStart,
    Function(bool) onEditEnd,
    Function(SubtaskModel, bool) toggleCb) {
  var currentIndex = 1; // start after `description`
  return subtasks.map((subtask) {
    return buildSingleSubtask(context, subtask, keysEditableText,
        currentIndex++, onChange,
        onEditStart, onEditEnd, toggleCb);
  }).toList();
}

List<Widget> buildMultiListSubtasks(
    BuildContext context,
    List<SubtaskModel> subtasks,
    TaskMetadataModel taskMetadata,
    List<GlobalKey<EditableState>> keysEditableText,
    Function(String) onChange,
    Function(int) onEditStart,
    Function(bool) onEditEnd,
    Function(SubtaskModel, bool) toggleCb) {
  var currentIndex = 1; // start after `description`
  return taskMetadata.checklists.map((checklist) {
    log("checklist: ${checklist.name}: $currentIndex");
    return Column(
        children: <Widget>[
              buildChecklistHeader(checklist, keysEditableText, currentIndex++, onChange,
                  onEditStart, onEditEnd)
            ] +
            checklist.items.map((item) {
              var subtask =
                  subtasks.singleWhere((element) => element.id == item.id);
              log("subtask: ${subtask.title}: $currentIndex");
              return buildSingleSubtask(context, subtask, keysEditableText,
                  currentIndex++, onChange,
                  onEditStart, onEditEnd, toggleCb);
            }).toList());
  }).toList();
}

List<Widget> buildSubtasks(
    BuildContext context,
    List<SubtaskModel> subtasks,
    TaskMetadataModel? taskMetadata,
    List<GlobalKey<EditableState>> keysEditableText,
    Function(String) onChange,
    Function(int) onEditStart,
    Function(bool) onEditEnd,
    Function(SubtaskModel, bool) toggleCb) {
  return taskMetadata != null
      ? buildMultiListSubtasks(context, subtasks, taskMetadata,
          keysEditableText, onChange, onEditStart, onEditEnd, toggleCb)
      : buildSingleListSubtasks(
          context, subtasks, keysEditableText, onChange,
      onEditStart, onEditEnd, toggleCb);
}

Widget buildChecklistHeader(
  CheckListMetadata checklist,
  List<GlobalKey<EditableState>> keysEditableText,
  int index,
  Function(String) onChange,
    Function(int) onEditStart,
    Function(bool) onEditEnd,
) =>
    Checklist(
        key: keysEditableText[index],
        checkListMetadata: checklist,
        onChange: onChange,
        onEditStart: () => onEditStart(index),
        onEditEnd: onEditEnd,
    );
