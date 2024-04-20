import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/models/project_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/board_action_listener.dart';
import 'package:kanbored/ui/project_action_listener.dart';
import 'package:kanbored/utils.dart';

class ProjectAppBarActions extends AppBarActions {
  final bool showArchived;

  const ProjectAppBarActions(
      {super.key, required this.showArchived, required super.abActionListener});

  @override
  State<StatefulWidget> createState() => ProjectAppBarActionsState();
}

class ProjectAppBarActionsState
    extends AppBarActionsState<ProjectAppBarActions> {
  late bool showArchived;

  @override
  void initState() {
    super.initState();
    showArchived = widget.showArchived;
  }

  @override
  Iterable<String> getPopupNames() => {
    showArchived ? "hide_archived".resc() : "show_archived".resc(),
    "settings".resc(),
  };

  @override
  void delete() {
    log("project, delete");
    abActionListener.onDelete();
  }

  @override
  Future<void> handlePopupAction(String action) async {
    log("project, handlePopupAction: $action");
    if (action == "hide_archived".resc() || action == "show_archived".resc()) {
      showArchived = !showArchived;
      log("toggle archive: $showArchived");
      (abActionListener as ProjectActionListener).onArchived(showArchived);
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
          onPressed: () {
            log("Add new project");
            abActionListener.onMainAction?.call();
          },
          icon: const Icon(Icons.add),
          tooltip: "add_project".resc(),
        );
      default:
        return super.getButton(action);
    }
  }
}
