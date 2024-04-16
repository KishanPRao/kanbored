import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/task_action_listener.dart';
import 'package:kanbored/ui/task_app_bar.dart';
import 'package:kanbored/utils.dart';

class Checklist extends StatefulWidget {
  // TODO: store taskId in one of the metadata classes / in bridge!
  final CheckListMetadata checklist;
  final TaskMetadataModel taskMetadata;
  final TaskModel task;
  final TaskActionListener taskActionListener;

  const Checklist({
    super.key,
    required this.checklist,
    required this.task,
    required this.taskActionListener,
    required this.taskMetadata,
  });

  @override
  State<StatefulWidget> createState() => ChecklistState();
}

class ChecklistState extends EditableState<Checklist> {
  late CheckListMetadata checklist;
  late TaskMetadataModel taskMetadata;
  late TaskModel task;
  late TaskActionListener taskActionListener;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    checklist = widget.checklist;
    taskMetadata = widget.taskMetadata;
    task = widget.task;
    taskActionListener = widget.taskActionListener;
    controller = TextEditingController(text: widget.checklist.name);
  }

  @override
  void endEdit(bool saveChanges) {
    if (saveChanges) {
      log("Edit checklist name: ${controller.text}");
      checklist.name = controller.text;
      log("Task metadata, checklist: ${taskMetadata.checklists}");
      Api.saveTaskMetadata(task.id, taskMetadata).then((value) {
        // taskActionListener.refreshUi();
        if (!value) {
          log("Could not store metadata!");
          Utils.showErrorSnackbar(context, "Could not save task metadata");
        } else {
          log("Stored metadata!");
        }
      }).catchError((e) => Utils.showErrorSnackbar(context, e));
      log("Task metadata: ${taskMetadata.toJson()}");
    } else {
      controller.text = widget.checklist.name;
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void deleteChecklist() async {
    for (var item in checklist.items) {
      await Api.removeSubtask(item.id);
      // TODO: enable async mass delete after local state used
    }
    taskMetadata.checklists.removeWhere((checklist) =>
        checklist.name == this.checklist.name &&
        checklist.position == this.checklist.position);
    // Update existing positions
    taskMetadata.checklists.sort((a, b) {
      if (a.position > b.position) {
        return 1;
      }
      return -1;
    });
    for (var (idx, checklist) in taskMetadata.checklists.indexed) {
      checklist.position = idx;
    }
    log("Task metadata, checklist: ${taskMetadata.checklists}");
    Api.saveTaskMetadata(task.id, taskMetadata).then((value) {
      if (!value) {
        log("Could not store metadata!");
        Utils.showErrorSnackbar(context, "Could not save task metadata");
      } else {
        taskActionListener.refreshUi();
        log("Stored metadata!");
      }
    }).catchError((e) => Utils.showErrorSnackbar(context, e));
    log("Task metadata: ${taskMetadata.toJson()}");
  }

  @override
  void delete() {
    taskActionListener.onEditEnd(false);
    log("checklist: delete");
    Utils.showAlertDialog(context, "${'delete'.resc()} `${checklist.name}`?",
        "alert_del_content".resc(), () {
      deleteChecklist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTap: () {
        taskActionListener.onChange(controller.text);
        taskActionListener.onEditStart(null, [
          TaskAppBarAction.kDelete,
          TaskAppBarAction.kDiscard,
          TaskAppBarAction.kDone
        ]);
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
