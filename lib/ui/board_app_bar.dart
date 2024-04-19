import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
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
  final bool showArchived;

  const BoardAppBarActions(
      {super.key,
      required this.projectModel,
      required this.showArchived,
      required super.abActionListener});

  @override
  State<StatefulWidget> createState() => BoardAppBarActionsState();
}

class BoardAppBarActionsState extends AppBarActionsState<BoardAppBarActions> {
  late ProjectModel projectModel;
  late bool showArchived;

  @override
  void initState() {
    super.initState();
    projectModel = widget.projectModel;
    showArchived = widget.showArchived;
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

  void toggleArchive() {
    projectModel.isActive = !projectModel.isActive;
    (projectModel.isActive
            ? Api.enableProject(projectModel.id)
            : Api.disableProject(projectModel.id))
        .then((value) {
      if (!value) {
        Utils.showErrorSnackbar(context, "Could not update project");
      } else {
        // TODO: bug: Does not refresh archived list
        abActionListener.refreshUi();
        log("Updated project");
      }
    }).catchError((e) => Utils.showErrorSnackbar(context, e));
  }

  // Project level
  @override
  Future<void> handlePopupAction(String action) async {
    log("board, handlePopupAction: $action");
    if (action == "hide_archived".resc() || action == "show_archived".resc()) {
      showArchived = !showArchived;
      (abActionListener as BoardActionListener).onArchived(showArchived);
    } else if (action == "archive".resc() || action == "unarchive".resc()) {
      log("Archive/Unarchive");
      if (projectModel.isActive) {
        Utils.showAlertDialog(
            context,
            "${'archive'.resc()} `${projectModel.name}`?",
            "alert_arch_content".resc(),
            toggleArchive);
      } else {
        Utils.showAlertDialog(
            context,
            "${'unarchive'.resc()} `${projectModel.name}`?",
            "alert_unarch_content".resc(),
            toggleArchive);
      }
    } else if (action == "rename".resc()) {
      log("Rename");
      Utils.showInputAlertDialog(context, "rename_project".resc(),
          "alert_rename_proj_content".resc(), projectModel.name, (title) {
        log("project, rename col: $title");
        projectModel.name = title;
        Api.updateProject(projectModel).then((result) {
          if (result) {
            abActionListener.refreshUi();
          } else {
            Utils.showErrorSnackbar(context, "Could not rename project");
          }
        }).onError((e, st) => Utils.showErrorSnackbar(context, e));
      });
    } else if (action == "delete".resc()) {
      Utils.showAlertDialog(
          context,
          "${'delete'.resc()} `${projectModel.name}`?",
          "alert_del_content".resc(), () {
        log("Delete project");
        Api.removeProject(projectModel.id).then((result) {
          if (result) {
            abActionListener.refreshUi();
            Navigator.pop(context);
          } else {
            Utils.showErrorSnackbar(context, "Could not delete project");
          }
        }).onError((e, st) => Utils.showErrorSnackbar(context, e));
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
            log("Add new column");
            abActionListener.onMainAction?.call();
          },
          icon: const Icon(Icons.playlist_add),
          tooltip: "add_column".resc(),
        );
      case AppBarAction.kPopup:
        return PopupMenuButton<String>(
          onSelected: handlePopupAction,
          itemBuilder: (BuildContext context) {
            return {
              "rename".resc(),
              projectModel.isActive ? "archive".resc() : "unarchive".resc(),
              showArchived ? "hide_archived".resc() : "show_archived".resc(),
              // TODO: `show_archived` adds extra spaces in UI?
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
