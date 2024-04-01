import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/ui/app_theme.dart';
import 'package:kanbored/ui/single_list_subtasks.dart';

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
                        return context.theme.appColors.primary;
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
