import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/db/dao/task_metadata_dao.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils/utils.dart';

class TaskAppBarActions extends AppBarActions {
  const TaskAppBarActions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      TaskAppBarActionsState();
}

class TaskAppBarActionsState extends AppBarActionsState<TaskAppBarActions> {
  late TaskModelData task;
  // late TaskMetadataDao taskMetadataDao;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // taskMetadataDao = ref.read(AppDatabase.provider).taskMetadataDao;
  }

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
    log("task main, add checklist");
    // var taskMetadata = taskMetadataDao.getTaskMetadataForTask(task.id);
    // taskMetadataDao.addChecklist()
    Utils.showInputAlertDialog(context, "alert_new_checklist".resc(),
        "alert_new_checklist_content".resc(), "", (title) {
          log("task, add checklist: $title");
          // taskMetadataDao.addChecklist(title);
          // final updatedTask = task.copyWith(title: title);
          Api.instance.addChecklist(ref, task.id, title);
          // ref.read(activeTask.notifier).state = updatedTask;
          // abActionListener.refreshUi();
        });
  }

  // TODO: find out why re-build invoked
  @override
  Future<void> handlePopupAction(String action) async {
    // final taskModel = ref.read(activeTask)!;
    if (action == "archive".resc() || action == "unarchive".resc()) {
      log("Archive/Unarchive");
      final updatedTask = task.copyWith(isActive: 1 - task.isActive);
      (updatedTask.isActive == 1
          ? Api.instance.openTask(ref, task.id)
          : Api.instance.closeTask(ref, task.id));

      ref.read(activeTask.notifier).state = updatedTask;
      // TODO: bug: Does not refresh archived list
      // abActionListener.refreshUi();
      log("arch/unarch updated task??");
    } else if (action == "delete".resc()) {
      Utils.showAlertDialog(context, "${'delete'.resc()} `${task.title}`?",
          "alert_del_content".resc(), () {
        log("Delete task");
        Api.instance.removeTask(ref, task.id);
        ref.read(activeTask.notifier).state = null;
        Navigator.pop(context);
      });
    } else if (action == "rename".resc()) {
      log("Rename task");
      Utils.showInputAlertDialog(context, "rename_task".resc(),
          "alert_rename_task_content".resc(), task.title, (title) {
        log("project, rename task: $title");
        final updatedTask = task.copyWith(title: title);
        Api.instance.updateTask(ref, updatedTask);
        ref.read(activeTask.notifier).state = updatedTask;
        // abActionListener.refreshUi();
        log("rename task??");
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

  @override
  Widget build(BuildContext context) {
    var task = ref.watch(activeTask);
    if (task != null) {
      this.task = task;
    }
    return super.build(context);
  }
}
