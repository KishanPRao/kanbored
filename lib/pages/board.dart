import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/board_action_listener.dart';
import 'package:kanbored/ui/board_app_bar.dart';
import 'package:kanbored/ui/board_column.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/search_fab.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils.dart';

class Board extends ConsumerStatefulWidget {
  const Board({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BoardState();
}

class _BoardState extends ConsumerState<Board> {
  bool isLoaded = false;

  // late ProjectModelData projectModel;
  // late ProjectMetadataModel projectMetadataModel;
  // List<BoardModel> boards = [];
  // var showArchived = false;
  var activeColumnPos = -1;
  var activeTaskId = -1;
  late double columnWidth;
  var activeEditIndex = 0;
  var activeEditText = "";
  GlobalKey<BoardAppBarActionsState> keyAppBarActionsState = GlobalKey();
  List<GlobalKey<EditableState>> keysEditableText = [];
  final ScrollController controller = ScrollController();
  late Stream<List<ColumnModelData>> columns;
  final _formKey = GlobalKey<FormState>();
  late ColumnDao columnDao;
  late StreamBuilder<List<ColumnModelData>> columnsStream;
  late Stream<bool> showArchivedStream;

  @override
  void initState() {
    super.initState();
    var projectModel = ref.read(activeProject)!;
    Api.updateColumns(ref, projectModel.id, recurring: true);
    Api.updateTasks(ref, projectModel.id, recurring: true);
    columnDao = ref.read(AppDatabase.provider).columnDao;
    // columns = ref.watch(columnsInProject);
    // columnsStream = buildColumns(context, projectModel.id);
    // final showArchived = ref.watch(UiState.boardShowArchived.notifier).stream.distinct();
    // showArchivedStream = ref.read(UiState.boardShowArchived.notifier).stream;
    columnsStream = buildColumnsStream(projectModel.id);
  }

  @override
  void didChangeDependencies() {
    if (!isLoaded) {
      // var projectModel = ref.read(activeProject);
      // columns = ref.read(columnsInProject);
      // if (projectModel != null) {
      //   this.projectModel = projectModel;
      // }
      // ref.read(UiState.boardShowArchived.notifier).state = false;
      // projectModel =
      //     ModalRoute.of(context)?.settings.arguments as ProjectModelData;
      columnWidth = Utils.getWidth(context) * Sizes.kTaskWidthPercentage;
      updateData();
    }
    super.didChangeDependencies();
  }

  void updateData() async {
    // List<GlobalKey<EditableState>> keysEditableText = [];
    // var projectModel = ref.read(activeProject)!;
    // var boards = await WebApi.getBoard(projectModel.id);
    // var projectMetadataModel = await WebApi.getProjectMetadata(projectModel.id);
    // for (var board in boards) {
    //   for (var column in board.columns) {
    //     keysEditableText.add(GlobalKey()); // Column name
    //     keysEditableText.add(GlobalKey()); // `Add task`
    //     column.isActive =
    //         !projectMetadataModel.closedColumns.contains(column.id);
    //   }
    // }
    // if (mounted) {
    //   setState(() {
    //     // this.boards = boards;
    //     // this.projectMetadataModel = projectMetadataModel;
    //     this.keysEditableText = keysEditableText;
    //     isLoaded = true;
    //   });
    // }
  }

  void onChange(text) {
    activeEditText = text;
    // keyTaskAppBarActionsState.currentState?.updateText(text);
  }

  void onEditStart(int index, List<int> actions) {
    log("onEditStart: $index, $actions");
    activeEditIndex = index;
    keyAppBarActionsState.currentState?.currentActions = actions;
    keyAppBarActionsState.currentState?.startEdit();
    keysEditableText[activeEditIndex].currentState?.startEdit();
  }

  // TODO: needed?
  bool onEditEnd(bool saveChanges) {
    if (saveChanges && activeEditText.isEmpty) {
      return false;
    }
    // Utils.printStacktrace();
    log("board, onEditEnd: $activeEditIndex, $saveChanges");
    keysEditableText[activeEditIndex].currentState?.endEdit(saveChanges);
    keyAppBarActionsState.currentState?.endEdit(saveChanges);
    // setState(() {});
    return true;
  }

  bool isArchived() => ref.read(UiState.boardShowArchived);

  void onDelete() {
    log("board, onDelete");
    keysEditableText[activeEditIndex].currentState?.delete();
  }

  void onAddColumn() {
    log("board, onAddColumn");
    // NOTE: this approach will not work for multiple boards/swimlane; instead, add to board's popup options
    Utils.showInputAlertDialog(
        context, "add_column".resc(), "alert_new_col_content".resc(), "",
        (title) {
      log("board, add col: $title");
      var projectModel = ref.read(activeProject)!;
      WebApi.addColumn(projectModel.id, title).then((result) {
        if (result is int) {
          refreshUi();
        } else {
          Utils.showErrorSnackbar(context, "Could not add column");
        }
      }).onError((e, st) => Utils.showErrorSnackbar(context, e));
    });
  }

  void onArchive() {
    log("board, onArchive");
    keysEditableText[activeEditIndex].currentState?.archive();
  }

  void onUnarchive() {
    log("board, onUnarchive");
    keysEditableText[activeEditIndex].currentState?.unarchive();
  }

  void onArchived(bool showArchived) {
    log("board, onArchived: $showArchived");
    // setState(() {
    //   this.showArchived = showArchived;
    // });
    ref.read(UiState.boardShowArchived.notifier).state = showArchived;
    // UiState.boardShowArchivedStreamCtller.add(showArchived);
  }

  void refreshUi() {
    log("board, Refresh UI!");
    // TODO
    // Api.updateColumns(ref, projectModel.id);
    updateData();
  }

  final taskJson = """
  {"id":3,"title":"Task 3","description":"Test","date_creation":1713122401,"color_id":"yellow","project_id":1,"column_id":1,"owner_id":1,"position":1,"is_active":1,"date_completed":null,"score":null,"date_due":null,"category_id":0,"creator_id":1,"date_modification":1713262081,"reference":"","date_started":null,"time_spent":0,"time_estimated":0,"swimlane_id":1,"date_moved":1713122401,"recurrence_status":0,"recurrence_trigger":0,"recurrence_factor":0,"recurrence_timeframe":0,"recurrence_basedate":0,"recurrence_parent":null,"recurrence_child":null,"priority":0,"external_provider":null,"external_uri":null,"url":"https://board.futuregadget.org/task/1","color":{"name":"Yellow","background":"rgb(245, 247, 196)","border":"rgb(223, 227, 45)"}}""";

  @override
  Widget build(BuildContext context) {
    log("rebuild board");
    // Do not load until some data is retrieved
    // final dao = p.Provider.of<TasksDao>(context);
    // StateProvider<AppDatabase> provider = StateProvider((ref) {
    //   final database = ref.watch(AppDatabase.provider);
    //   database.tasksDao
    //   ref.onDispose(database.close);
    //   return database;
    // });
    // return Scaffold(
    //   appBar: AppBar(
    //       title: Text("proj"),
    //       backgroundColor: "primary".themed(context),
    //       leading: IconButton(
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //         icon: const Icon(Icons.arrow_back),
    //       )),
    //   body: Column(children: [buildTaskList(context), TextButton(onPressed: () {
    //     log("Add");
    //     final tasksDao = ref.read(AppDatabase.provider).tasksDao;
    //     tasksDao.addTask(taskJson);
    //   }, child: Text("ADD"))]),
    // );
    final projectModel = ref.watch(activeProject);
    final showArchived = ref.watch(UiState.boardShowArchived);
    // if (!isLoaded || projectModel == null) {
    if (projectModel == null) {
      return Utils.emptyUi();
    }
    // final columnsDao = ref.read(AppDatabase.provider).columnsDao;
    // final columns = ref.watch(columnsInProject);
    // columns.when(
    //     data: (columns) {
    //       // log("cols: $columns");
    //     },
    //     error: (e, s) {},
    //     loading: () {});
    return Scaffold(
        backgroundColor: "pageBg".themed(context),
        floatingActionButton: buildSearchFab(context, () {
          Navigator.pushNamed(context, routeSearch, arguments: [
            /*projectModel, boards*/
          ]).then((value) {
            // TODO: jump to active column
            // if (value is ColumnModel) {
            //   var showArchived = !value.isActive;
            //   var columns = (showArchived
            //       ? boards.first.inactiveColumns
            //       : boards.first.activeColumns);
            //   onArchived(showArchived);
            //   for (int i = 0; i < columns.length; i++) {
            //     var c = columns[i];
            //     if (c.title == value.title && c.position == value.position) {
            //       WidgetsBinding.instance.addPostFrameCallback((_) {
            //         // TODO: need more testing; after archive state fixed
            //         controller.jumpTo(columnWidth * i);
            //       });
            //       break;
            //     }
            //   }
            // }
          });
        }),
        appBar: AppBar(
          title: Text(projectModel.name),
          backgroundColor: "primary".themed(context),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            BoardAppBarActions(
              key: keyAppBarActionsState,
              abActionListener: BoardActionListener(
                onArchive: onArchive,
                onUnarchive: onUnarchive,
                onArchived: onArchived,
                onChange: onChange,
                onEditStart: (_, __) => {},
                onEditEnd: onEditEnd,
                onDelete: onDelete,
                onMainAction: onAddColumn,
                refreshUi: refreshUi,
                isArchived: isArchived,
              ),
            )
          ],
        ),
        // TODO: handle swimlane! Take only first board?
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
                        child: Center(child: Text("archived_col".resc())),
                      ))
                  : Utils.emptyUi(),
              columnsStream
            ])
            // columns.when(
            //     data: (columns) {
            //       log("cols: ${columns.length}");
            //       return Column(
            //         children: [
            //           showArchived
            //               ? Card(
            //                   clipBehavior: Clip.hardEdge,
            //                   color: "archivedBg".themed(context),
            //                   child: SizedBox(
            //                     child:
            //                         Center(child: Text("archived_col".resc())),
            //                   ))
            //               : Utils.emptyUi(),
            //           // TODO: move each ui element into a function or class?
            //           // TODO: Keep a setting to enable swimlane info; default disabled; give warning on possible limitations; or keep it simple, avoid using it.
            //           Expanded(
            //               child: ListView(
            //             // TODO: perf: better approach; everything causes refresh
            //             shrinkWrap: true,
            //             controller: controller,
            //             scrollDirection: Axis.horizontal,
            //             children: columns.mapIndexed((entry) {
            //               var index = entry.key;
            //               var column = entry.value;
            //               // log("col map: ${column.title}");
            //               return SizedBox(
            //                   width: columnWidth,
            //                   child: BoardColumn(
            //                     key: ObjectKey(column),
            //                     column: column,
            //                     // projectMetadataModel: projectMetadataModel,
            //                     keysEditableText: keysEditableText,
            //                     baseIdx: (index * 2),
            //                     abActionListener: BoardActionListener(
            //                       onChange: onChange,
            //                       onEditStart: (idx, actions) =>
            //                           onEditStart((index * 2) + idx!, actions),
            //                       onEditEnd: onEditEnd,
            //                       onDelete: onDelete,
            //                       isArchived: isArchived,
            //                       onMainAction: null,
            //                       refreshUi: refreshUi,
            //                       onArchive: () {},
            //                       onUnarchive: () {},
            //                       onArchived: (_) {},
            //                     ),
            //                   ));
            //             }).toList(),
            //           ))
            //         ],
            //       );
            //     },
            //     error: (e, s) {
            //       log("error: $e");
            //       // TODO: proper text label for error
            //       return const Text('error');
            //     },
            //     loading: () => const Center(
            //           child: CircularProgressIndicator(strokeWidth: 2),
            //         ))
            //     boards.map((board) {
            //   var columns =
            //       (showArchived ? board.inactiveColumns : board.activeColumns);
            //   // for (var c in columns) {
            //   //   log("Column: ${c.id}, ${c.isActive}, ${c.title}");
            //   // };
            // }).toList())),
            ));
  }

  StreamBuilder<List<ColumnModelData>> buildColumnsStream(int projectId) {
    return StreamBuilder(
        // TODO: distinct matters?
        stream: columnDao.watchColumnsInProject(projectId).distinct(),
        builder: (context, AsyncSnapshot<List<ColumnModelData>> snapshot) {
          return StreamBuilder(
            stream: ref.watch(UiState.boardShowArchived.notifier).stream,
            builder: (context, snapshot2) {
              final showArchived = snapshot2.data ?? false;
              log("col, showArchived: $showArchived");
              var columns = snapshot.data ?? [];
              columns = columns
                  .where((c) =>
                      (showArchived && c.hideInDashboard == 1) ||
                      (!showArchived && c.hideInDashboard == 0))
                  .toList();
              log("new columns: ${columns.length}");
              return Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: columns.length,
                itemBuilder: (_, index) {
                  final column = columns[index];
                  log("column: ${column.title}, ${column.id}");
                  // return Text(column.title);
                  return SizedBox(
                      key: ObjectKey(column.id),
                      width: columnWidth,
                      child: BoardColumn(
                        // key: ObjectKey(column),
                        column: column,
                      ));
                },
              ));
            },
          );
        });
  }
}
