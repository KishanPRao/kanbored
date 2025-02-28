import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/ui/ui_builder.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/add_task.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/ui/ui_state.dart';

class BoardTasks extends ConsumerStatefulWidget {
  final ColumnModelData column;

  const BoardTasks({super.key, required this.column});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoardTasksState();
}

class BoardTasksState extends ConsumerState<BoardTasks> {
  late ColumnModelData column;
  final keyAddTask = EditableState.createKey();
  late StreamBuilder<List<TaskModelData>> tasksStream;

  // late int baseIdx;

  @override
  void initState() {
    super.initState();
    column = widget.column;
    tasksStream = buildTasksStream();
    // log("init board tasks");
  }

  StreamBuilder<List<TaskModelData>> buildTasksStream() {
    final taskDao = ref.read(AppDatabase.provider).taskDao;
    return StreamBuilder(
        // TODO: distinct matters?
        stream: taskDao.watchTasksInColumn(column.id).distinct(),
        builder: (context, AsyncSnapshot<List<TaskModelData>> snapshot) {
          // NOTE: assume rebuilt by column on change of archive, just read
          final showArchived = ref.read(UiState.boardShowArchived);
          var tasks = snapshot.data ?? [];
          // log("tasks, showArchived: $showArchived; ${tasks.length}");
          tasks = tasks.where((t) => t.columnId == column.id).toList();
          tasks = (showArchived
                  ? (column.hideInDashboard == 1
                      ? tasks
                      : tasks.where((t) => t.isActive == 0))
                  : tasks.where((t) => t.isActive == 1))
              .toList();
          // log("new tasks: ${tasks.length}");
          return Expanded(
            child: Column(children: [
              Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (_, index) {
                  final task = tasks[index];
                  // log("task: ${task.title}, ${task.id}");
                  return UiBuilder.buildBoardTask(ref, task, context);
                },
              )),
              if (!showArchived) AddTask(key: keyAddTask, columnModel: column)
            ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) => tasksStream;
}
