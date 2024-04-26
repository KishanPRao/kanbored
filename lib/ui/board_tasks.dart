import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api_state.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/ui/add_task.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/utils/utils.dart';

class BoardTasks extends ConsumerStatefulWidget {
  final ColumnModel column;

  const BoardTasks({super.key, required this.column});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoardTasksState();
}

class BoardTasksState extends ConsumerState<BoardTasks> {
  late ColumnModel column;
  final keyAddTask = EditableState.createKey();
  late StreamBuilder<List<TaskModel>> tasksStream;

  // late int baseIdx;

  @override
  void initState() {
    super.initState();
    column = widget.column;
    tasksStream = buildTasksStream();
    log("init board tasks");
  }

  StreamBuilder<List<TaskModel>> buildTasksStream() {
    return StreamBuilder(
        // TODO: distinct matters?
        stream: ref
            .read(ApiState.tasksInActiveProject.notifier)
            .stream
            .map(
                (tasks) => tasks.where((t) => t.columnId == column.id).toList())
            .distinct(),
        builder: (context, AsyncSnapshot<List<TaskModel>> snapshot) {
          log("new tasks, is null: ${snapshot.data == null}; ${column.id}");
          // NOTE: assume rebuilt by column on change of archive, just read
          final showArchived = ref.read(UiState.boardShowArchived);
          var tasks = snapshot.data ?? [];
          log("tasks, showArchived: $showArchived; ${tasks.length}");
          // tasks = tasks.where((t) => t.columnId == column.id).toList();
          tasks = (showArchived
                  ? (!column.isActive
                      ? tasks
                      : tasks.where((t) => t.isActive == 0))
                  : tasks.where((t) => t.isActive == 1))
              .toList();
          log("new tasks: ${tasks.length} under ${column.title}");
          return Expanded(
            child: Column(children: [
              Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (_, index) {
                  final task = tasks[index];
                  // log("task: ${task.title}, ${task.id}");
                  return buildBoardTask(task, context);
                },
              )),
              if (!showArchived) AddTask(key: keyAddTask, columnModel: column)
            ]),
          );
        });
  }

  Widget buildBoardTask(TaskModel task, BuildContext context) {
    // log("Board task: ${task.title} at ${task.position}");
    return Card(
        key: ObjectKey(task.id),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
        clipBehavior: Clip.hardEdge,
        color: "taskBg".themed(context),
        child: InkWell(
            splashColor: "cardHighlight".themed(context),
            highlightColor: "cardHighlight".themed(context),
            onTap: () {
              ref.read(ApiState.activeTask.notifier).state = task;
              Navigator.pushNamed(context, routeTask);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                  height: Sizes.kTaskHeight,
                  child: Center(
                      child: Text(
                    task.title,
                    textAlign: TextAlign.center, // horizontal
                  ))),
            )));
  }

  @override
  Widget build(BuildContext context) => tasksStream;
}
