import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/models/project_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/project_action_listener.dart';
import 'package:kanbored/ui/project_app_bar.dart';
import 'package:kanbored/utils.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  List<ProjectModel> projects = [];
  var showArchived = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // Api.watchProjects().;
  }

  void onChange(text) {
    // activeEditText = text;
    // keyTaskAppBarActionsState.currentState?.updateText(text);
  }

  void onEditStart(int index, List<int> actions) {
    log("onEditStart: $index, $actions");
    // activeEditIndex = index;
    // keyAppBarActionsState.currentState?.currentActions = actions;
    // keyAppBarActionsState.currentState?.startEdit();
    // keysEditableText[activeEditIndex].currentState?.startEdit();
  }

  // TODO: needed?
  bool onEditEnd(bool saveChanges) {
    // if (saveChanges && activeEditText.isEmpty) {
    //   return false;
    // }
    // // Utils.printStacktrace();
    // log("project, onEditEnd: $activeEditIndex, $saveChanges");
    // keysEditableText[activeEditIndex].currentState?.endEdit(saveChanges);
    // keyAppBarActionsState.currentState?.endEdit(saveChanges);
    // setState(() {});
    return true;
  }

  void onDelete() {
    log("project, onDelete");
    // keysEditableText[activeEditIndex].currentState?.delete();
  }

  void onAddProject() {
    log("project, onAddProject");
    // NOTE: this approach will not work for multiple boards/swimlane; instead, add to board's popup options
    Utils.showInputAlertDialog(
        context, "add_project".resc(), "alert_new_proj_content".resc(), "",
        (title) {
      log("project, add col: $title");
      WebApi.createProject(title).then((result) {
        if (result is int) {
          // TODO: remove default columns? `getColumns` and `removeColumn`
          refreshUi();
        } else {
          Utils.showErrorSnackbar(context, "Could not add project");
        }
      }).onError((e, st) => Utils.showErrorSnackbar(context, e));
    });
  }

  void onArchived(showArchived) {
    log("project, onArchived: $showArchived");
    setState(() {
      this.showArchived = showArchived;
    });
  }

  void refreshUi() {
    log("project, Refresh UI!");
    init();
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(currentProjects);
    // var projects = this
    //     .projects
    //     .where((project) => project.isActive != showArchived)
    //     .toList();
    // projects.sort((a, b) => a.name.compareTo(b.name));
    // log("Projects: $projects; orig: ${this.projects}");
    return Scaffold(
      backgroundColor: "pageBg".themed(context),
      // floatingActionButton: buildSearchFab(context, () {
      //   log("home Search");
      // }),
      appBar: AppBar(
        title: Text("app_name".resc()),
        backgroundColor: "primary".themed(context),
        actions: [
          ProjectAppBarActions(
            // key: keyAppBarActionsState,
            showArchived: showArchived,
            abActionListener: ProjectActionListener(
              onArchived: onArchived,
              onChange: onChange,
              onEditStart: (_, __) => {},
              onEditEnd: onEditEnd,
              onDelete: onDelete,
              onMainAction: onAddProject,
              refreshUi: refreshUi,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
          // trigger the _loadData function when the user pulls down
          onRefresh: () {
            refreshUi();
            return Utils.emptyFuture();
          },
          child: Column(children: [
            showArchived
                ? Card(
                    clipBehavior: Clip.hardEdge,
                    color: "archivedBg".themed(context),
                    child: SizedBox(
                      child: Center(child: Text("archived".resc())),
                    ))
                : Utils.emptyUi(),
            Expanded(
                child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: projects.when(data: (projects) {
                return projects
                    .map((project) => Card(
                          color: "projectBg".themed(context),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                              splashColor: "cardHighlight".themed(context),
                              highlightColor: "cardHighlight".themed(context),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  routeBoard,
                                  arguments: project,
                                );
                              },
                              child: SizedBox(
                                child: Center(child: Text(project.name)),
                              )),
                        ))
                    .toList();
              }, error: (e, s) {
                return [Utils.emptyUi()];
              }, loading: () {
                return [Utils.emptyUi()];
              }),
            ))
          ])),
    );
  }
}
