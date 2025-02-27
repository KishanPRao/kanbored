import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/db/converters.dart';
import 'package:kanbored/db/dao/comment_dao.dart';
import 'package:kanbored/db/dao/subtask_dao.dart';
import 'package:kanbored/db/dao/task_metadata_dao.dart';
import 'package:kanbored/ui/board_add_subtask.dart';
import 'package:kanbored/ui/board_subtask.dart';
import 'package:kanbored/ui/checklist_header.dart';
import 'package:kanbored/ui/markdown.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/add_task.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/ui/ui_state.dart';

class BoardComments extends ConsumerStatefulWidget {
  final TaskModelData task;

  const BoardComments({super.key, required this.task});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoardCommentsState();
}

class BoardCommentsState extends ConsumerState<BoardComments> {
  late TaskModelData task;
  final keyAddTask = EditableState.createKey(); //TODO
  late StreamBuilder<List<CommentModelData>> stream;
  late CommentDao commentDao;

  // late int baseIdx;

  @override
  void initState() {
    super.initState();
    // column = widget.column;
    task = ref.read(activeTask.notifier).state!;
    commentDao = ref.read(AppDatabase.provider).commentDao;
    stream = buildSubtasksStream();
    // log("init board comments");
  }

  // StreamBuilder<List<Subtask>> buildSubtasksStream() {
  //   return StreamBuilder(
  //       stream: dao.watch(),
  //       builder: (context, AsyncSnapshot<List<Subtask>> snapshot) {
  //         return Text("data");
  //       });
  // }
  //
  StreamBuilder<List<CommentModelData>> buildSubtasksStream() {
    return StreamBuilder(
        // TODO: distinct matters?
        stream: commentDao.watchCommentsInTask(task.id).distinct(),
        builder: (context, AsyncSnapshot<List<CommentModelData>> snapshot) {
          // TODO: scenarios! Create new metadata etc
          var comments = snapshot.data ?? [];
          // comments = comments.where((t) => t.taskId == task.id).toList();
          // log("comments len: ${comments.length}");
          return Column(
              children: comments.sorted((a, b) {
            if (a.dateCreation! > b.dateCreation!) {
              return -1;
            } else {
              return 1;
            }
          }).map((comment) {
            log("comment: $comment");
            return Markdown(
                content: comment.comment,
                onSaveCb: (text) {
                  log("save mkdown desc");
                });
          }).toList());
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
