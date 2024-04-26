import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/api_state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/utils/utils.dart';

class AddTask extends ConsumerStatefulWidget {
  final ColumnModel columnModel;

  const AddTask({super.key, required this.columnModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AddTaskState();
}

class AddTaskState extends EditableState<AddTask> {
  var focusNode = FocusNode();
  late ColumnModel columnModel;

  @override
  void initState() {
    super.initState();
    columnModel = widget.columnModel;
    editActions = [
      AppBarAction.kDiscard,
      AppBarAction.kDone
    ];
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
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
            setState(() {
              startEdit();
              focusNode.requestFocus();
            });
          },
          child: SizedBox(
            height: Sizes.kAddTaskHeight,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(children: [
                  Expanded(
                      child: TextField(
                          controller: controller,
                          onTap: startEdit,
                          onEditingComplete: () => endEdit(true),
                          onChanged: (value) => ref
                              .read(UiState.boardActiveText.notifier)
                              .state = controller.text,
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
  Future<bool> endEdit(bool saveChanges) async {
    log("endEdit: $saveChanges");
    if (await super.endEdit(saveChanges)) {
      log("Add a new task: ${controller.text}, into task: ${columnModel.title}");
      WebApi.createTask(columnModel.projectId, columnModel.id, controller.text)
          .then((taskId) {
        controller.text = "";
        // abActionListener.refreshUi();
        WebApi.getTask(taskId, columnModel.projectId).then((taskModel) {
          Api.updateTasks(ref, columnModel.projectId);
          // ref.read(ApiState.activeTask.notifier).state = taskModel;
          // Navigator.pushNamed(context, routeTask);
        });
      }).onError((e, st) => Utils.showErrorSnackbar(context, e));
    } else {
      controller.text = "";
    }
    FocusManager.instance.primaryFocus?.unfocus();
    return true;
  }
}
