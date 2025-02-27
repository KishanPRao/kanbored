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

class BoardSubtask extends ConsumerStatefulWidget {
  static const kStatusTodo = 0;
  static const kStatusInProgress = 1;
  static const kStatusFinished = 2;

  final SubtaskModelData subtask;

  const BoardSubtask({super.key, required this.subtask});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BoardSubtaskState();
}

class BoardSubtaskState extends EditableState<BoardSubtask> {
  var focusNode = FocusNode();
  late SubtaskModelData subtask;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    subtask = widget.subtask;
    controller = TextEditingController(text: subtask.title);
    // TODO: stop reloading subtasks non-stop
    // log("subtask name: ${subtask.title}");
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void startEditing() {
    log("add task: startEditing");
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
    return Row(children: [
      Checkbox(
        checkColor: Colors.white, // TODO: themed color!
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return "primary".themed(context);
          }
          return Colors.transparent;
        }),
        value: subtask.status == BoardSubtask.kStatusFinished,
        onChanged: (value) {
          // log("Changed value: $value");
          var updated = subtask.copyWith(
              status: value!
                  ? BoardSubtask.kStatusFinished
                  : BoardSubtask.kStatusTodo);
          Api.instance.updateSubtask(ref, updated);
          setState(() {});
        },
      ),
      Expanded(
          child: TextField(
              controller: controller,
              maxLines: null,
              textInputAction: TextInputAction.done,
              onTap: () {
                log("onTap");
                startEditing();
              },
              style: subtask.status == BoardSubtask.kStatusFinished
                  ? const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontStyle: FontStyle.italic)
                  : null,
              onSubmitted: (value) {
                log("submitted");
                endEdit(true);
              },
              onChanged: (value) {
                log("onchange");
                ref.read(UiState.boardActiveText.notifier).state = value;
              },
              decoration: const InputDecoration(border: InputBorder.none)))
    ]);
  }

  @override
  void endEdit(bool saveChanges) {
    log("[subtask], endEdit: $saveChanges");
    if (saveChanges) {
      log("[subtask] update: ${controller.text}");
      var updated = subtask.copyWith(title: controller.text);
      Api.instance.updateSubtask(ref, updated);
    } else {
      controller.text = subtask.title;
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
