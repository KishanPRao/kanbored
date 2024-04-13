import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/task_action_listener.dart';
import 'package:kanbored/utils.dart';

class AddSubtask extends StatefulWidget {
  final CheckListMetadata? checklist;
  final TaskMetadataModel? taskMetadata;
  final TaskModel task;
  final TaskActionListener taskActionListener;

  const AddSubtask({
    super.key,
    required this.checklist,
    required this.taskMetadata,
    required this.task,
    required this.taskActionListener,
  });

  @override
  State<StatefulWidget> createState() => AddSubtaskState();
}

class AddSubtaskState extends EditableState<AddSubtask> {
  late CheckListMetadata? checklist;
  late TaskMetadataModel? taskMetadata;
  late TaskModel task;
  late TextEditingController controller;
  late TaskActionListener taskActionListener;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: "");
    taskActionListener = widget.taskActionListener;
    task = widget.task;
    taskMetadata = widget.taskMetadata;
    checklist = widget.checklist;
    log("Task metadata, checklist: ${taskMetadata?.checklists}");
  }

  bool updateTaskMetadata(int subtaskId) {
    var taskMetadata = this.taskMetadata;
    var checklistMetadata = checklist;
    if (taskMetadata != null && checklistMetadata != null) {
      outerLoop:
      for (var checklist in taskMetadata.checklists) {
        if (checklist.name == checklistMetadata.name &&
            checklist.position == checklistMetadata.position) {
          checklist.items.add(CheckListItemMetadata(id: subtaskId));
          break outerLoop;
        }
      }
      log("Task metadata, checklist: ${taskMetadata.checklists}");
      Api.saveTaskMetadata(task.id, taskMetadata).then((value) {
        taskActionListener.refreshUi();
        if (!value) {
          log("Could not store metadata!");
          Utils.showErrorSnackbar(context, "Could not save task metadata");
        } else {
          log("Stored metadata!");
        }
      }).catchError((e) => Utils.showErrorSnackbar(context, e));
      log("Task metadata: ${taskMetadata.toJson()}");
      return false;
    }
    return true;
  }

  @override
  void endEdit(bool saveChanges) async {
    if (saveChanges) {
      log("Add a new subtask: ${controller.text}, into task: ${task.title} & checklist: ${taskMetadata?.checklists}");
      Api.createSubtask(task.id, controller.text).then((subtaskId) {
        if (updateTaskMetadata(subtaskId)) {
          taskActionListener.refreshUi();
        }
      }).catchError((e) => Utils.showErrorSnackbar(context, e));
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
          taskActionListener.onChange(controller.text);
          taskActionListener.onEditStart(null);
        },
        onEditingComplete: () {
          taskActionListener.onEditEnd(true);
        },
        onChanged: taskActionListener.onChange,
        decoration: const InputDecoration(
            hintText: "Add a new subtask",
            border: InputBorder.none,
            hintStyle: TextStyle(fontWeight: FontWeight.w300)));
  }
}
