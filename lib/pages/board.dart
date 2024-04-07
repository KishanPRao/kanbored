import 'dart:developer';

import 'package:flutter/material.dart';
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
  late ProjectModel _projectModel;
  final ScrollController _controller = ScrollController();
  ProjectMetadataModel? _projectMetadataModel;
  List<BoardModel> _boards = [];
  var showActive = true;

  var activeColumnPos = 0;
  late double _columnWidth;

  @override
  void didChangeDependencies() {
    _projectModel = ModalRoute.of(context)?.settings.arguments as ProjectModel;
    _columnWidth = Utils.getWidth(context) * Sizes.kTaskWidthPercentage;
    updateData();
    // _controller.position.jumpTo(_columnWidth * activeColumnPos);
    super.didChangeDependencies();
  }

  void updateData() async {
    var boards = await Api.getBoard(_projectModel.id);
    var projectMetadataModel = await Api.getProjectMetadata(_projectModel.id);
    for (var board in boards) {
      for (var column in board.columns) {
        if (projectMetadataModel.closedColumns.contains(column.id)) {
          column.isActive = false;
          break;
        }
      }
    }
    setState(() {
      _boards = boards;
      _projectMetadataModel = projectMetadataModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_projectModel.name),
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
                    shrinkWrap: true,
                    // controller: _controller,
                    scrollDirection: Axis.horizontal,
                    key: ObjectKey(columns[0]),
                    itemCount: columns.length,
                    itemBuilder: (context, index) => SizedBox(
                        width: _columnWidth,
                        child: BoardColumn(
                            column: columns.elementAt(index),
                            showActive: showActive,
                            createTaskCb: (taskName) async {
                              await Api.createTask(_projectModel.id,
                                  columns.elementAt(index).id, taskName);
                              // activeColumnPos = index;
                              // _controller.position.jumpTo(_columnWidth * index);
                              // _controller.position.forcePixels(_columnWidth * index);
                              // _controller.position.animateTo(
                              //     _columnWidth * index,
                              //     duration: const Duration(seconds: 2),
                              //     curve: Curves.bounceIn);
                              updateData();
                            }))))
          ],
        ));
      }).toList()),
    );
  }
}
