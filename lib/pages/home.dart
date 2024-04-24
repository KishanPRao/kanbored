import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/project_action_listener.dart';
import 'package:kanbored/ui/project_app_bar.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  var showArchived = false;

  @override
  void initState() {
    super.initState();
    Api.updateProjects(ref, recurring: true);
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
          onArchived(false);
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
    Api.updateProjects(ref);
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(allProjects);
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
              // showArchived: showArchived,
              // abActionListener: ProjectActionListener(
              //   onArchived: onArchived,
              //   onChange: onChange,
              //   onEditStart: (_, __) => {},
              //   onEditEnd: onEditEnd,
              //   onDelete: onDelete,
              //   onMainAction: onAddProject,
              //   refreshUi: refreshUi,
              // ),
            )
          ],
        ),
        body: RefreshIndicator(
          // trigger the _loadData function when the user pulls down
          onRefresh: () {
            refreshUi();
            return Utils.emptyFuture();
          },
          child: projects.when(
              data: (projects) => Column(children: [
                    showArchived
                        ? Card(
                            clipBehavior: Clip.hardEdge,
                            color: "archivedBg".themed(context),
                            child: SizedBox(
                              child: Center(child: Text("archived".resc())),
                            ))
                        : Utils.emptyUi(),
                    buildProjects(projects),
                  ]),
              error: (e, s) {
                log("error: $e");
                // TODO: proper text label for error
                return const Text('error');
              },
              loading: () => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )),
        ));
  }

  Widget buildProjects(List<ProjectModelData> projects) {
    projects = projects
        .where((project) =>
            ((project.isActive == 0) && showArchived) ||
            ((project.isActive == 1) && !showArchived))
        .toList();
    // log("build, # projects ${projects.length}");
    return Expanded(
        child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: projects
                .map((project) => Card(
                      color: "projectBg".themed(context),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                          splashColor: "cardHighlight".themed(context),
                          highlightColor: "cardHighlight".themed(context),
                          onTap: () {
                            ref.read(UiState.boardShowArchived.notifier).state =
                                false;
                            ref.read(activeProject.notifier).state = project;
                            Navigator.pushNamed(context, routeBoard);
                          },
                          child: SizedBox(
                            child: Center(child: Text(project.name)),
                          )),
                    ))
                .toList()));
  }
}
