import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils.dart';

class TaskAppBarActions extends AppBarActions {
  const TaskAppBarActions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      TaskAppBarActionsState();
}

class TaskAppBarActionsState extends AppBarActionsState<TaskAppBarActions> {
  @override
  Iterable<String> getPopupNames() => {
        ref.read(activeTask)!.isActive == 1
            ? "archive".resc()
            : "unarchive".resc(),
        "rename".resc(),
        "delete".resc(),
      };

  @override
  void delete() {
    // abActionListener.onDelete();
    log("task, delete");
    ref.read(UiState.boardActiveState.notifier).state?.currentState?.delete();
  }

  @override
  void mainAction() {
    log("task main");
  }

  // TODO: find out why re-build invoked
  @override
  Future<void> handlePopupAction(String action) async {
    final taskModel = ref.read(activeTask)!;
    if (action == "archive".resc() || action == "unarchive".resc()) {
      log("Archive/Unarchive");
      final updatedTask = taskModel.copyWith(isActive: 1 - taskModel.isActive);
      (updatedTask.isActive == 1
              ? Api.openTask(ref, taskModel.id)
              : Api.closeTask(ref, taskModel.id))
          .then((value) {
        if (!value) {
          Utils.showErrorSnackbar(context, "Could not update task");
        } else {
          ref.read(activeTask.notifier).state = updatedTask;
          // TODO: bug: Does not refresh archived list
          // abActionListener.refreshUi();
          log("arch/unarch updated task??");
        }
      }).catchError((e) => Utils.showErrorSnackbar(context, e));
    } else if (action == "delete".resc()) {
      Utils.showAlertDialog(context, "${'delete'.resc()} `${taskModel.title}`?",
          "alert_del_content".resc(), () {
        log("Delete task");
        Api.removeTask(ref, taskModel.id);
        ref.read(activeTask.notifier).state = null;
        Navigator.pop(context);
      });
    } else if (action == "rename".resc()) {
      log("Rename task");
      Utils.showInputAlertDialog(context, "rename_task".resc(),
          "alert_rename_task_content".resc(), taskModel.title, (title) {
        log("project, rename task: $title");
        final updatedTask = taskModel.copyWith(title: title);
        Api.updateTask(ref, updatedTask).then((result) {
          if (result) {
            ref.read(activeTask.notifier).state = updatedTask;
            // abActionListener.refreshUi();
            log("rename task??");
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
          onPressed: mainAction,
          icon: const Icon(Icons.format_list_bulleted_add),
          tooltip: "tt_add_checklist".resc(),
        );
      default:
        return super.getButton(action);
    }
  }
}
