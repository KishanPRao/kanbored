import 'package:flutter/material.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/ui/app_theme.dart';

List<Widget> buildSingleListSubtasks(BuildContext context,
    List<SubtaskModel> subtasks, Function(SubtaskModel, bool) toggleCb) {
  return subtasks
      .map((subtask) => Row(children: [
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
          ]))
      .toList();
}
