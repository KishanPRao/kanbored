import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
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
  static const int intMaxValue = -1 >>> 1;

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
            // initially, dateCreation is null locally, put into top
            // TODO: alternative is to define own dateCreation, but changes on remote sync
            if ((a.dateCreation ?? intMaxValue) >
                (b.dateCreation ?? intMaxValue)) {
              return -1;
            } else {
              return 1;
            }
          }).map((comment) {
            // log("comment: $comment");
            return Markdown(
                key: EditableState.createKey(),
                content: comment.comment,
                onSaveCb: (text) async {
                  log("[comment] save text");
                  Api.instance.updateComment(
                    ref,
                    comment.copyWith(comment: text),
                  );
                });
          }).toList());
        });
  }

  @override
  Widget build(BuildContext context) => stream;
}
