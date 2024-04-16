import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/task_action_listener.dart';
import 'package:kanbored/ui/task_app_bar.dart';
import 'package:kanbored/utils.dart';

class AddComment extends StatefulWidget {
  final TaskModel task;
  final TaskActionListener taskActionListener;

  const AddComment({
    super.key,
    required this.task,
    required this.taskActionListener,
  });

  @override
  State<StatefulWidget> createState() => AddCommentState();
}

class AddCommentState extends EditableState<AddComment> {
  late TaskModel task;
  late TextEditingController controller;
  late TaskActionListener taskActionListener;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: "");
    taskActionListener = widget.taskActionListener;
    task = widget.task;
  }

  @override
  void endEdit(bool saveChanges) async {
    if (saveChanges) {
      log("Add a new comment: ${controller.text}, into task: ${task.title}");
      Api.createComment(task.id, controller.text).then((result) {
        if (result is int) {
          taskActionListener.refreshUi();
        } else {
          Utils.showErrorSnackbar(context, "Could not add a comment");
        }
      }).onError((e, _) {
        Utils.showErrorSnackbar(context, e);
      });
    } else {
      controller.text = "";
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void delete() {
    log("add comment: delete");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
        child: TextField(
            controller: controller,
            onTap: () {
              taskActionListener.onChange(controller.text);
              taskActionListener.onEditStart(
                  null, [TaskAppBarAction.kDiscard, TaskAppBarAction.kDone]);
            },
            onEditingComplete: () {
              taskActionListener.onEditEnd(true);
            },
            onChanged: taskActionListener.onChange,
            decoration: InputDecoration(
                hintText: "add_comment".resc(),
                border: InputBorder.none,
                hintStyle: const TextStyle(fontWeight: FontWeight.w300))));
  }
}
