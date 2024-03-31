import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/ui/app_theme.dart';
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
  late ProjectModel projectModel;
  List<BoardModel> boards = [];

  @override
  void didChangeDependencies() {
    projectModel = ModalRoute.of(context)?.settings.arguments as ProjectModel;
    init();
    super.didChangeDependencies();
  }

  void init() async {
    var boards = await Api.getBoard(projectModel.id);
    setState(() {
      this.boards = boards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(projectModel.name),
        backgroundColor: context.theme.appColors.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
          children: boards
              .map((board) => Expanded(
                      child: Column(
                    children: [
                      // TODO: move each ui element into a function or class?
                      Card(
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            child: Center(child: Text(board.name)), // swimlane
                          )),
                      // TODO: Keep a setting to enable swimlane info; default disabled; give warning on possible limitations
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => SizedBox(
                                  width: Utils.getWidth(context) * 0.7,
                                  child: buildBoardColumn(
                                      board.columns.elementAt(index),
                                      context))))
                    ],
                  )))
              .toList()),
    );
  }
}
