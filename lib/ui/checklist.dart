import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/ui/editing_state.dart';

class Checklist extends StatefulWidget {
  final CheckListMetadata checkListMetadata;
  final Function(String) onChange;
  final Function() onEditStart;
  final bool Function(bool) onEditEnd;

  const Checklist({
    super.key,
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
  late bool Function(bool) onEditEnd;

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
      log("Edit checklist name: ${controller.text}");
    } else {
      controller.text = widget.checkListMetadata.name;
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
      onChanged: onChange,
      onEditingComplete: () {
        onEditEnd(true);
      },
      decoration: const InputDecoration(border: InputBorder.none),
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
