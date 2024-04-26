import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/board_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/ui_state.dart';
import 'package:kanbored/utils/strings.dart';
import 'package:kanbored/utils/utils.dart';

class ColumnText extends ConsumerStatefulWidget {
  final ColumnModel columnModel;

  const ColumnText({
    super.key,
    required this.columnModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ColumnTextState();
}

class ColumnTextState extends EditableState<ColumnText> {
  late ColumnModel columnModel;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    columnModel = widget.columnModel;
    controller = TextEditingController(text: columnModel.title);
  }

  @override
  void endEdit(bool saveChanges) {
    if (saveChanges) {
      log("column, save: ${columnModel.title}");
      if (columnModel.title != controller.text) {
        columnModel.title = controller.text;
        WebApi.updateColumn(columnModel).then((value) {
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

  void removeColumn() {
    WebApi.removeColumn(columnModel.id).then((value) {
      if (!value) {
        Utils.showErrorSnackbar(context, "Could not remove column");
      } else {
        // TODO
        Api.updateColumns(ref, columnModel.projectId);
        // abActionListener.refreshUi();
      }
    }).onError((e, _) => Utils.showErrorSnackbar(context, e));
  }

  @override
  void delete() {
    ref.read(UiState.boardEditing.notifier).state = false;
    // abActionListener.onEditEnd(false);
    Utils.showAlertDialog(context, "${'delete'.resc()} `${columnModel.title}`?",
        "alert_del_content".resc(), () {
      log("column, delete");

      Future.wait(
              columnModel.tasks.map((t) => WebApi.removeTask(t.id)).toList())
          .then((value) {
        if (value.contains(false)) {
          Utils.showErrorSnackbar(context, "Could not clear all tasks");
        } else {
          removeColumn();
        }
      }).onError((e, _) => Utils.showErrorSnackbar(context, e));
    });
  }

  void updateArchive(bool archive) {
    ref.read(UiState.boardEditing.notifier).state = false;
    // abActionListener.onEditEnd(false);
    final title = archive ? 'archive' : 'unarchive';
    final content = archive ? 'alert_arch_content' : 'alert_unarch_content';
    Utils.showAlertDialog(
        context, "${title.resc()} `${columnModel.title}`?", content.resc(), () {
      log("column, $title");
      columnModel.hideInDashboard = archive ? 1 : 0;
      WebApi.updateColumn(columnModel).then((value) {
        if (!value) {
          Utils.showErrorSnackbar(context, "Could not update column");
        } else {
          // TODO
          Api.updateColumns(ref, columnModel.projectId);
          // abActionListener.refreshUi();
        }
      }).onError((e, _) => Utils.showErrorSnackbar(context, e));
    });
  }

  // TODO: Cannot remove column, kanboard issue?
  @override
  void archive() => updateArchive(true);

  @override
  void unarchive() => updateArchive(false);

  @override
  Widget build(BuildContext context) {
    // TODO: use popup button, Edit & Delete buttons? Or keep it simple?
    // log("col text, build: ${columnModel.title}");
    return TextField(
      controller: controller,
      onTap: () {
        ref.read(UiState.boardActiveState.notifier).state =
            widget.key as GlobalKey<EditableState>;
        ref.read(UiState.boardActiveText.notifier).state = controller.text;
        ref.read(UiState.boardActions.notifier).state = [
          AppBarAction.kDelete,
          columnModel.hideInDashboard == 1
              ? BoardAppBarAction.kUnarchive
              : BoardAppBarAction.kArchive,
          AppBarAction.kDiscard,
          AppBarAction.kDone
        ];
        ref.read(UiState.boardEditing.notifier).state = true;
        // abActionListener.onChange(controller.text);
        // abActionListener.onEditStart(0, [
        //   AppBarAction.kDelete,
        //   columnModel.isActive
        //       ? BoardAppBarAction.kArchive
        //       : BoardAppBarAction.kUnarchive,
        //   AppBarAction.kDiscard,
        //   AppBarAction.kDone
        // ]);
      },
      onChanged: (text) =>
          ref.read(UiState.boardActiveText.notifier).state = text,
      onEditingComplete: () => ref
          .read(UiState.appBarActiveState.notifier)
          .state
          ?.currentState
          ?.endEdit(true),
      decoration: InputDecoration(
          hintText: "column_empty_warn".resc(),
          border: InputBorder.none,
          hintStyle: const TextStyle(
              fontWeight: FontWeight.w400, fontStyle: FontStyle.italic)),
      // style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
