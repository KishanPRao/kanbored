import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/ui/task_app_bar.dart';
import 'package:kanbored/utils/utils.dart';

class AddSubtask extends ConsumerStatefulWidget {
  final CheckListMetadata checklist;
  final TaskMetadataModel taskMetadata;
  final TaskModel task;
  final AppBarActionListener abActionListener;

  const AddSubtask({
    super.key,
    required this.checklist,
    required this.taskMetadata,
    required this.task,
    required this.abActionListener,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AddSubtaskState();
}

class AddSubtaskState extends EditableState<AddSubtask> {
  late CheckListMetadata checklist;
  late TaskMetadataModel taskMetadata;
  late TaskModel task;
  late AppBarActionListener abActionListener;

  @override
  void initState() {
    super.initState();
    abActionListener = widget.abActionListener;
    task = widget.task;
    taskMetadata = widget.taskMetadata;
    checklist = widget.checklist;
    editActions = [
      AppBarAction.kDiscard,
      AppBarAction.kDone
    ];
    log("Task metadata, checklist: ${taskMetadata.checklists}");
  }

  void updateTaskMetadata(int subtaskId) {
    // outerLoop:
    // for (var checklist in taskMetadata.checklists) {
    //   if (checklist.name == this.checklist.name &&
    //       checklist.position == this.checklist.position) {
    //     checklist.items.add(CheckListItemMetadata(id: subtaskId));
    //     break outerLoop;
    //   }
    // }
    checklist.items.add(CheckListItemMetadata(id: subtaskId));
    log("Task metadata, checklist: ${taskMetadata.checklists}");
    WebApi.saveTaskMetadata(task.id, taskMetadata).then((value) {
      abActionListener.refreshUi();
      if (!value) {
        log("Could not store metadata!");
        Utils.showErrorSnackbar(context, "Could not save task metadata");
      } else {
        log("Stored metadata!");
      }
    }).catchError((e) => Utils.showErrorSnackbar(context, e));
    log("Task metadata: ${taskMetadata.toJson()}");
  }

  @override
  Future<bool> endEdit(bool saveChanges) async {
    if (saveChanges) {
      log("Add a new subtask: ${controller.text}, into task: ${task.title} & checklist: ${taskMetadata.checklists}");
      WebApi.createSubtask(task.id, controller.text)
          .then((subtaskId) => updateTaskMetadata(subtaskId))
          .catchError((e) => Utils.showErrorSnackbar(context, e));
    } else {
      controller.text = "";
    }
    FocusManager.instance.primaryFocus?.unfocus();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
        child: TextField(
            controller: controller,
            onTap: () {
              abActionListener.onChange(controller.text);
              abActionListener.onEditStart(
                  null, [AppBarAction.kDiscard, AppBarAction.kDone]);
            },
            onEditingComplete: () {
              abActionListener.onEditEnd(true);
            },
            onChanged: abActionListener.onChange,
            decoration: InputDecoration(
                hintText: "add_subtask".resc(),
                border: InputBorder.none,
                hintStyle: const TextStyle(fontWeight: FontWeight.w400))));
  }
}
