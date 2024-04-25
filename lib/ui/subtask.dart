import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/ui/task_app_bar.dart';
import 'package:kanbored/utils/utils.dart';

class Subtask extends ConsumerStatefulWidget {
  final SubtaskModel subtask;
  final TaskMetadataModel taskMetadata;
  final CheckListMetadata checklist;
  final AppBarActionListener abActionListener;

  const Subtask({
    super.key,
    required this.subtask,
    required this.taskMetadata,
    required this.checklist,
    required this.abActionListener,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SubtaskState();
}

class SubtaskState extends EditableState<Subtask> {
  late SubtaskModel subtask;
  late TaskMetadataModel taskMetadata;
  late CheckListMetadata checklist;
  late TextEditingController controller;
  late AppBarActionListener abActionListener;

  @override
  void initState() {
    super.initState();
    subtask = widget.subtask;
    taskMetadata = widget.taskMetadata;
    checklist = widget.checklist;
    abActionListener = widget.abActionListener;
    controller = TextEditingController(text: "");
  }

  @override
  void didChangeDependencies() {
    controller.text = widget.subtask.title;
    super.didChangeDependencies();
  }

  void updateSubtask() {
    WebApi.updateSubtask(subtask).then((value) {
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
      if (subtask.title != controller.text) {
        subtask.title = controller.text;
        updateSubtask();
      }
    } else {
      controller.text = subtask.title;
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void updateTaskMetadata() {
    checklist.items.removeWhere(
        (checklistItemMetadata) => checklistItemMetadata.id == subtask.id);
    log("Task metadata, checklist: ${taskMetadata.checklists}");
    WebApi.saveTaskMetadata(subtask.taskId, taskMetadata).then((value) {
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
  void delete() {
    abActionListener.onEditEnd(false);
    // TODO: on showing dialog, keeps refreshing data, any action, refreshes, with incomplete data
    Utils.showAlertDialog(context, "${'delete'.resc()} `${subtask.title}`?",
        "alert_del_content".resc(), () {
      WebApi.removeSubtask(subtask.id).then((value) {
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
              textInputAction: TextInputAction.go,
              onTap: () {
                abActionListener.onChange(controller.text);
                abActionListener.onEditStart(null, [
                  AppBarAction.kDelete,
                  AppBarAction.kDiscard,
                  AppBarAction.kDone
                ]);
              },
              style: subtask.status == SubtaskModel.kStatusFinished
                  ? const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontStyle: FontStyle.italic)
                  : null,
              onEditingComplete: () {
                abActionListener.onEditEnd(true);
              },
              onChanged: abActionListener.onChange,
              decoration: const InputDecoration(border: InputBorder.none)))
    ]);
  }
}
