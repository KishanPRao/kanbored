import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/utils.dart';

class TaskAppBarActions extends AppBarActions {
  final TaskModel taskModel;

  const TaskAppBarActions(
      {super.key, required this.taskModel, required super.abActionListener});

  @override
  State<StatefulWidget> createState() => TaskAppBarActionsState();
}

class TaskAppBarActionsState extends AppBarActionsState<TaskAppBarActions> {
  late TaskModel taskModel;

  @override
  void initState() {
    super.initState();
    taskModel = widget.taskModel;
  }

  @override
  Iterable<String> getPopupNames() => {
        taskModel.isActive ? "archive".resc() : "unarchive".resc(),
        "rename".resc(),
        "delete".resc(),
      };

  @override
  void delete() => abActionListener.onDelete();

  // TODO: find out why re-build invoked
  @override
  Future<void> handlePopupAction(String action) async {
    if (action == "archive".resc() || action == "unarchive".resc()) {
      log("Archive/Unarchive");
      taskModel.isActive = !taskModel.isActive;
      (taskModel.isActive
              ? Api.openTask(taskModel.id)
              : Api.closeTask(taskModel.id))
          .then((value) {
        if (!value) {
          Utils.showErrorSnackbar(context, "Could not update task");
        } else {
          // TODO: bug: Does not refresh archived list
          abActionListener.refreshUi();
          log("Updated task");
        }
      }).catchError((e) => Utils.showErrorSnackbar(context, e));
    } else if (action == "delete".resc()) {
      Utils.showAlertDialog(context, "${'delete'.resc()} `${taskModel.title}`?",
          "alert_del_content".resc(), () {
        log("Delete task");
        Api.removeTask(taskModel.id);
        Navigator.pop(context);
      });
    } else if (action == "rename".resc()) {
      log("Rename task");
      Utils.showInputAlertDialog(context, "rename_task".resc(),
          "alert_rename_task_content".resc(), taskModel.title, (title) {
        log("project, rename task: $title");
        taskModel.title = title;
        Api.updateTask(taskModel).then((result) {
          if (result) {
            abActionListener.refreshUi();
          } else {
            Utils.showErrorSnackbar(context, "Could not rename task");
          }
        }).onError((e, st) => Utils.showErrorSnackbar(context, e));
      });
    }
  }

  @override
  Widget getButton(int action) {
    switch (action) {
      case AppBarAction.kMain:
        return IconButton(
          onPressed: () {
            log("Add checklist");
            abActionListener.onMainAction?.call();
          },
          icon: const Icon(Icons.format_list_bulleted_add),
          tooltip: "tt_add_checklist".resc(),
        );
      default:
        return super.getButton(action);
    }
  }
}
