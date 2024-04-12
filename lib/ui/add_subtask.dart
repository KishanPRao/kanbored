import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/ui/editing_state.dart';

class AddSubtask extends StatefulWidget {
  final Function(String) onChange;
  final Function() onEditStart;
  final bool Function(bool) onEditEnd;

  const AddSubtask({
    super.key,
    required this.onChange,
    required this.onEditStart,
    required this.onEditEnd,
  });

  @override
  State<StatefulWidget> createState() => AddSubtaskState();
}

class AddSubtaskState extends EditableState<AddSubtask> {
  late TextEditingController controller;
  late Function(String) onChange;
  late Function() onEditStart;
  late bool Function(bool) onEditEnd;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: "");
    onChange = widget.onChange;
    onEditStart = widget.onEditStart;
    onEditEnd = widget.onEditEnd;
  }

  @override
  void endEdit(bool saveChanges) {
    if (saveChanges) {
      log("Add a new subtask: ${controller.text}");
    } else {
      controller.text = "";
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        onTap: () {
          onChange(controller.text);
          onEditStart();
        },
        onEditingComplete: () {
          onEditEnd(true);
        },
        onChanged: onChange,
        decoration: const InputDecoration(
            hintText: "Add a new subtask",
            border: InputBorder.none,
            hintStyle: TextStyle(fontWeight: FontWeight.w300)));
  }
}
