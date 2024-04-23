import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/board_action_listener.dart';
import 'package:kanbored/ui/board_tasks.dart';
import 'package:kanbored/ui/column_text.dart';
import 'package:kanbored/ui/editing_state.dart';

class BoardColumn extends ConsumerStatefulWidget {
  final ColumnModelData column;
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
  // late List<TaskModel> tasks;
  late ColumnModelData column;
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
    log("load task in col: ${column.id}");
    // var tasks = ref.watch(tasksInColumn(column.id));
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
              BoardTasks(column: column)
              // tasks.when(
              //     data: (tasks) {
              //       log("tasks: ${tasks.length}");
              //       var filteredTasks = (abActionListener.isArchived()
              //           ? (column.hideInDashboard == 1
              //               ? tasks
              //               : tasks.where((t) => t.isActive == 0))
              //           : tasks.where((t) => t.isActive == 1));
              //       // TODO: fix incorrect positioning (when remove a middle task, add new one, sometimes doesn't update position correctly)
              //       // moveTaskPosition or updateTask for all tasks?
              //       // tasks.sort((a, b) {
              //       //   // ascending
              //       //   if (a.position > b.position) {
              //       //     return 1;
              //       //   }
              //       //   return -1;
              //       // });
              //       log("filteredTasks: ${filteredTasks.length}");
              //       // TODO: move add new task out of list of tasks? Separate widget?
              //       var tasksLength = (abActionListener.isArchived()
              //           ? filteredTasks.length
              //           : filteredTasks.length + 1); // Add new task
              //       // log("tasks: $tasks");
              //       // for (var task in tasks) {
              //       //   var metadata = await Api.retrieveTaskMetadata(ref, task.id);
              //       //   log("metadata: $metadata");
              //       // }
              //       return ListView.builder(
              //           key: UniqueKey(),
              //           // TODO: perf: optimize!
              //           shrinkWrap: true,
              //           scrollDirection: Axis.vertical,
              //           itemCount: tasksLength,
              //           itemBuilder: (context, index) {
              //             // log("isArch: ${abActionListener.isArchived()}; $index, ${tasks.length}");
              //             // return Utils.emptyUi();
              //             if (!abActionListener.isArchived() &&
              //                 index == tasks.length) {
              //               return SizedBox(
              //                   child: AddTask(
              //                       key: keysEditableText[baseIdx + 1],
              //                       columnModel: column,
              //                       abActionListener: abActionListener));
              //             }
              //             return SizedBox(
              //                 child: buildBoardTask(
              //                     tasks.elementAt(index), context));
              //           });
              //     },
              //     error: (e, s) {
              //       log("error: $e");
              //       // TODO: proper text label for error
              //       return const Text('error');
              //     },
              //     loading: () => const Center(
              //           child: CircularProgressIndicator(strokeWidth: 2),
              //         ))
            ])));
  }
}
