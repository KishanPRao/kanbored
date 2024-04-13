import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/task_action_listener.dart';

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
  late TextEditingController controller;
  late TaskActionListener taskActionListener;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: "");
    taskActionListener = widget.taskActionListener;
  }

  @override
  void didChangeDependencies() {
    controller.text = widget.subtask.title;
    super.didChangeDependencies();
  }

  @override
  void endEdit(bool saveChanges) {
    if (saveChanges) {
      log("Edit subtask name: ${controller.text}");
    } else {
      controller.text = widget.subtask.title;
    }
    FocusManager.instance.primaryFocus?.unfocus();
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
