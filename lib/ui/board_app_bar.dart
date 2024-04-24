import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils.dart';

class BoardAppBarAction extends AppBarAction {
  static const kArchive = 5;
  static const kUnarchive = 6;
}

class BoardAppBarActions extends AppBarActions {
  const BoardAppBarActions({super.key});

  // final ProjectModelData projectModel;
  // final bool showArchived;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      BoardAppBarActionsState();
}

class BoardAppBarActionsState extends AppBarActionsState<BoardAppBarActions> {
  late ProjectModelData projectModel;
  // late bool showArchived;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   // projectModel = widget.projectModel;
  //   projectModel = ref.read(activeProject)!;
  //   showArchived = ref.read(UiState.boardShowArchived);
  // }

  @override
  Iterable<String> getPopupNames() => {
        "rename".resc(),
    ref.watch(UiState.boardShowArchived) ? "hide_archived".resc() : "show_archived".resc(),
        (projectModel.isActive == 1) ? "archive".resc() : "unarchive".resc(),
        // TODO: `show_archived` adds extra spaces in UI?
        "delete".resc(),
      };

  @override
  void delete() {
    log("board, delete");
    ref.read(UiState.boardActiveState.notifier).state?.currentState?.delete();
    // abActionListener.onDelete();
  }

  @override
  void archive() {
    log("board, archive");
    // (abActionListener as BoardActionListener).onArchive();
    ref.read(UiState.boardActiveState.notifier).state?.currentState?.archive();
  }

  @override
  void unarchive() {
    // (abActionListener as BoardActionListener).onUnarchive();
    ref
        .read(UiState.boardActiveState.notifier)
        .state
        ?.currentState
        ?.unarchive();
  }

  @override
  void mainAction() {
    log("board, onAddColumn");
    // NOTE: this approach will not work for multiple boards/swimlane; instead, add to board's popup options
    // Utils.showInputAlertDialog(
    //     context, "add_column".resc(), "alert_new_col_content".resc(), "",
    //         (title) {
    //       log("board, add col: $title");
    //       var projectModel = ref.read(activeProject)!;
    //       WebApi.addColumn(projectModel.id, title).then((result) {
    //         if (result is int) {
    //           refreshUi();
    //         } else {
    //           Utils.showErrorSnackbar(context, "Could not add column");
    //         }
    //       }).onError((e, st) => Utils.showErrorSnackbar(context, e));
    //     });
  }

  void toggleArchive() {
    // projectModel.isActive = !projectModel.isActive;
    var updatedProject =
        projectModel.copyWith(isActive: 1 - projectModel.isActive);
    // Update local state, then use different API
    Api.updateProject(ref, updatedProject, webUpdate: false);
    (updatedProject.isActive == 1
            ? WebApi.enableProject(projectModel.id)
            : WebApi.disableProject(projectModel.id))
        .then((value) {
      if (!value) {
        Utils.showErrorSnackbar(context, "Could not update project");
      } else {
        // TODO: bug: Does not refresh archived list
        // abActionListener.refreshUi();
        log("Updated project??");
      }
    }).catchError((e) => Utils.showErrorSnackbar(context, e));
  }

  // Project level
  @override
  Future<void> handlePopupAction(String action) async {
    log("board, handlePopupAction: $action");
    if (action == "hide_archived".resc() || action == "show_archived".resc()) {
      log("flip archived: ${ref.watch(UiState.boardShowArchived)}");
      // showArchived = !showArchived;
      // (abActionListener as BoardActionListener).onArchived(showArchived);
      ref.read(UiState.boardShowArchived.notifier).state =
          !ref.watch(UiState.boardShowArchived);
    } else if (action == "archive".resc() || action == "unarchive".resc()) {
      log("Archive/Unarchive");
      if (projectModel.isActive == 1) {
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
        var updatedProject = projectModel.copyWith(name: title);
        Api.updateProject(ref, updatedProject).then((result) {
          if (result) {
            // abActionListener.refreshUi();
            log("refresh rename??");
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
        Api.removeProject(ref, projectModel.id).then((result) {
          if (result) {
            log("refresh remove??");
            // abActionListener.refreshUi();
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
          onPressed: () => mainAction(),
          icon: const Icon(Icons.playlist_add),
          tooltip: "add_column".resc(),
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
          color: "unarchiveBg".themed(context), //TODO
          icon: const Icon(Icons.unarchive),
          tooltip: "unarchive".resc(),
        );
      default:
        return super.getButton(action);
    }
  }

  @override
  Widget build(BuildContext context) {
    var projectModel = ref.watch(activeProject);
    if (projectModel != null) {
      this.projectModel = projectModel;
    }
    // showArchived = ref.read(UiState.boardShowArchived);
    return super.build(context);
  }
}
