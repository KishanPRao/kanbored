import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/utils/utils.dart';

class ProjectAppBarActions extends AppBarActions {
  const ProjectAppBarActions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ProjectAppBarActionsState();
}

class ProjectAppBarActionsState
    extends AppBarActionsState<ProjectAppBarActions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Iterable<String> getPopupNames() => {
        ref.read(UiState.projectShowArchived)
            ? "hide_archived".resc()
            : "show_archived".resc(),
        "settings".resc(),
      };

  @override
  void delete() {
    log("project, delete");
    // abActionListener.onDelete();
  }

  @override
  void mainAction() {
    log("project main");
    // NOTE: this approach will not work for multiple boards/swimlane; instead, add to board's popup options
    Utils.showInputAlertDialog(
        context, "add_project".resc(), "alert_new_proj_content".resc(), "",
        (title) {
      log("project, add proj: $title");
      WebApi.createProject(title).then((result) {
        if (result is int) {
          // TODO: remove default columns? `getColumns` and `removeColumn`
          // onArchived(false);
          // refreshUi();
          ref.read(UiState.projectShowArchived.notifier).state = false;
        } else {
          Utils.showErrorSnackbar(context, "Could not add project");
        }
      }).onError((e, st) => Utils.showErrorSnackbar(context, e));
    });
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
