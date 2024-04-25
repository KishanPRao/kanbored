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
import 'package:kanbored/utils/utils.dart';

class Checklist extends ConsumerStatefulWidget {
  // TODO: store taskId in one of the metadata classes / in bridge!
  final CheckListMetadata checklist;
  final TaskMetadataModel taskMetadata;
  final TaskModel task;
  final AppBarActionListener abActionListener;

  const Checklist({
    super.key,
    required this.checklist,
    required this.task,
    required this.abActionListener,
    required this.taskMetadata,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ChecklistState();
}

class ChecklistState extends EditableState<Checklist> {
  late CheckListMetadata checklist;
  late TaskMetadataModel taskMetadata;
  late TaskModel task;
  late AppBarActionListener abActionListener;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    checklist = widget.checklist;
    taskMetadata = widget.taskMetadata;
    task = widget.task;
    abActionListener = widget.abActionListener;
    controller = TextEditingController(text: widget.checklist.name);
  }

  @override
  void endEdit(bool saveChanges) {
    if (saveChanges) {
      if (checklist.name != controller.text) {
        log("Edit checklist name: ${controller.text}");
        checklist.name = controller.text;
        log("Task metadata, checklist: ${taskMetadata.checklists}");
        WebApi.saveTaskMetadata(task.id, taskMetadata).then((value) {
          // abActionListener.refreshUi();
          if (!value) {
            log("Could not store metadata!");
            Utils.showErrorSnackbar(context, "Could not save task metadata");
          } else {
            log("Stored metadata!");
          }
        }).catchError((e) => Utils.showErrorSnackbar(context, e));
        log("Task metadata: ${taskMetadata.toJson()}");
      }
    } else {
      controller.text = widget.checklist.name;
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void deleteChecklist() async {
    for (var item in checklist.items) {
      await WebApi.removeSubtask(item.id);
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
    WebApi.saveTaskMetadata(task.id, taskMetadata).then((value) {
      if (!value) {
        log("Could not store metadata!");
        Utils.showErrorSnackbar(context, "Could not save task metadata");
      } else {
        abActionListener.refreshUi();
        log("Stored metadata!");
      }
    }).catchError((e) => Utils.showErrorSnackbar(context, e));
    log("Task metadata: ${taskMetadata.toJson()}");
  }

  @override
  void delete() {
    abActionListener.onEditEnd(false);
    log("checklist: delete");
    Utils.showAlertDialog(context, "${'delete'.resc()} `${checklist.name}`?",
        "alert_del_content".resc(), () {
      deleteChecklist();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: use popup button, Hide Completed, Edit & Delete buttons? Or keep it simple?
    return TextField(
      controller: controller,
      onTap: () {
        abActionListener.onChange(controller.text);
        abActionListener.onEditStart(null, [
          AppBarAction.kDelete,
          AppBarAction.kDiscard,
          AppBarAction.kDone
        ]);
      },
      onChanged: abActionListener.onChange,
      onEditingComplete: () => abActionListener.onEditEnd(true),
      decoration: const InputDecoration(border: InputBorder.none),
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
