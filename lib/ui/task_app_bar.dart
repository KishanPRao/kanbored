import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/utils.dart';

import 'editing_state.dart';

// enum TaskAppBarAction {
//   kDelete,
//   kDiscard,
//   kDone,
//   kAddChecklist,
//   kPopup,
// }

class TaskAppBarActions extends StatefulWidget {
  final TaskModel taskModel;
  final AppBarActionListener abActionListener;

  const TaskAppBarActions(
      {super.key, required this.taskModel, required this.abActionListener});

  @override
  State<StatefulWidget> createState() => TaskAppBarActionsState();
}

class TaskAppBarActionsState extends EditableState<TaskAppBarActions> {
  late TaskModel taskModel;
  late AppBarActionListener abActionListener;
  bool _editing = false;
  var defaultActions = [
    AppBarAction.kMain,
    AppBarAction.kPopup,
  ];
  var currentActions = [];

  @override
  void initState() {
    super.initState();
    taskModel = widget.taskModel;
    abActionListener = widget.abActionListener;
  }

  @override
  void startEdit() {
    setState(() {
      _editing = true;
    });
  }

  @override
  void endEdit(bool _) {
    if (_editing) {
      setState(() {
        _editing = false;
      });
    }
  }

  @override
  void delete() => abActionListener.onDelete();

  void stopEdit(bool saveChanges) {
    if (abActionListener.onEditEnd(saveChanges)) {
      endEdit(saveChanges);
    }
  }

  // TODO: find out why re-build invoked
  Future<void> handlePopupAction(String action) async {
    if (action == "archive".resc() || action == "unarchive".resc()) {
      log("Archive/Unarchive");
      taskModel.isActive = !taskModel.isActive;
      if (taskModel.isActive) {
        Api.openTask(taskModel.id);
      } else {
        Api.closeTask(taskModel.id);
      }
    } else if (action == "delete".resc()) {
      Utils.showAlertDialog(context, "${'delete'.resc()} `${taskModel.title}`?",
          "alert_del_content".resc(), () {
        log("Delete task");
        Api.removeTask(taskModel.id);
        Navigator.pop(context);
      });
    }
  }

  Widget getButton(int action) {
    switch (action) {
      case AppBarAction.kDelete:
        return IconButton(
          onPressed: () => delete(),
          // color: showActive ? Colors.grey : Colors.red, //TODO
          icon: const Icon(Icons.delete),
          tooltip: "delete".resc(),
        );
      case AppBarAction.kDiscard:
        return IconButton(
          onPressed: () => stopEdit(false),
          // color: showActive ? Colors.grey : Colors.red, //TODO
          icon: const Icon(Icons.undo),
          tooltip: "tt_discard".resc(),
        );
      case AppBarAction.kDone:
        return IconButton(
          onPressed: () => stopEdit(true),
          // color: showActive ? Colors.grey : Colors.red, //TODO
          icon: const Icon(Icons.done),
          tooltip: "tt_done".resc(),
        );
      case AppBarAction.kMain:
        return IconButton(
          onPressed: () {
            log("Add checklist");
            abActionListener.onMainAction?.call();
          },
          icon: const Icon(Icons.format_list_bulleted_add),
          tooltip: "tt_add_checklist".resc(),
        );
      case AppBarAction.kPopup:
        return PopupMenuButton<String>(
          onSelected: handlePopupAction,
          itemBuilder: (BuildContext context) {
            return {
              taskModel.isActive ? "archive".resc() : "unarchive".resc(),
              "delete".resc(),
            }.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        );
      default:
        log("Could not find matching app bar action buttons!");
        return Utils.emptyUi();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: (_editing ? currentActions : defaultActions)
            .map((e) => getButton(e))
            .toList());
  }
}
