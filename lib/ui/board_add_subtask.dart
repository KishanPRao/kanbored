import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/db/converters.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils/utils.dart';

class BoardAddSubtask extends ConsumerStatefulWidget {
  final TaskModelData task;
  final TaskMetadataModelData taskMetadata;
  final ChecklistMetadata checklist;

  const BoardAddSubtask(
      {super.key,
      required this.task,
      required this.taskMetadata,
      required this.checklist});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoardAddSubtaskState();
}

class BoardAddSubtaskState extends EditableState<BoardAddSubtask> {
  var focusNode = FocusNode();
  late TaskModelData task;
  late TaskMetadataModelData taskMetadata;
  late ChecklistMetadata checklist;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    task = widget.task;
    taskMetadata = widget.taskMetadata;
    checklist = widget.checklist;
    // abActionListener = widget.abActionListener;
    controller = TextEditingController(text: "");
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  void startEdit() {
    log("add subtask: startEditing");
    ref.read(UiState.boardActiveState.notifier).state =
        widget.key as GlobalKey<EditableState>;
    ref.read(UiState.boardActiveText.notifier).state = controller.text;
    ref.read(UiState.boardActions.notifier).state = [
      AppBarAction.kDiscard,
      AppBarAction.kDone
    ];
    ref.read(UiState.boardEditing.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
        child: TextField(
            controller: controller,
            onTap: () {
              log("ontap");
              startEdit();
            },
            onSubmitted: (value) {
              log("onsubmitted");
              endEdit(true);
            },
            onChanged: (value) => ref.read(UiState.boardActiveText.notifier).state = value,
            decoration: InputDecoration(
                hintText: "add_subtask".resc(),
                border: InputBorder.none,
                hintStyle: const TextStyle(fontWeight: FontWeight.w400))));
  }

  @override
  void endEdit(bool saveChanges) async {
    log("add subtask, endEdit: $saveChanges");
    ref.read(UiState.boardEditing.notifier).state = false;
    if (saveChanges) {
      var id = await Api.instance
          .createSubtask(
        ref,
        controller.text,
        task.id,
      );
      log("Add a new subtask: ${controller.text}, into checklist: ${checklist.title}; local id: $id");
      // TODO: position within checklist item metadata? Or simply array order?
      checklist.items.add(CheckListItemMetadata(id));
      Api.instance.updateChecklistWithSubtask(ref, taskMetadata, id);
      // TODO: error handling needed?
    }
    controller.text = "";
    log("add subtask, unfocus");
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
