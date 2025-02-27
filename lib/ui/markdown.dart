import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as flmd;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/models/comment_model.dart';
import 'package:kanbored/models/model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils/utils.dart';
import 'package:markdown/markdown.dart' as md;

class Markdown extends ConsumerStatefulWidget {
  final String content;
  final Function(String) onSaveCb;

  // final Model model;
  // final AppBarActionListener abActionListener;

  const Markdown({
    super.key,
    required this.content,
    required this.onSaveCb,
    // required this.model,
    // required this.abActionListener,
  });

  // final TextEditingController controller;
  // final Function? onChange;
  // final int maxLines;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MarkdownState();
}

// NOTE: Assumes `TaskModel` is used for description, `CommentModel` for comments.
class _MarkdownState extends EditableState<Markdown> {
  // final int maxLines = 8;
  // late Model model;
  late TextEditingController controller;

  // late AppBarActionListener abActionListener;
  // bool editing = false;
  final FocusNode focusNode = FocusNode();
  late String content;
  late Function(String) onSaveCb;

  @override
  void initState() {
    super.initState();
    // model = widget.model;
    // abActionListener = widget.abActionListener;
    content = widget.content;
    onSaveCb = widget.onSaveCb;
    controller = TextEditingController(text: content);
  }

  // String getModelData() {
  //   var model = this.model;
  //   if (model is TaskModel) {
  //     return model.description;
  //   } else if (model is CommentModel) {
  //     return model.comment;
  //   }
  //   return "invalid".resc();
  // }
  //
  // Future<bool> saveModelData() async {
  //   var model = this.model;
  //   if (model is TaskModel) {
  //     model.description = controller.text;
  //     log("Save desc: ${model.description}");
  //     return await WebApi.updateTask(model);
  //   } else if (model is CommentModel) {
  //     model.comment = controller.text;
  //     log("Save comment: ${model.comment}");
  //     return await WebApi.updateComment(model);
  //   }
  //   return false;
  // }

  @override
  void startEdit() {
    log("widget.key: ${widget.key}");
    ref.read(UiState.boardActiveState.notifier).state =
        widget.key as GlobalKey<EditableState>;
    ref.read(UiState.boardActiveText.notifier).state = controller.text;
    ref.read(UiState.boardActions.notifier).state = [
      AppBarAction.kDiscard,
      AppBarAction.kDone
    ];
    ref.read(UiState.boardEditing.notifier).state = true;
    // abActionListener.onChange(controller.text);
    // abActionListener.onEditStart(null, []);
    // setState(() {
    //   editing = true;
    // });
  }

  @override
  void endEdit(bool saveChanges) {
    // FocusManager.instance.primaryFocus?.unfocus();
    if (saveChanges) {
      // TODO
      content = controller.text;
      onSaveCb(content);
      // saveModelData().then((value) {
      //   if (!value) {
      //     Utils.showErrorSnackbar(context, "Could not save task");
      //   }
      // }).onError((e, _) {
      //   Utils.showErrorSnackbar(context, e);
      // });
    } else {
      // controller.text = getModelData();
      controller.text = content;
      ref.read(UiState.boardEditing.notifier).state = false;
    }
    // setState(() {
    //   editing = false;
    // });
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
    FocusManager.instance.primaryFocus?.unfocus();
  }

  //
  // void deleteComment(CommentModel model) {
  //   abActionListener.onEditEnd(false);
  //   Utils.showAlertDialog(context, "${'delete'.resc()} `${model.comment}`?",
  //       "alert_del_content".resc(), () {
  //     WebApi.removeComment(model.id).then((value) {
  //       if (!value) {
  //         Utils.showErrorSnackbar(context, "Could not delete comment");
  //       } else {
  //         abActionListener.refreshUi();
  //       }
  //     }).onError((e, _) => Utils.showErrorSnackbar(context, e));
  //   });
  // }

  @override
  void delete() {
    log("mkdown: delete");
    // var model = this.model;
    // if (model is CommentModel) {
    //   deleteComment(model);
    // }
  }

  void updateFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    TextSelection currentSelection =
        const TextSelection(baseOffset: 0, extentOffset: 0);
    final editing = ref.watch(UiState.boardEditing) &&
        ref.read(UiState.boardActiveState.notifier).state ==
            widget.key as GlobalKey<EditableState>;
    // TODO: check key?
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
                  startEdit();
                  // abActionListener.onChange(controller.text);
                  // abActionListener.onEditStart(null, []);
                },
                onChanged: (value) =>
                    ref.read(UiState.boardActiveText.notifier).state = value,
                onEditingComplete: () {
                  endEdit(true);
                  // abActionListener.onEditEnd(true);
                },
              ))
          : GestureDetector(
              onTap: () {
                updateFocus();
                log("onTap Gesture");
                startEdit();
                // abActionListener.onChange(controller.text);
                // abActionListener.onEditStart(null, []);
                // // focusNode.requestFocus();
                // setState(() {
                //   editing = true;
                // });
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
                  // abActionListener.onChange(controller.text);
                  // abActionListener.onEditStart(null, []);
                  // setState(() {
                  //   editing = true;
                  // });
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
