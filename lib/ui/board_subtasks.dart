import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/db/converters.dart';
import 'package:kanbored/db/dao/subtask_dao.dart';
import 'package:kanbored/db/dao/task_metadata_dao.dart';
import 'package:kanbored/ui/board_add_subtask.dart';
import 'package:kanbored/ui/board_subtask.dart';
import 'package:kanbored/ui/checklist_header.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/add_task.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/ui/ui_state.dart';

class BoardSubtasks extends ConsumerStatefulWidget {
  final TaskModelData task;

  const BoardSubtasks({super.key, required this.task});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoardSubtasksState();
}

class BoardSubtasksState extends ConsumerState<BoardSubtasks> {
  late TaskModelData task;
  final keyAddTask = EditableState.createKey(); //TODO
  late StreamBuilder<List<SubtaskModelData>> stream;
  late SubtaskDao subtaskDao;
  late TaskMetadataDao taskMetadataDao;

  // late int baseIdx;

  @override
  void initState() {
    super.initState();
    // column = widget.column;
    task = ref.read(activeTask.notifier).state!;
    subtaskDao = ref.read(AppDatabase.provider).subtaskDao;
    taskMetadataDao = ref.read(AppDatabase.provider).taskMetadataDao;
    stream = buildSubtasksStream();
    log("init board tasks");
  }

  // StreamBuilder<List<Subtask>> buildSubtasksStream() {
  //   return StreamBuilder(
  //       stream: dao.watch(),
  //       builder: (context, AsyncSnapshot<List<Subtask>> snapshot) {
  //         return Text("data");
  //       });
  // }
  //
  StreamBuilder<List<SubtaskModelData>> buildSubtasksStream() {
    return StreamBuilder(
        // TODO: distinct matters?
        stream: subtaskDao.watchSubtasksInTask(task.id).distinct(),
        builder: (context, AsyncSnapshot<List<SubtaskModelData>> snapshot) {
          return StreamBuilder(
              stream: taskMetadataDao.watchTaskMetadataForTask(task.id),
              builder: (context, snapshot1) {
                // TODO: scenarios! Create new metadata etc
                var taskMetadata = snapshot1.data ??
                    TaskMetadataModelData(
                        taskId: task.id, metadata: TaskMetadata([]));
                var subtasks = snapshot.data ?? [];
                log("subtasks: ${subtasks.length}");
                // subtasks = subtasks.where((t) => t.taskId == task.id).toList();
                var checklistSubtaskCount =
                    (taskMetadata.metadata.checklists.length * 2) +
                        subtasks.length;
                log("Checklist + subtask count: $checklistSubtaskCount");
                log("Checklist len: ${taskMetadata.metadata.checklists.length} subtask len: ${subtasks.length}");
                return Column(
                    children: taskMetadata.metadata.checklists.map((checklist) {
                  log("checklist: $checklist");
                  return Column(
                      children: <Widget>[
                            ChecklistHeader(
                              checklist: checklist,
                            )
                          ] +
                          checklist.items.map(
                            (item) {
                              var subtask = subtasks.singleWhere(
                                  (element) => element.id == item.id);
                              return BoardSubtask(subtask: subtask);
                            },
                          ).toList() +
                          [
                            BoardAddSubtask(
                              task: task,
                              taskMetadata: taskMetadata,
                              checklist: checklist,
                            )
                          ]);
                }).toList());
              });
          // log("new subtasks: ${subtasks.length}");
          // return Expanded(flex: 0, child: Column(children: [Text("data")],));
          // return Column(children: [Text("data")],);
          // return Expanded(child: Text("data"));
          // return ListView.builder(
          //           shrinkWrap: true,
          //           itemCount: subtasks.length,
          //           itemBuilder: (_, index) {
          //             final subtask = subtasks[index];
          //             // log("task: ${task.title}, ${task.id}");
          //             return buildBoardSubtask(subtasks.elementAt(index), context);
          //             // return Text(subtask.title);
          //           },
          //         );
          // return Text("data");
          // return SizedBox(height: 100, child: Expanded(child: Text("data"),));
          // return Column(children: [Text("data")],);
          // return SizedBox(height: 200, child: Column(children: [Text("data")],));
          // return Column(children: [SizedBox(height: 200, child: Text("data"))],);
          // return Column( // Wrap Expanded with Column or Row
          //   children: [
          //     Expanded(
          //       child: Text("data"), // Expanded now has a proper Flex parent
          //     ),
          //   ],
          // );
          // return Column(
          //   mainAxisSize: MainAxisSize.min, // Prevent infinite height
          //   children: [
          //     Flexible( // Use Flexible to avoid infinite constraint issues
          //       child: Text("data"),
          //     ),
          //   ],
          // );

          // return Expanded(child:
          // Text("data")
          // Column(children: [
          //     Expanded(
          //         child: ListView.builder(
          //       shrinkWrap: true,
          //       itemCount: subtasks.length,
          //       itemBuilder: (_, index) {
          //         final task = subtasks[index];
          //         // log("task: ${task.title}, ${task.id}");
          //         return buildBoardSubtask(subtasks.elementAt(index), context);
          //       },
          //     )),
          //     // AddTask(key: keyAddTask, columnModel: column)
          //   ]
          // ),
          // );
        });
  }

  Widget buildBoardSubtask(SubtaskModelData subtask, BuildContext context) {
    // log("Board task: ${task.title} at ${task.position}");
    return Text(subtask.title);
    // return Card(
    //     key: ObjectKey(subtask.id),
    //     margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
    //     clipBehavior: Clip.hardEdge,
    //     color: "taskBg".themed(context),
    //     child: InkWell(
    //         splashColor: "cardHighlight".themed(context),
    //         highlightColor: "cardHighlight".themed(context),
    //         onTap: () {
    //           // ref.read(activeTask.notifier).state = subtask;
    //           // Navigator.pushNamed(context, routeTask);
    //         },
    //         child: Padding(
    //           padding: const EdgeInsets.all(10.0),
    //           child: SizedBox(
    //               height: Sizes.kTaskHeight,
    //               child: Center(
    //                   child: Text(
    //                 subtask.title,
    //                 textAlign: TextAlign.center, // horizontal
    //               ))),
    //         )));
  }

  @override
  // Widget build(BuildContext context) => Column(children: [Expanded(child: stream)],);
  // Widget build(BuildContext context) => Column(
  //       children: [Flexible(fit: FlexFit.loose, child: stream)],
  //     );
  Widget build(BuildContext context) => stream;
// Widget build(BuildContext context) => Text("test");
}
