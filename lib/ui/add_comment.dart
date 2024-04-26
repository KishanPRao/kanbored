import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/ui/task_app_bar.dart';
import 'package:kanbored/utils/utils.dart';

class AddComment extends ConsumerStatefulWidget {
  final TaskModel task;
  final AppBarActionListener abActionListener;

  const AddComment({
    super.key,
    required this.task,
    required this.abActionListener,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AddCommentState();
}

class AddCommentState extends EditableState<AddComment> {
  late TaskModel task;
  late TextEditingController controller;
  late AppBarActionListener abActionListener;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: "");
    abActionListener = widget.abActionListener;
    task = widget.task;
  }

  @override
  void endEdit(bool saveChanges) async {
    if (saveChanges) {
      log("Add a new comment: ${controller.text}, into task: ${task.title}");
      WebApi.createComment(task.id, controller.text).then((result) {
        if (result is int) {
          abActionListener.refreshUi();
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
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
        child: TextField(
            controller: controller,
            onTap: () {
              abActionListener.onChange(controller.text);
              abActionListener.onEditStart(
                  null, [AppBarAction.kDiscard, AppBarAction.kDone]);
            },
            onEditingComplete: () {
              abActionListener.onEditEnd(true);
            },
            onChanged: abActionListener.onChange,
            decoration: InputDecoration(
                hintText: "add_comment".resc(),
                border: InputBorder.none,
                hintStyle: const TextStyle(fontWeight: FontWeight.w400))));
  }
}
