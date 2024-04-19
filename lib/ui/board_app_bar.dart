import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/models/project_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/board_action_listener.dart';
import 'package:kanbored/utils.dart';

class BoardAppBarAction extends AppBarAction {
  static const kArchive = 5;
  static const kUnarchive = 6;
}

class BoardAppBarActions extends AppBarActions {
  final ProjectModel projectModel;

  const BoardAppBarActions(
      {super.key, required this.projectModel, required super.abActionListener});

  @override
  State<StatefulWidget> createState() => BoardAppBarActionsState();
}

class BoardAppBarActionsState extends AppBarActionsState<BoardAppBarActions> {
  late ProjectModel projectModel;

  @override
  void initState() {
    super.initState();
    projectModel = widget.projectModel;
  }

  @override
  void delete() {
    log("board, delete");
    abActionListener.onDelete();
  }

  @override
  void archive() {
    log("board, archive");
    (abActionListener as BoardActionListener).onArchive();
  }

  @override
  void unarchive() => (abActionListener as BoardActionListener).onUnarchive();

  @override
  Future<void> handlePopupAction(String action) async {
    log("board, handlePopupAction: $action");
    if (action == "archived".resc()) {
      (abActionListener as BoardActionListener).onArchived();
    } else if (action == "archive".resc() || action == "unarchive".resc()) {
      log("Archive/Unarchive");
    } else if (action == "delete".resc()) {
      Utils.showAlertDialog(
          context,
          "${'delete'.resc()} `${projectModel.name}`?",
          "alert_del_content".resc(), () {
        log("Delete project");
        // Api.removeTask(taskModel.id);
        // Navigator.pop(context);
      });
    }
  }

  @override
  Widget getButton(int action) {
    // log("board, getButton: $action");
    switch (action) {
      case AppBarAction.kMain:
        return IconButton(
          onPressed: () {
            log("Search");
            // abActionListener.onMainAction?.call();
          },
          icon: const Icon(Icons.search),
          tooltip: "tt_search".resc(),
        );
      case AppBarAction.kPopup:
        return PopupMenuButton<String>(
          onSelected: handlePopupAction,
          itemBuilder: (BuildContext context) {
            return {
              "archived".resc(),
              // taskModel.isActive ? "archive".resc() : "unarchive".resc(),
              "archive".resc(),
              "delete".resc(),
            }.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        );
      case BoardAppBarAction.kArchive:
        return IconButton(
          onPressed: () => archive(),
          // color: showActive ? Colors.grey : Colors.red, //TODO
          icon: const Icon(Icons.archive),
          tooltip: "archive".resc(),
        );
      case BoardAppBarAction.kUnarchive:
        return IconButton(
          onPressed: () => unarchive(),
          color: "unarchiveBgColor".themed(context), //TODO
          icon: const Icon(Icons.unarchive),
          tooltip: "unarchive".resc(),
        );
      default:
        return super.getButton(action);
    }
  }
}
