import 'package:flutter/material.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/project_metadata_model.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/models/board_model.dart';
import 'package:kanbored/models/project_model.dart';
import 'package:kanbored/ui/board_column.dart';
import 'package:kanbored/utils.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<StatefulWidget> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  ProjectModel? _projectModel;
  final ScrollController _controller = ScrollController();
  ProjectMetadataModel? _projectMetadataModel;
  List<BoardModel> _boards = [];
  var showActive = true;
  var activeColumnPos = -1;
  var activeTaskId = -1;
  late double _columnWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _projectModel =
          ModalRoute.of(context)?.settings.arguments as ProjectModel;
      _columnWidth = Utils.getWidth(context) * Sizes.kTaskWidthPercentage;
      updateData();
    });
  }

  void updateData() async {
    var projectModel = _projectModel;
    if (projectModel != null) {
      var boards = await Api.getBoard(projectModel.id);
      var projectMetadataModel = await Api.getProjectMetadata(projectModel.id);
      for (var board in boards) {
        for (var column in board.columns) {
          if (projectMetadataModel.closedColumns.contains(column.id)) {
            column.isActive = false;
            break;
          }
        }
      }
      if (mounted) {
        setState(() {
          _boards = boards;
          _projectMetadataModel = projectMetadataModel;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_controller.hasClients && activeColumnPos != -1) {
        _controller.position
            .jumpTo(_columnWidth * activeColumnPos); // TODO: better approach
        activeColumnPos = -1;
        for (var board in _boards) {
          for (var column in board.columns) {
            for (var task in column.tasks) {
              if (task.id == activeTaskId) {
                Navigator.pushNamed(context, routeTask, arguments: task);
                break;
              }
            }
          }
        }
      }
    });
    var projectModel = _projectModel;
    return projectModel != null
        ? Scaffold(
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
                IconButton(
                  onPressed: () {
                    setState(() {
                      showActive = !showActive;
                    });
                  },
                  color: showActive ? Colors.grey : Colors.red, //TODO
                  icon: const Icon(Icons.archive),
                  tooltip: "tt_archived_col".resc(),
                )
              ],
            ),
            body: Column(
                children: _boards.map((board) {
              var columns =
                  (showActive ? board.activeColumns : board.inactiveColumns);
              return Expanded(
                  child: Column(
                children: [
                  // TODO: move each ui element into a function or class?
                  Card(
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        child: Center(child: Text(board.name)), // swimlane
                      )),
                  // TODO: Keep a setting to enable swimlane info; default disabled; give warning on possible limitations; or keep it simple, avoid using it.
                  Expanded(
                      child: ListView.builder(
                          key: ObjectKey(columns[0]),
                          // TODO: better approach
                          shrinkWrap: true,
                          controller: _controller,
                          scrollDirection: Axis.horizontal,
                          itemCount: columns.length,
                          itemBuilder: (context, index) => SizedBox(
                              width: _columnWidth,
                              child: BoardColumn(
                                  column: columns.elementAt(index),
                                  showActive: showActive,
                                  createTaskCb: (taskName) async {
                                    Api.createTask(
                                            projectModel.id,
                                            columns.elementAt(index).id,
                                            taskName)
                                        .then((value) {
                                      activeTaskId = value;
                                      activeColumnPos = index;
                                      updateData();
                                    });
                                  }))))
                ],
              ));
            }).toList()),
          )
        : const SizedBox.shrink();
  }
}
