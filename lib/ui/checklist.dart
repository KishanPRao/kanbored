import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/task_action_listener.dart';

class Checklist extends StatefulWidget {
  final CheckListMetadata checklist;
  final TaskActionListener taskActionListener;

  const Checklist({
    super.key,
    required this.checklist,
    required this.taskActionListener,
  });

  @override
  State<StatefulWidget> createState() => ChecklistState();
}

class ChecklistState extends EditableState<Checklist> {
  late TextEditingController controller;
  late TaskActionListener taskActionListener;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.checklist.name);
    taskActionListener = widget.taskActionListener;
  }

  @override
  void endEdit(bool saveChanges) {
    if (saveChanges) {
      log("Edit checklist name: ${controller.text}");
    } else {
      controller.text = widget.checklist.name;
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
      onChanged: taskActionListener.onChange,
      onEditingComplete: () {
        taskActionListener.onEditEnd(true);
      },
      decoration: const InputDecoration(border: InputBorder.none),
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
