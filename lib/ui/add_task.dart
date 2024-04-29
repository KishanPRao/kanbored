import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils/utils.dart';

class AddTask extends ConsumerStatefulWidget {
  // final AppBarActionListener abActionListener;
  // TODO: avoid sending data?
  final ColumnModelData columnModel;

  const AddTask({super.key, required this.columnModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AddTaskState();
}

class AddTaskState extends EditableState<AddTask> {
  var focusNode = FocusNode();
  late ColumnModelData columnModel;

  // late AppBarActionListener abActionListener;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    columnModel = widget.columnModel;
    // abActionListener = widget.abActionListener;
    controller = TextEditingController(text: "");
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void startEditing() {
    log("startEditing");
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      color: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
          // splashColor: "primary".themed(context).withAlpha(30),
          onTap: () {
            log("onTAP");
            startEditing();
            focusNode.requestFocus();
            // setState(() {
            //   startEditing();
            //   focusNode.requestFocus();
            // });
          },
          child: SizedBox(
            height: Sizes.kAddTaskHeight,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(children: [
                  Expanded(
                      child: TextField(
                          onChanged: (value) => ref
                              .read(UiState.boardActiveText.notifier)
                              .state = controller.text,
                          controller: controller,
                          onTap: startEditing,
                          onEditingComplete: () {
                            ref.read(UiState.boardEditing.notifier).state =
                                false;
                            // abActionListener.onEditEnd(true);
                          },
                          // onChanged: abActionListener.onChange,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                              hintText: "add_task".resc(),
                              // border: InputBorder.none,
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w400)))),
                  // IconButton(
                  //     onPressed:
                  //         validText ? () => createTaskCb(taskName) : null,
                  //     icon: const Icon(Icons.check))
                ])),
          )),
    );
  }

  @override
  void endEdit(bool saveChanges) {
    log("add task, endEdit: $saveChanges");
    if (saveChanges) {
      log("Add a new task: ${controller.text}, into task: ${columnModel.title}");
      // final tasksDao = ref.read(AppDatabase.provider).taskDao;
      // tasksDao.addTask(taskJson);
      Api.instance.createTask(
        ref,
        columnModel.projectId,
        columnModel.id,
        controller.text,
      ).then((taskId) async {
        if (taskId is int) {
          controller.text = "";
          final taskDao = ref.read(AppDatabase.provider).taskDao;
          ref.read(activeTask.notifier).state = await taskDao.getTask(taskId);
          // TODO: await, bad idea?
          Navigator.pushNamed(context, routeTask);
        }
      }).onError((e, st) => Utils.showErrorSnackbar(context, e));
    } else {
      controller.text = "";
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
