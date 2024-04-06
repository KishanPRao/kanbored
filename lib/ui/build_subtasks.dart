import 'package:flutter/material.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/strings.dart';

List<Widget> buildSingleListSubtasks(BuildContext context,
    List<SubtaskModel> subtasks, Function(SubtaskModel, bool) toggleCb) {
  return subtasks
      .map((subtask) => Row(children: [
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
    Expanded(child: Text(subtask.title))
  ]))
      .toList();
}

List<Widget> buildMultiListSubtasks(
    BuildContext context,
    List<SubtaskModel> subtasks,
    TaskMetadataModel taskMetadata,
    Function(SubtaskModel, bool) toggleCb) {
  return taskMetadata.checklists
      .map((checklist) => Column(
          children: <Widget>[Text(checklist.name)] +
              checklist.items.map((item) {
                var subtask =
                    subtasks.singleWhere((element) => element.id == item.id);
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
                  Expanded(child: Text(subtask.title))
                ]);
              }).toList()))
      .toList();
}

List<Widget> buildSubtasks(BuildContext context, List<SubtaskModel> subtasks,
    TaskMetadataModel? taskMetadata, Function(SubtaskModel, bool) toggleCb) {
  return taskMetadata != null
      ? buildMultiListSubtasks(context, subtasks, taskMetadata, toggleCb)
      : buildSingleListSubtasks(context, subtasks, toggleCb);
}
