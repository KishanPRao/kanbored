import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/ui/editing_state.dart';

class Subtask extends StatefulWidget {
  final SubtaskModel subtask;
  final Function(String) onChange;
  final Function() onEditStart;
  final Function(bool) onEditEnd;

  const Subtask(
      {super.key,
      required this.subtask,
      required this.onChange,
      required this.onEditStart,
      required this.onEditEnd,
      });

  @override
  State<StatefulWidget> createState() => SubtaskState();
}

class SubtaskState extends EditableState<Subtask> {
  late TextEditingController controller;
  late Function(String) onChange;
  late Function() onEditStart;
  late Function(bool) onEditEnd;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: "");
    onChange = widget.onChange;
    onEditStart = widget.onEditStart;
    onEditEnd = widget.onEditEnd;
  }

  @override
  void didChangeDependencies() {
    controller.text = widget.subtask.title;
    super.didChangeDependencies();
  }

  void updateSubtaskTitle() {
    String newTitle = controller.text;
    // TODO
  }

  @override
  void endEdit(bool saveChanges) {
    if (saveChanges) {
      // TODO
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
          onEditStart();
        },
        onEditingComplete: () {
          log("Editing complete!");
          updateSubtaskTitle();
          endEdit(true);
          onEditEnd(true);
        },
        onChanged: onChange,
        decoration: const InputDecoration(border: InputBorder.none));
  }
}
