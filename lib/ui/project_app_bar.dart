import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils/utils.dart';

class ProjectAppBarActions extends AppBarActions {
  const ProjectAppBarActions({super.key});

  // final bool showArchived;
  //
  // const ProjectAppBarActions(
  //     {super.key, required this.showArchived});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ProjectAppBarActionsState();
}

class ProjectAppBarActionsState
    extends AppBarActionsState<ProjectAppBarActions> {
  // late bool showArchived;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   showArchived = ref.read(UiState.boardShowArchived);
  // }

  @override
  Iterable<String> getPopupNames() => {
        ref.read(UiState.projectShowArchived)
            ? "hide_archived".resc()
            : "show_archived".resc(),
        "settings".resc(),
      };

  @override
  void mainAction() {
    log("project main");
    // NOTE: this approach will not work for multiple boards/swimlane; instead, add to board's popup options
    Utils.showInputAlertDialog(
        context, "add_project".resc(), "alert_new_proj_content".resc(), "",
            (title) {
          log("project, add proj: $title");
          /*
          - Create project locally
          - Update local state
          - Call remote sync
            - if online, call task, sync with local for new changes
              OR
              always push into remote sync queue, when task exists, run it
            - if offline, save task with appropriate , sync when online
              - create proj, delete => remove any task w/ same id, to be synced
           */
              Api.instance.createProject(ref, title);
          // WebApi.createProject(title).then((result) {
          //   if (result is int) {
          //     // TODO: remove default columns? `getColumns` and `removeColumn`
          //     onArchived(false);
          //     refreshUi();
          //   } else {
          //     Utils.showErrorSnackbar(context, "Could not add project");
          //   }
          // }).onError((e, st) => Utils.showErrorSnackbar(context, e));
        });
  }

  @override
  void delete() {
    log("project, delete");
    // abActionListener.onDelete();
    ref.read(UiState.boardActiveState.notifier).state?.currentState?.delete();
  }

  @override
  Future<void> handlePopupAction(String action) async {
    log("project, handlePopupAction: $action");
    if (action == "hide_archived".resc() || action == "show_archived".resc()) {
      // showArchived = !showArchived;
      // log("toggle archive: $showArchived");
      // (abActionListener as ProjectActionListener).onArchived(showArchived);
      // TODO: project archive status
      ref.read(UiState.projectShowArchived.notifier).state =
          !ref.watch(UiState.projectShowArchived);
    } else if (action == "settings".resc()) {
      Navigator.pushNamed(context, routeSettings).then((value) {
        if (value is bool && value) {
          Navigator.pushNamed(context, routeLogin);
        }
      });
    }
  }

  @override
  Widget getButton(int action) {
    // log("project, getButton: $action");
    switch (action) {
      case AppBarAction.kMain:
        return IconButton(
          onPressed: mainAction,
          icon: const Icon(Icons.add),
          tooltip: "add_project".resc(),
        );
      default:
        return super.getButton(action);
    }
  }
}
