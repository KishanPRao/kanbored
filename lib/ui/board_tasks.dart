import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/add_task.dart';
import 'package:kanbored/ui/build_subtasks.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';
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
  final keyAddTask = EditableState.createKey();
  late TaskDao tasksDao;
  late StreamBuilder<List<TaskModelData>> tasksStream;

  // late int baseIdx;

  @override
  void initState() {
    super.initState();
    column = widget.column;
    tasksDao = ref.read(AppDatabase.provider).taskDao;
    // baseIdx = baseIdx;

    tasksStream = buildTasksStream();
  }

  StreamBuilder<List<TaskModelData>> buildTasksStream() {
    return StreamBuilder(
      // TODO: distinct matters?
        stream: tasksDao.watchTasksInColumn(column.id).distinct(),
        builder: (context, AsyncSnapshot<List<TaskModelData>> snapshot) {
          return StreamBuilder(
            stream: ref.watch(UiState.boardShowArchived.notifier).stream,
            builder: (context, snapshot2) {
              final showArchived = snapshot2.data ?? false;
              log("tasks, showArchived: $showArchived");
              var tasks = snapshot.data ?? [];
              tasks = tasks.where((t) => t.columnId == column.id).toList();
              tasks = (showArchived
                  ? (column.hideInDashboard == 1
                  ? tasks
                  : tasks.where((t) => t.isActive == 0))
                  : tasks.where((t) => t.isActive == 1))
                  .toList();
              log("new tasks: ${tasks.length}");
              return Expanded(
                child: Column(children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (_, index) {
                      final task = tasks[index];
                      log("task: ${task.title}, ${task.id}");
                      return buildBoardTask(tasks.elementAt(index), context);
                    },
                  ),
                  if (!showArchived) AddTask(key: keyAddTask, columnModel: column)
                ]),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return tasksStream;
    // final tasks = ref.watch(tasksInProject);
    // log("build tasks");
    // return tasks.when(
    //     data: (tasks) {
    //       log("tasks: ${tasks.length}");
    //       var showArchived = ref.read(UiState.boardShowArchived);
    //       // TODO: Use db instead!
    //       tasks = tasks.where((t) => t.columnId == column.id).toList();
    //       tasks = (showArchived
    //               ? (column.hideInDashboard == 1
    //                   ? tasks
    //                   : tasks.where((t) => t.isActive == 0))
    //               : tasks.where((t) => t.isActive == 1))
    //           .toList();
    //       // TODO: fix incorrect positioning (when remove a middle task, add new one, sometimes doesn't update position correctly)
    //       // moveTaskPosition or updateTask for all tasks?
    //       // tasks.sort((a, b) {
    //       //   // ascending
    //       //   if (a.position > b.position) {
    //       //     return 1;
    //       //   }
    //       //   return -1;
    //       // });
    //       log("filteredTasks: ${tasks.length}");
    //       // TODO: move add new task out of list of tasks? Separate widget?
    //       var tasksLength = (showArchived
    //           ? tasks.length
    //           : tasks.length + 1); // Add new task
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
    //             if (!showArchived && index == tasks.length) {
    //               return SizedBox(
    //                   child: AddTask(
    //                       // key: keysEditableText[baseIdx + 1],
    //                       key: EditableState.createKey(),
    //                       columnModel: column));
    //             }
    //             return SizedBox(
    //                 child: buildBoardTask(tasks.elementAt(index), context));
    //           });
    //     },
    //     error: (e, s) {
    //       log("error: $e");
    //       // TODO: proper text label for error
    //       return const Text('error');
    //     },
    //     loading: () => const Center(
    //           child: CircularProgressIndicator(strokeWidth: 2),
    //         ));
  }

  Widget buildBoardTask(TaskModelData task, BuildContext context) {
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
              Navigator.pushNamed(context, routeTask, arguments: task);
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
}
