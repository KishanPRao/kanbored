import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/task_action_listener.dart';
import 'package:kanbored/utils.dart';

class Subtask extends StatefulWidget {
  final SubtaskModel subtask;
  final TaskActionListener taskActionListener;

  const Subtask({
    super.key,
    required this.subtask,
    required this.taskActionListener,
  });

  @override
  State<StatefulWidget> createState() => SubtaskState();
}

class SubtaskState extends EditableState<Subtask> {
  late SubtaskModel subtask;
  late TextEditingController controller;
  late TaskActionListener taskActionListener;

  @override
  void initState() {
    super.initState();
    subtask = widget.subtask;
    taskActionListener = widget.taskActionListener;
    controller = TextEditingController(text: "");
  }

  @override
  void didChangeDependencies() {
    controller.text = widget.subtask.title;
    super.didChangeDependencies();
  }

  @override
  void endEdit(bool saveChanges) {
    if (saveChanges) {
      subtask.title = controller.text;
      Api.updateSubtask(subtask).then((value) {
        if (!value) {
          Utils.showErrorSnackbar(context, "Could not update task");
        }
      }).onError((e, _) {
        Utils.showErrorSnackbar(context, e);
      });
    } else {
      controller.text = subtask.title;
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void delete() {
    log("subtask: delete");
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        onTap: () {
          taskActionListener.onChange(controller.text);
          taskActionListener.onEditStart(null);
        },
        onEditingComplete: () {
          taskActionListener.onEditEnd(true);
        },
        onChanged: taskActionListener.onChange,
        decoration: const InputDecoration(border: InputBorder.none));
  }
}
