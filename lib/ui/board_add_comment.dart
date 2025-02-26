import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/db/converters.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils/utils.dart';

class BoardAddComment extends ConsumerStatefulWidget {
  final TaskModelData task;

  const BoardAddComment({super.key, required this.task});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoardAddCommentState();
}

class BoardAddCommentState extends EditableState<BoardAddComment> {
  var focusNode = FocusNode();
  late TaskModelData task;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    task = widget.task;
    controller = TextEditingController(text: "");
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void startEditing() {
    log("add comment: startEditing");
    ref.read(UiState.boardActiveState.notifier).state =
        widget.key as GlobalKey<EditableState>;
    ref.read(UiState.boardActiveText.notifier).state = controller.text;
    ref.read(UiState.boardActions.notifier).state = [
      AppBarAction.kDiscard,
      AppBarAction.kDone
    ];
    ref.read(UiState.boardEditing.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
        child: TextField(
            controller: controller,
            onTap: () {
              log("ontap");
            },
            onSubmitted: (value) {
              log("onsubmitted");
            },
            onChanged: (value) {
              log("onchanged");
            },
            decoration: InputDecoration(
                hintText: "add_comment".resc(),
                border: InputBorder.none,
                hintStyle: const TextStyle(fontWeight: FontWeight.w400))));
  }

  @override
  void endEdit(bool saveChanges) {
    log("add subtask, endEdit: $saveChanges");
    if (saveChanges) {
      log("Add a new comment: ${controller.text}, into task: ${task.title}");
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
