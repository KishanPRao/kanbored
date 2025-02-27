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

class ChecklistHeader extends ConsumerStatefulWidget {
  final ChecklistMetadata checklist;
  final TaskMetadataModelData taskMetadata;

  const ChecklistHeader({super.key, required this.taskMetadata, required this.checklist});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ChecklistHeaderState();
}

class ChecklistHeaderState extends EditableState<ChecklistHeader> {
  var focusNode = FocusNode();
  late ChecklistMetadata checklist;
  late TaskMetadataModelData taskMetadata;

  // late AppBarActionListener abActionListener;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    checklist = widget.checklist;
    taskMetadata = widget.taskMetadata;
    // columnModel = widget.columnModel;
    // abActionListener = widget.abActionListener;
    controller = TextEditingController(text: widget.checklist.title);
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
    return TextField(
      controller: controller,
      onTap: () {
        log("onTAP");
        startEditing();
        focusNode.requestFocus();
      },
      onChanged: (value) =>
          ref.read(UiState.boardActiveText.notifier).state = controller.text,
      // onEditingComplete: () => abActionListener.onEditEnd(true),
      onSubmitted: (value) {
        log("onSubmitted: $value");
        ref.read(UiState.boardEditing.notifier).state = false;
        endEdit(value.isNotEmpty);
      },
      decoration: const InputDecoration(border: InputBorder.none),
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
    // return Card(
    //   margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
    //   color: Colors.transparent,
    //   clipBehavior: Clip.hardEdge,
    //   child: InkWell(
    //     // splashColor: "primary".themed(context).withAlpha(30),
    //       onTap: () {
    //         log("onTAP");
    //         startEditing();
    //         focusNode.requestFocus();
    //         // setState(() {
    //         //   startEditing();
    //         //   focusNode.requestFocus();
    //         // });
    //       },
    //       child: SizedBox(
    //         height: Sizes.kChecklistHeaderHeight,
    //         child: Padding(
    //             padding: const EdgeInsets.all(10.0),
    //             child: Row(children: [
    //               Expanded(
    //                   child: TextField(
    //                       onChanged: (value) =>
    //                       ref
    //                           .read(UiState.boardActiveText.notifier)
    //                           .state = controller.text,
    //                       controller: controller,
    //                       onTap: startEditing,
    //                       // onEditingComplete: () {
    //                       //   ref.read(UiState.boardEditing.notifier).state =
    //                       //       false;
    //                       //   // TODO!
    //                       //   // abActionListener.onEditEnd(true);
    //                       // },
    //                       onSubmitted: (value) {
    //                         log("onSubmitted: $value");
    //                         ref
    //                             .read(UiState.boardEditing.notifier)
    //                             .state =
    //                         false;
    //                         endEdit(value.isNotEmpty);
    //                       },
    //                       // onChanged: abActionListener.onChange,
    //                       focusNode: focusNode,
    //                       decoration: InputDecoration(
    //                           hintText: "add_task".resc(),
    //                           // border: InputBorder.none,
    //                           hintStyle: const TextStyle(
    //                               fontWeight: FontWeight.w400)))),
    //               // IconButton(
    //               //     onPressed:
    //               //         validText ? () => createTaskCb(taskName) : null,
    //               //     icon: const Icon(Icons.check))
    //             ])),
    //       )),
    // );
  }

  @override
  void endEdit(bool saveChanges) {
    log("checklist, endEdit: $saveChanges");
    if (saveChanges) {
      log("checklist update: ${controller.text}");
      checklist.title = controller.text;
      Api.instance.updateChecklist(ref, taskMetadata);
      // final tasksDao = ref.read(AppDatabase.provider).taskDao;
      // tasksDao.ChecklistHeader(taskJson);
      //   Api.instance
      //       .createTask(
      //     ref,
      //     columnModel.projectId,
      //     columnModel.id,
      //     controller.text,
      //   )
      //       .then((taskId) async {
      //     controller.text = "";
      //     // final taskDao = ref.read(AppDatabase.provider).taskDao;
      //     // ref.read(activeTask.notifier).state = await taskDao.getTask(taskId);
      //     // // TODO: await, bad idea?
      //     // Navigator.pushNamed(context, routeTask);
      //   }).onError((e, st) {
      //     log("err: $e, $st");
      //     return Utils.showErrorSnackbar(context, e);
      //   });
      // } else {
      //   controller.text = "";
      // }
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
