import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/ui/board_tasks.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/project_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/add_task.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/ui/board_action_listener.dart';
import 'package:kanbored/ui/build_subtasks.dart';
import 'package:kanbored/ui/column_text.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/utils/utils.dart';

class BoardColumn extends StatefulWidget {
  final ColumnModel column;

  const BoardColumn(
      {super.key,
      required this.column,});

  @override
  State<StatefulWidget> createState() => BoardColumnState();
}

class BoardColumnState extends State<BoardColumn> {
  late ColumnModel column;
  final keyColumnText = EditableState.createKey();

  @override
  void initState() {
    super.initState();
    column = widget.column;
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
    // return Text(column.title);
    return Card(
        key: ObjectKey(column),
        color: "columnBg".themed(context),
        margin: const EdgeInsets.all(10),
        clipBehavior: Clip.hardEdge,
        child: Padding(
          // key: ObjectKey(column),
            padding: const EdgeInsets.all(8.0),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ColumnText(
                key: keyColumnText,
                // TODO: Likely `key` makes deciding refresh required
                // key: keysEditableText[baseIdx],
                columnModel: column,
                // abActionListener: abActionListener
              ),
              BoardTasks(
                  column: column)
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
