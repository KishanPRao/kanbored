import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/add_task.dart';
import 'package:kanbored/ui/board_action_listener.dart';
import 'package:kanbored/ui/build_subtasks.dart';
import 'package:kanbored/ui/column_text.dart';
import 'package:kanbored/ui/editing_state.dart';

class BoardColumn extends ConsumerStatefulWidget {
  final ColumnModel column;
  final List<GlobalKey<EditableState>> keysEditableText;
  final int baseIdx;
  final BoardActionListener abActionListener;

  const BoardColumn(
      {super.key,
      required this.column,
      required this.keysEditableText,
      required this.baseIdx,
      required this.abActionListener});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoardColumnState();
}

class BoardColumnState extends ConsumerState<BoardColumn> {
  late List<TaskModel> tasks;
  late ColumnModel column;
  late List<GlobalKey<EditableState>> keysEditableText;
  late int baseIdx;
  late BoardActionListener abActionListener;

  @override
  void initState() {
    super.initState();
    abActionListener = widget.abActionListener;
    keysEditableText = widget.keysEditableText;
    baseIdx = widget.baseIdx;
    column = widget.column;
  }

  @override
  void didChangeDependencies() {
    tasks = (abActionListener.isArchived()
        ? (column.isActive ? column.inactiveTasks : column.tasks)
        : column.activeTasks);
    // TODO: fix incorrect positioning (when remove a middle task, add new one, sometimes doesn't update position correctly)
    // moveTaskPosition or updateTask for all tasks?
    tasks.sort((a, b) {
      // ascending
      if (a.position > b.position) {
        return 1;
      }
      return -1;
    });
    // log("Board column: ${column.id}, ${column.title}, ${column.isActive}, ${projectMetadataModel.closedColumns}");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // var columns = ref.watch(columnsInProject);
    // columns.when(
    //     data: (columns) {
    //       log("cols: $columns");
    //     },
    //     error: (e, s) {},
    //     loading: () {});
    var tasksLength = (abActionListener.isArchived()
        ? tasks.length
        : tasks.length + 1); // Add new task
    // log("Board column, build: ${column.title}, ${column.isActive}; archived: ${abActionListener.isArchived()}, $baseIdx");
    return Card(
        color: "columnBg".themed(context),
        margin: const EdgeInsets.all(10),
        clipBehavior: Clip.hardEdge,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ColumnText(
                  // TODO: Likely `key` makes deciding refresh required
                  key: keysEditableText[baseIdx],
                  columnModel: column,
                  abActionListener: abActionListener),
              Expanded(
                  child: ListView.builder(
                      key: UniqueKey(),
                      // TODO: perf: optimize!
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: tasksLength,
                      itemBuilder: (context, index) {
                        // log("isArch: ${abActionListener.isArchived()}; $index, ${tasks.length}");
                        if (!abActionListener.isArchived() &&
                            index == tasks.length) {
                          return SizedBox(
                              child: AddTask(
                                  key: keysEditableText[baseIdx + 1],
                                  columnModel: column,
                                  abActionListener: abActionListener));
                        }
                        return SizedBox(
                            child: buildBoardTask(
                                tasks.elementAt(index), context));
                      }))
            ])));
  }
}
