import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/db/dao/api_storage_dao.dart';
import 'package:kanbored/db/dao/task_dao.dart';
import 'package:kanbored/db/database.dart';
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
  // var showArchived = false;
  late TaskDao taskDao;
  late ApiStorageDao apiDao;
  late AppConnection connection;
  Timer? timer;

  final jsonData = {
    "jsonrpc": "2.0",
    "method": "createProject",
    "id": 1797076613,
    "params": {"name": "New project", "owner_id": 1}
  };

  void runApiTask(ApiStorageModelData event) async {
    apiDao.getTasks();
    bool status = await WebApi.handleApiRequest(ref, event);
    log("runApiTask: $status");
  }

  void updateData({bool recurring = false}) async {
    var timer = Api.instance.updateProjects(ref, recurring: recurring);
    if (recurring) {
      this.timer = timer;
    }
    final event = await apiDao.getApiLatest();
    if (event != null) {
      log("run latest api task: ${event.timestamp}, ${event.updateId}, ${event.apiName}, ${event.apiType}");
      runApiTask(event);
    } else {
      log("no latest api");
    }
  }

  @override
  void initState() {
    super.initState();
    taskDao = ref.read(AppDatabase.provider).taskDao;
    apiDao = ref.read(AppDatabase.provider).apiStorageDao;
    connection = AppConnection(ref.read(onlineStatus.notifier));
    ref.read(onlineStatus.notifier).stream.listen((online) {
      online = online ?? false;
      if (online) {
        updateData();
      }
    });
    // TODO: Check works on offline
    updateData(recurring: true);

    // Api.recurringApi(() async {
    //   var task = await taskDao.getTask(1);
    //   log("Re-runnning from home! ${task.title}; ${ref.context.mounted}");
    // }, seconds: 12);
    apiDao.watchApiTasks().listen((event) {
      log("remaining tasks len: ${event.length}");
    });
    var isOffline = false;
    // final random = math.Random();
    // apiDao.watchApiLatest().
    apiDao.watchApiLatest().listen((event) {
      final online = ref.read(onlineStatus) ?? false;
      if (event == null || !online) {
        log("wait api task: ${event?.timestamp}, ${event?.updateId}, ${event?.apiName}, ${event?.apiType}");
        return;
      }
      log("run watched api task: ${event.timestamp}, ${event.updateId}, ${event.apiName}, ${event.apiType}; ${event.webApiParams}");
      runApiTask(event);
      // log("==> running task: ${event.timestamp}");
      // int next(int min, int max) => min + random.nextInt(max - min);
      // sleep(Duration(seconds:next(7, 12)));
      // Future.value(42).then((value) {
      //   // var a = 20;
      //   // for (int i = 0; i < 99999 * 11111; i++) {
      //   //   a += 20;
      //   // }
      //   // log("==> finished task: ${event.timestamp}; $a");
      //   if (!isOffline) {
      //     apiDao.removeApiTask(event.id);
      //   } else {
      //     log("offline");
      //   }
      // });
    });
    // Timer? timer;
    // var count = 0;
    // timer = Api.recurringApi(() async {
    //   const webApi = WebApiModel.createProject;
    //   // Api.createProject(ref, "New project");
    //   apiDao.addApiTask(webApi, jsonData);
    //   count++;
    //   if (count > 15) {
    //     timer?.cancel();
    //   }
    // }, seconds: 1);
    // Api.recurringApi(() {
    //   isOffline = !isOffline;
    // }, seconds: 20);
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
    // Utils.showInputAlertDialog(
    //     context, "add_project".resc(), "alert_new_proj_content".resc(), "",
    //     (title) {
    //   log("project, add col: $title");
    //   WebApi.createProject(title).then((result) {
    //     if (result is int) {
    //       // TODO: remove default columns? `getColumns` and `removeColumn`
    //       onArchived(false);
    //       refreshUi();
    //     } else {
    //       Utils.showErrorSnackbar(context, "Could not add project");
    //     }
    //   }).onError((e, st) => Utils.showErrorSnackbar(context, e));
    // });
  }

  void onArchived(showArchived) {
    log("project, onArchived: $showArchived");
    // setState(() {
    //   this.showArchived = showArchived;
    // });
  }

  void refreshUi() {
    log("project, Refresh UI!");
    Api.instance.updateProjects(ref);
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
              actions: const [ProjectAppBarActions()],
            ),
            body: RefreshIndicator(
                onRefresh: () {
                  refreshUi();
                  return Utils.emptyFuture();
                },
                child: Column(children: [
                  StreamBuilder(
                      stream: ref.watch(onlineStatus.notifier).stream,
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
                      stream: ref
                          .watch(UiState.projectShowArchived.notifier)
                          .stream,
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

  StreamBuilder<List<ProjectModelData>> buildProjectsStream() {
    log("buildProjectsStream");
    return StreamBuilder(
        stream: ref.read(AppDatabase.provider).projectDao.watchProjects(),
        builder: (context, AsyncSnapshot<List<ProjectModelData>> snapshot) {
          log("new projects: ${snapshot.data?.length}!");
          return StreamBuilder(
            stream: ref.watch(UiState.projectShowArchived.notifier).stream,
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

  Widget buildProjectsUi(List<ProjectModelData> projects) {
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
                      ref.read(activeProject.notifier).state = project;
                      Navigator.pushNamed(context, routeBoard);
                    },
                    child: SizedBox(
                      child: Center(child: Text(project.name)),
                    )),
              );
            }));
  }

  @override
  void dispose() {
    log("home dispose");
    timer?.cancel();
    connection.dispose();
    super.dispose();
  }
}
