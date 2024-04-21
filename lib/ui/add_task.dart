import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/sizes.dart';
import 'package:kanbored/utils.dart';

class AddTask extends ConsumerStatefulWidget {
  final AppBarActionListener abActionListener;
  final ColumnModel columnModel;

  const AddTask(
      {super.key, required this.columnModel, required this.abActionListener});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AddTaskState();
}

class AddTaskState extends EditableState<AddTask> {
  var focusNode = FocusNode();
  late ColumnModel columnModel;
  late AppBarActionListener abActionListener;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    columnModel = widget.columnModel;
    abActionListener = widget.abActionListener;
    controller = TextEditingController(text: "");
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void startEditing() {
    abActionListener.onChange(controller.text);
    abActionListener
        .onEditStart(1, [AppBarAction.kDiscard, AppBarAction.kDone]);
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
              startEditing();
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
                          onTap: startEditing,
                          onEditingComplete: () {
                            abActionListener.onEditEnd(true);
                          },
                          onChanged: abActionListener.onChange,
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
  void endEdit(bool saveChanges) async {
    log("endEdit: $saveChanges");
    if (saveChanges) {
      log("Add a new task: ${controller.text}, into task: ${columnModel.title}");
      WebApi.createTask(columnModel.projectId, columnModel.id, controller.text)
          .then((taskId) {
        controller.text = "";
        abActionListener.refreshUi();
        Navigator.pushNamed(context, routeTask,
            arguments: [taskId, columnModel.projectId]);
      }).onError((e, st) => Utils.showErrorSnackbar(context, e));
    } else {
      controller.text = "";
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
