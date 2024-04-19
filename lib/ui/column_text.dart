import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/board_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/utils.dart';

class ColumnText extends StatefulWidget {
  final ColumnModel columnModel;
  final AppBarActionListener abActionListener;

  const ColumnText({
    super.key,
    required this.columnModel,
    required this.abActionListener,
  });

  @override
  State<StatefulWidget> createState() => ColumnTextState();
}

class ColumnTextState extends EditableState<ColumnText> {
  late ColumnModel columnModel;
  late AppBarActionListener abActionListener;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    columnModel = widget.columnModel;
    abActionListener = widget.abActionListener;
    controller = TextEditingController(text: columnModel.title);
  }

  @override
  void endEdit(bool saveChanges) {
    if (saveChanges) {
      log("column, save: ${columnModel.title}");
      if (columnModel.title != controller.text) {
        columnModel.title = controller.text;
        Api.updateColumn(columnModel).then((value) {
          if (!value) {
            Utils.showErrorSnackbar(context, "Could not save column");
          }
        }).onError((e, _) => Utils.showErrorSnackbar(context, e));
      }
    } else {
      controller.text = columnModel.title;
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // @override
  // void delete() {
  //   abActionListener.onEditEnd(false);
  //   Utils.showAlertDialog(context, "${'delete'.resc()} `${columnModel.title}`?",
  //       "alert_del_content".resc(), () {
  //     log("column, delete");
  //     Api.removeColumn(columnModel.id).then((value) {
  //       if (!value) {
  //         Utils.showErrorSnackbar(context, "Could not delete column");
  //       } else {
  //         abActionListener.refreshUi();
  //       }
  //     }).onError((e, _) => Utils.showErrorSnackbar(context, e));
  //   });
  // }

  // TODO: Cannot remove column, kanboard issue?
  @override
  void archive() {
    abActionListener.onEditEnd(false);
    Utils.showAlertDialog(
        context,
        "${'archive'.resc()} `${columnModel.title}`?",
        "alert_arch_content".resc(), () {
      log("column, archive");
      // Api.removeColumn(columnModel.id).then((value) {
      //   if (!value) {
      //     Utils.showErrorSnackbar(context, "Could not delete column");
      //   } else {
      //     abActionListener.refreshUi();
      //   }
      // }).onError((e, _) => Utils.showErrorSnackbar(context, e));
    });
  }

  @override
  void unarchive() {
    abActionListener.onEditEnd(false);
    Utils.showAlertDialog(
        context,
        "${'unarchive'.resc()} `${columnModel.title}`?",
        "alert_unarch_content".resc(), () {
      log("column, unarchive");
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: use popup button, Edit & Delete buttons? Or keep it simple?
    return TextField(
      controller: controller,
      onTap: () {
        abActionListener.onChange(controller.text);
        abActionListener.onEditStart(0, [
          columnModel.isActive
              ? BoardAppBarAction.kArchive
              : BoardAppBarAction.kUnarchive,
          AppBarAction.kDiscard,
          AppBarAction.kDone
        ]);
      },
      onChanged: abActionListener.onChange,
      onEditingComplete: () => abActionListener.onEditEnd(true),
      decoration: InputDecoration(
          hintText: "column_empty_warn".resc(),
          border: InputBorder.none,
          hintStyle: const TextStyle(
              fontWeight: FontWeight.w300, fontStyle: FontStyle.italic)),
      // style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
