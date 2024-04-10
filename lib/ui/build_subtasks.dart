import 'package:flutter/material.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/editing_state.dart';

Widget buildSingleSubtask(
    BuildContext context,
    SubtaskModel subtask,
    // int index,
    List<GlobalKey<EditableState>> keysEditableText,
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
        child: TextFormField(
            // key: keysEditableText[index],
            initialValue: subtask.title,
            decoration: const InputDecoration(border: InputBorder.none)))
  ]);
}

List<Widget> buildSingleListSubtasks(
    BuildContext context,
    List<SubtaskModel> subtasks,
    List<GlobalKey<EditableState>> keysEditableText,
    Function(SubtaskModel, bool) toggleCb) {
  return subtasks.asMap().entries.map((entry) {
    int index = entry.key;
    SubtaskModel subtask = entry.value;
    return buildSingleSubtask(context, subtask, keysEditableText, toggleCb);
  }).toList();
}

List<Widget> buildMultiListSubtasks(
    BuildContext context,
    List<SubtaskModel> subtasks,
    TaskMetadataModel taskMetadata,
    List<GlobalKey<EditableState>> keysEditableText,
    Function(SubtaskModel, bool) toggleCb) {
  return taskMetadata.checklists
      .map((checklist) => Column(
          children: <Widget>[
                TextFormField(
                    // key: keysEditableText[index],
                    initialValue: checklist.name,
                    decoration: const InputDecoration(border: InputBorder.none))
              ] +
              checklist.items.map((item) {
                var subtask =
                    subtasks.singleWhere((element) => element.id == item.id);
                return buildSingleSubtask(
                    context, subtask, keysEditableText, toggleCb);
              }).toList()))
      .toList();
}

List<Widget> buildSubtasks(
    BuildContext context,
    List<SubtaskModel> subtasks,
    TaskMetadataModel? taskMetadata,
    List<GlobalKey<EditableState>> keysEditableText,
    Function(SubtaskModel, bool) toggleCb) {
  return taskMetadata != null
      ? buildMultiListSubtasks(
          context, subtasks, taskMetadata, keysEditableText, toggleCb)
      : buildSingleListSubtasks(context, subtasks, keysEditableText, toggleCb);
}
