import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/task_action_listener.dart';
import 'package:kanbored/ui/task_app_bar.dart';
import 'package:kanbored/utils.dart';

class Subtask extends StatefulWidget {
  final SubtaskModel subtask;
  final TaskMetadataModel taskMetadata;
  final CheckListMetadata checklist;
  final TaskActionListener taskActionListener;

  const Subtask({
    super.key,
    required this.subtask,
    required this.taskMetadata,
    required this.checklist,
    required this.taskActionListener,
  });

  @override
  State<StatefulWidget> createState() => SubtaskState();
}

class SubtaskState extends EditableState<Subtask> {
  late SubtaskModel subtask;
  late TaskMetadataModel taskMetadata;
  late CheckListMetadata checklist;
  late TextEditingController controller;
  late TaskActionListener taskActionListener;

  @override
  void initState() {
    super.initState();
    subtask = widget.subtask;
    taskMetadata = widget.taskMetadata;
    checklist = widget.checklist;
    taskActionListener = widget.taskActionListener;
    controller = TextEditingController(text: "");
  }

  @override
  void didChangeDependencies() {
    controller.text = widget.subtask.title;
    super.didChangeDependencies();
  }

  void updateSubtask() {
    Api.updateSubtask(subtask).then((value) {
      if (!value) {
        Utils.showErrorSnackbar(context, "Could not update task");
      }
    }).onError((e, _) {
      Utils.showErrorSnackbar(context, e);
    });
  }

  @override
  void endEdit(bool saveChanges) {
    if (saveChanges) {
      subtask.title = controller.text;
      updateSubtask();
    } else {
      controller.text = subtask.title;
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void updateTaskMetadata() {
    checklist.items.removeWhere(
        (checklistItemMetadata) => checklistItemMetadata.id == subtask.id);
    log("Task metadata, checklist: ${taskMetadata.checklists}");
    Api.saveTaskMetadata(subtask.taskId, taskMetadata).then((value) {
      taskActionListener.refreshUi();
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
  void delete() {
    taskActionListener.onEditEnd(false);
    // TODO: on showing dialog, keeps refreshing data, any action, refreshes, with incomplete data
    Utils.showAlertDialog(context, "${'delete'.resc()} `${subtask.title}`?",
        "alert_del_content".resc(), () {
      Api.removeSubtask(subtask.id).then((value) {
        if (!value) {
          Utils.showErrorSnackbar(context, "Could not delete task");
        } else {
          updateTaskMetadata();
        }
      }).onError((e, _) {
        Utils.showErrorSnackbar(context, e);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Checkbox(
        checkColor: Colors.white, // TODO: themed color!
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return "primary".themed(context);
          }
          return Colors.transparent;
        }),
        value: subtask.status == SubtaskModel.kStatusFinished,
        onChanged: (value) {
          // log("Changed value: $value");
          subtask.status =
              value! ? SubtaskModel.kStatusFinished : SubtaskModel.kStatusTodo;
          updateSubtask();
          setState(() {});
        },
      ),
      Expanded(
          child: TextField(
              controller: controller,
              maxLines: null,
              onTap: () {
                taskActionListener.onChange(controller.text);
                taskActionListener.onEditStart(null, [
                  TaskAppBarAction.kDelete,
                  TaskAppBarAction.kDiscard,
                  TaskAppBarAction.kDone
                ]);
              },
              style: subtask.status == SubtaskModel.kStatusFinished
                  ? const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontStyle: FontStyle.italic)
                  : null,
              onEditingComplete: () {
                taskActionListener.onEditEnd(true);
              },
              onChanged: taskActionListener.onChange,
              decoration: const InputDecoration(border: InputBorder.none)))
    ]);
  }
}
