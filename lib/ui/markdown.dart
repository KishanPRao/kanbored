import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as flmd;
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/comment_model.dart';
import 'package:kanbored/models/model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/task_action_listener.dart';
import 'package:kanbored/utils.dart';
import 'package:markdown/markdown.dart' as md;

class Markdown extends StatefulWidget {
  final Model model;
  final TaskActionListener taskActionListener;

  const Markdown({
    super.key,
    required this.model,
    required this.taskActionListener,
  });

  // final TextEditingController controller;
  // final Function? onChange;
  // final int maxLines;

  @override
  State<StatefulWidget> createState() => _MarkdownState();
}

// NOTE: Assumes `TaskModel` is used for description, `CommentModel` for comments.
class _MarkdownState extends EditableState<Markdown> {
  // final int maxLines = 8;
  late Model model;
  late TextEditingController controller;
  late TaskActionListener taskActionListener;
  bool editing = false;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    model = widget.model;
    taskActionListener = widget.taskActionListener;
    controller = TextEditingController(text: getModelData());
  }

  String getModelData() {
    var model = this.model;
    if (model is TaskModel) {
      return model.description;
    } else if (model is CommentModel) {
      return model.comment;
    }
    return "invalid".resc();
  }

  Future<bool> saveModelData() async {
    var model = this.model;
    if (model is TaskModel) {
      model.description = controller.text;
      log("Save desc: ${model.description}");
      return await Api.updateTask(model);
    } else if (model is CommentModel) {
      model.comment = controller.text;
      log("Save comment: ${model.comment}");
    }
    return false;
  }

  @override
  void startEdit() {
    taskActionListener.onChange(controller.text);
    taskActionListener.onEditStart(null);
    setState(() {
      editing = true;
    });
  }

  @override
  void endEdit(bool saveChanges) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (saveChanges) {
      // TODO
      saveModelData().then((value) {
        if (!value) {
          Utils.showErrorSnackbar(context, "Could not save task");
        }
      }).onError((e, _) {
        Utils.showErrorSnackbar(context, e);
      });
    } else {
      controller.text = getModelData();
    }
    setState(() {
      editing = false;
    });
    // FocusManager.instance.primaryFocus?.unfocus();
    // if (saveChanges) {
    //   log("Update : ${controller.text}");
    //   // TODO
    //   // Api.createSubtask(task.id, controller.text)
    //   //     .then((subtaskId) => updateTaskMetadata(subtaskId))
    //   //     .catchError((e) => Utils.showErrorSnackbar(context, e));
    // } else {
    //   controller.text = "";
    // }
    // FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void delete() {
    log("mkdown: delete");
  }

  void updateFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    TextSelection currentSelection =
        const TextSelection(baseOffset: 0, extentOffset: 0);
    return Container(
      margin: const EdgeInsets.all(5),
      color: (editing ? "descEditBg" : "descBg").themed(context),
      child: editing
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
              child: TextField(
                autofocus: true,
                maxLines: null,
                style: const TextStyle(fontSize: 15),
                controller: controller,
                focusNode: focusNode,
                onTap: () {
                  taskActionListener.onChange(controller.text);
                  taskActionListener.onEditStart(null);
                },
                onChanged: taskActionListener.onChange,
                onEditingComplete: () {
                  taskActionListener.onEditEnd(true);
                },
              ))
          : GestureDetector(
              onTap: () {
                updateFocus();
                log("onTap Gesture");
                taskActionListener.onChange(controller.text);
                taskActionListener.onEditStart(null);
                // focusNode.requestFocus();
                setState(() {
                  editing = true;
                });
              },
              child: flmd.Markdown(
                controller: ScrollController(),
                selectable: true,
                onSelectionChanged: (text, selection, cause) {
                  log("onSelectionChanged: $selection, $text, $cause");
                  log("onSelectionChanged: ${selection.affinity}, ${selection.base}, ${selection.baseOffset}, ${selection.extent}, ${selection.extentOffset}, ${selection.end}, ${selection.start}");
                  currentSelection = selection;
                  // if (cause == SelectionChangedCause.tap) {
                  //
                  // }
                },
                styleSheet: flmd.MarkdownStyleSheet(
                  p: const TextStyle(fontSize: 15),
                ),
                onTapText: () {
                  log("onTapText");
                  updateFocus();
                  controller.selection = currentSelection;
                  taskActionListener.onChange(controller.text);
                  taskActionListener.onEditStart(null);
                  setState(() {
                    editing = true;
                  });
                }
                // onChange(controller.text);
                ,
                onTapLink: (_, href, __) async {
                  // if (href == null || !await canLaunch(href)) {
                  //   Fluttertoast.showToast(
                  //     msg: "Couldn't open the URL",
                  //     toastLength: Toast.LENGTH_SHORT,
                  //     gravity: ToastGravity.CENTER,
                  //     timeInSecForIosWeb: 1,
                  //     backgroundColor: Colors.red,
                  //     textColor: Colors.white,
                  //     fontSize: 16.0,
                  //   );
                  // } else {
                  //   launch(href);
                  // }
                },
                data: controller.text,
                shrinkWrap: true,
                extensionSet: md.ExtensionSet(
                  md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                  [
                    md.EmojiSyntax(),
                    ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                  ],
                ),
              )),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}
