import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/ui_state.dart';

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
        ref.read(UiState.boardShowArchived)
            ? "hide_archived".resc()
            : "show_archived".resc(),
        "settings".resc(),
      };

  @override
  void mainAction() {
    log("project main");
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
      ref.read(UiState.boardShowArchived.notifier).state =
          !ref.watch(UiState.boardShowArchived);
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
