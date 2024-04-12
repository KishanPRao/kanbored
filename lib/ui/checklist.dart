import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/ui/editing_state.dart';

class Checklist extends StatefulWidget {
  final CheckListMetadata checkListMetadata;
  final Function(String) onChange;
  final Function() onEditStart;
  final Function(bool) onEditEnd;

  const Checklist(
      {super.key,
      required this.checkListMetadata,
      required this.onChange,
      required this.onEditStart,
      required this.onEditEnd,
      });

  @override
  State<StatefulWidget> createState() => ChecklistState();
}

class ChecklistState extends EditableState<Checklist> {
  late TextEditingController controller;
  late Function(String) onChange;
  late Function() onEditStart;
  late Function(bool) onEditEnd;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.checkListMetadata.name);
    onChange = widget.onChange;
    onEditStart = widget.onEditStart;
    onEditEnd = widget.onEditEnd;
  }

  @override
  void endEdit(bool saveChanges) {
    if (saveChanges) {
      // TODO
    } else {
      controller.text = widget.checkListMetadata.name;
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        onTap: onEditStart,
        onChanged: onChange,
        onEditingComplete: () {
          log("Editing complete!");
          endEdit(true);
          onEditEnd(true);
        },
        decoration: const InputDecoration(border: InputBorder.none));
  }
}
