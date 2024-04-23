import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/ui/add_task.dart';
import 'package:kanbored/ui/build_subtasks.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils.dart';

class BoardTasks extends ConsumerStatefulWidget {
  final ColumnModelData column;

  // final int baseIdx;

  const BoardTasks({super.key, required this.column});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoardTasksState();
}

class BoardTasksState extends ConsumerState<BoardTasks> {
  late ColumnModelData column;

  // late int baseIdx;

  @override
  void initState() {
    super.initState();
    column = widget.column;
    // baseIdx = baseIdx;
  }

  @override
  Widget build(BuildContext context) {
    var tasks = ref.watch(tasksInProject);
    log("build tasks");
    return tasks.when(
        data: (tasks) {
          log("tasks: ${tasks.length}");
          var showArchived = ref.read(UiState.boardShowArchived);
          // TODO: Use db instead!
          tasks = tasks.where((t) => t.columnId == column.id).toList();
          tasks = (showArchived
                  ? (column.hideInDashboard == 1
                      ? tasks
                      : tasks.where((t) => t.isActive == 0))
                  : tasks.where((t) => t.isActive == 1))
              .toList();
          // TODO: fix incorrect positioning (when remove a middle task, add new one, sometimes doesn't update position correctly)
          // moveTaskPosition or updateTask for all tasks?
          // tasks.sort((a, b) {
          //   // ascending
          //   if (a.position > b.position) {
          //     return 1;
          //   }
          //   return -1;
          // });
          log("filteredTasks: ${tasks.length}");
          // TODO: move add new task out of list of tasks? Separate widget?
          var tasksLength = (showArchived
              ? tasks.length
              : tasks.length + 1); // Add new task
          // log("tasks: $tasks");
          // for (var task in tasks) {
          //   var metadata = await Api.retrieveTaskMetadata(ref, task.id);
          //   log("metadata: $metadata");
          // }
          return ListView.builder(
              key: UniqueKey(),
              // TODO: perf: optimize!
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: tasksLength,
              itemBuilder: (context, index) {
                // log("isArch: ${abActionListener.isArchived()}; $index, ${tasks.length}");
                // return Utils.emptyUi();
                if (!showArchived && index == tasks.length) {
                  return SizedBox(
                      child: AddTask(
                          // key: keysEditableText[baseIdx + 1],
                          key: GlobalKey(),
                          columnModel: column));
                }
                return SizedBox(
                    child: buildBoardTask(tasks.elementAt(index), context));
              });
        },
        error: (e, s) {
          log("error: $e");
          // TODO: proper text label for error
          return const Text('error');
        },
        loading: () => const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ));
  }
}
