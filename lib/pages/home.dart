import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/api_state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/models/project_model.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/project_app_bar.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils/app_connection.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/utils/utils.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  // List<ProjectModel> projects = [];
  // var showArchived = false;
  late AppConnection connection;

  void updateData({bool recurring = false}) async {
    Api.updateProjects(ref, recurring: recurring);
    // TODO
    // final event = await apiDao.getApiLatest();
    // if (event != null) {
    //   log("run latest api task: ${event.timestamp}, ${event.updateId}, ${event.webApiInfo}");
    // }
  }

  @override
  void initState() {
    super.initState();
    connection = AppConnection(ref.read(ApiState.onlineStatus.notifier));
    ref.read(ApiState.onlineStatus.notifier).stream.listen((online) {
      online = online ?? false;
      if (online) {
        updateData();
      }
    });
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
    // setState(() {
    //   this.showArchived = showArchived;
    // });
  }

  void refreshUi() {
    log("project, Refresh UI!");
    // init();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (didPop) =>
            ref.read(UiState.boardEditing.notifier).state = false,
        child: Scaffold(
            backgroundColor: "pageBg".themed(context),
            // floatingActionButton: buildSearchFab(context, () {
            //   log("home Search");
            // }),
            appBar: AppBar(
              title: Text("app_name".resc()),
              backgroundColor: "primary".themed(context),
              actions: [
                ProjectAppBarActions(
                  key: EditableState.createKey(),
                )
              ],
            ),
            body: RefreshIndicator(
                onRefresh: () {
                  refreshUi();
                  return Utils.emptyFuture();
                },
                child: Column(children: [
                  StreamBuilder(
                      stream: ref.read(ApiState.onlineStatus.notifier).stream,
                      builder: (context, snapshot2) {
                        final isOnline = snapshot2.data ?? false;
                        return isOnline
                            ? Utils.emptyUi()
                            : Card(
                                clipBehavior: Clip.hardEdge,
                                color: "offlineBg".themed(context),
                                child: SizedBox(
                                  child: Center(child: Text("offline".resc())),
                                ));
                      }),
                  StreamBuilder(
                      stream:
                          ref.read(UiState.projectShowArchived.notifier).stream,
                      builder: (context, snapshot2) {
                        final showArchived = snapshot2.data ?? false;
                        return showArchived
                            ? Card(
                                clipBehavior: Clip.hardEdge,
                                color: "archivedBg".themed(context),
                                child: SizedBox(
                                  child: Center(child: Text("archived".resc())),
                                ))
                            : Utils.emptyUi();
                      }),
                  buildProjectsStream()
                ]))));
  }

  StreamBuilder<List<ProjectModel>> buildProjectsStream() {
    log("buildProjectsStream");
    return StreamBuilder(
        stream: ref.read(ApiState.allProjects.notifier).stream,
        builder: (context, AsyncSnapshot<List<ProjectModel>> snapshot) {
          log("new projects: ${snapshot.data}!");
          return StreamBuilder(
            stream: ref.read(UiState.projectShowArchived.notifier).stream,
            builder: (context, snapshot2) {
              final showArchived = snapshot2.data ?? false;
              // TODO: if used outside 2nd stream builder, data not saved?
              var projects = snapshot.data ?? [];
              log("new projects: ${projects.length}, $showArchived");
              projects = projects
                  .where((project) =>
                      ((project.isActive == 0) && showArchived) ||
                      ((project.isActive == 1) && !showArchived))
                  .toList();
              // log("build, # projects ${projects.length}");
              return buildProjectsUi(projects);
            },
          );
        });
  }

  Widget buildProjectsUi(List<ProjectModel> projects) {
    return Expanded(
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: projects.length,
            itemBuilder: (BuildContext context, int index) {
              final project = projects[index];
              return Card(
                color: "projectBg".themed(context),
                // clipBehavior: Clip.hardEdge,
                clipBehavior: Clip.antiAlias,
                // semanticContainer: true,
                // shadowColor: Colors.red,
                shape: RoundedRectangleBorder(
                  // TODO: use percentage of width?
                  borderRadius: BorderRadius.circular(30.0),
                ),
                borderOnForeground: false,
                child: InkWell(
                    splashColor: "cardHighlight".themed(context),
                    highlightColor: "cardHighlight".themed(context),
                    onTap: () {
                      ref.read(UiState.projectShowArchived.notifier).state =
                          false;
                      ref.read(ApiState.activeProject.notifier).state = project;
                      Navigator.pushNamed(context, routeBoard).then((value) {
                        log("return to home");
                        ref.read(UiState.appBarActiveState.notifier).state =
                            widget.key as GlobalKey<EditableState>;
                      });
                    },
                    child: SizedBox(
                      child: Center(child: Text(project.name)),
                    )),
              );
            }));
  }

  @override
  void dispose() {
    connection.dispose();
    super.dispose();
  }
}
