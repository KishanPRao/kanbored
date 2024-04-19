import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/project_metadata_model.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/ui/board_action_listener.dart';
import 'package:kanbored/ui/board_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/models/board_model.dart';
import 'package:kanbored/models/project_model.dart';
import 'package:kanbored/ui/board_column.dart';
import 'package:kanbored/ui/task_app_bar.dart';
import 'package:kanbored/utils.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<StatefulWidget> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  bool isLoaded = false;
  late ProjectModel projectModel;
  late ProjectMetadataModel projectMetadataModel;
  List<BoardModel> boards = [];
  var showArchived = false;
  var activeColumnPos = -1;
  var activeTaskId = -1;
  late double columnWidth;
  var activeEditIndex = 0;
  var activeEditText = "";
  GlobalKey<BoardAppBarActionsState> keyAppBarActionsState = GlobalKey();
  List<GlobalKey<EditableState>> keysEditableText = [];
  final ScrollController controller = ScrollController();

  @override
  void didChangeDependencies() {
    if (!isLoaded) {
      projectModel = ModalRoute.of(context)?.settings.arguments as ProjectModel;
      columnWidth = Utils.getWidth(context) * Sizes.kTaskWidthPercentage;
      updateData();
    }
    super.didChangeDependencies();
  }

  void updateData() async {
    var projectModel = this.projectModel;
    var boards = await Api.getBoard(projectModel.id);
    var projectMetadataModel = await Api.getProjectMetadata(projectModel.id);
    for (var board in boards) {
      for (var column in board.columns) {
        keysEditableText.add(GlobalKey()); // Column name
        keysEditableText.add(GlobalKey()); // `Add task`
        if (projectMetadataModel.closedColumns.contains(column.id)) {
          column.isActive = false;
          break;
        }
      }
    }
    if (mounted) {
      setState(() {
        this.boards = boards;
        this.projectMetadataModel = projectMetadataModel;
        isLoaded = true;
      });
    }
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

  void onDelete() {
    log("board, onDelete");
    keysEditableText[activeEditIndex].currentState?.delete();
  }

  void onSearch() {}

  void onArchive() {
    log("board, onArchive");
    keysEditableText[activeEditIndex].currentState?.archive();
  }

  void onUnarchive() {
    log("board, onUnarchive");
    keysEditableText[activeEditIndex].currentState?.unarchive();
  }

  void onArchived() {
    log("board, onArchived");
    setState(() {
      showArchived = !showArchived;
    });
  }

  void refreshUi() {
    log("board, Refresh UI!");
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    // Do not load until some data is retrieved
    if (!isLoaded) {
      return Utils.emptyUi();
    }
    return Scaffold(
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
          // IconButton(
          //   onPressed: null,
          //   icon: const Icon(Icons.search),
          //   tooltip: "tt_search".resc(),
          // ),
          // IconButton(
          //   onPressed: () {
          //     setState(() {
          //       showActive = !showActive;
          //     });
          //   },
          //   color: showActive ? Colors.grey : Colors.red, //TODO
          //   icon: const Icon(Icons.archive),
          //   tooltip: "tt_archived_col".resc(),
          // ),
          BoardAppBarActions(
            key: keyAppBarActionsState,
            projectModel: projectModel,
            abActionListener: BoardActionListener(
              onArchive: onArchive,
              onUnarchive: onUnarchive,
              onArchived: onArchived,
              onChange: onChange,
              onEditStart: (_, __) => {},
              onEditEnd: onEditEnd,
              onDelete: onDelete,
              onMainAction: onSearch,
              refreshUi: refreshUi,
            ),
          )
        ],
      ),
      // TODO: handle swimlane! Take only first board?
      body: Column(
          children: boards.map((board) {
        var columns =
            (showArchived ? board.inactiveColumns : board.activeColumns);
        log("columns: ${columns.length}");
        return Expanded(
            child: Column(
          children: [
            showArchived
                ? Card(
                    clipBehavior: Clip.hardEdge,
                    color: "archivedBgColor".themed(context),
                    child: SizedBox(
                      child: Center(child: Text("archived".resc())),
                    ))
                : Utils.emptyUi(),
            // TODO: move each ui element into a function or class?
            // TODO: Keep a setting to enable swimlane info; default disabled; give warning on possible limitations; or keep it simple, avoid using it.
            Expanded(
                child: ListView.builder(
                    key: ObjectKey(showArchived),
                    // TODO: better approach
                    shrinkWrap: true,
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    itemCount: columns.length,
                    itemBuilder: (context, index) => SizedBox(
                        width: columnWidth,
                        child: BoardColumn(
                          column: columns.elementAt(index),
                          showArchived: showArchived,
                          keysEditableText: keysEditableText,
                          baseIdx: (index * 2),
                          abActionListener: AppBarActionListener(
                            onChange: onChange,
                            onEditStart: (idx, actions) =>
                                onEditStart((index * 2) + idx!, actions),
                            onEditEnd: onEditEnd,
                            onDelete: onDelete,
                            onMainAction: onSearch,
                            refreshUi: refreshUi,
                          ),
                        ))))
          ],
        ));
      }).toList()),
    );
  }
}
