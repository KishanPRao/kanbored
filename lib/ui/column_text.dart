import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/api/api_state.dart';
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

  @override
  void initState() {
    super.initState();
    columnModel = widget.columnModel;
    controller.text = columnModel.title;
    editActions = [
      AppBarAction.kDelete,
      columnModel.isActive
          ? BoardAppBarAction.kArchive
          : BoardAppBarAction.kUnarchive,
      AppBarAction.kDiscard,
      AppBarAction.kDone
    ];
  }

  @override
  Future<bool> endEdit(bool saveChanges) async {
    if (saveChanges) {
      log("column, save: ${columnModel.title}");
      if (columnModel.title != controller.text) {
        columnModel.title = controller.text;
        WebApi.updateColumn(columnModel).then((value) {
          if (!value) {
            Utils.showErrorSnackbar(context, "Could not save column");
          }
        }).onError((e, _) {
          log("could not update: $e");
          return Utils.showErrorSnackbar(context, e);
        });
      }
    } else {
      controller.text = columnModel.title;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    return true;
  }

  void removeColumn() {
    WebApi.removeColumn(columnModel.id).then((value) {
      Navigator.pop(context); // dialog
      if (!value) {
        Utils.showErrorSnackbar(context, "Could not remove column");
      } else {
        // TODO
        Api.updateColumns(ref, columnModel.projectId);
        // abActionListener.refreshUi();
      }
    }).onError((e, _) {
      Navigator.pop(context); // dialog
      return Utils.showErrorSnackbar(context, e);
    });
  }

  @override
  void delete() {
    ref.read(UiState.boardEditing.notifier).state = false;
    // abActionListener.onEditEnd(false);
    Utils.showAlertDialog(context, "${"delete".resc()} `${columnModel.title}`?",
        "alert_del_content".resc(), () {
      log("column, delete");

      Utils.showLoaderDialog(context, "Removing column..");
      final tasks = ref.read(ApiState.tasksInActiveProject);
      // TODO: merge all task removal together!
      var ids = tasks.where((t) => t.columnId == columnModel.id).map((t) => t.id);
      WebApi.removeAllTasks(ids)
          .then((value) {
        if (value.contains(false)) {
          Navigator.pop(context); // dialog
          Utils.showErrorSnackbar(context, "Could not clear all tasks");
        } else {
          removeColumn();
        }
      }).onError((e, st) {
        Navigator.pop(context); // dialog
        log("error: $e; $st");
        return Utils.showErrorSnackbar(context, e);
      });
    });
  }

  // TODO: Cannot remove column, kanboard issue?
  @override
  void archive() {
        ref.read(UiState.boardEditing.notifier).state = false;
        var projectMetadataModel = ref.read(ApiState.activeProjectMetadata)!;
    Utils.showAlertDialog(
        context,
        "${'archive'.resc()} `${columnModel.title}`?",
        "alert_arch_content".resc(), () {
      log("column, archive");
      if (!projectMetadataModel.closedColumns.contains(columnModel.id)) {
        columnModel.isActive = false;
        projectMetadataModel.closedColumns.add(columnModel.id);
        ref.read(ApiState.activeProjectMetadata.notifier).state = projectMetadataModel;
        WebApi.saveProjectMetadata(columnModel.projectId, projectMetadataModel)
            .then((value) {
          if (!value) {
            Utils.showErrorSnackbar(context, "Could not save project metadata");
          } else {
            // abActionListener.refreshUi();
            Api.updateColumns(ref, columnModel.projectId);
          }
        }).onError((e, _) {
          if (mounted) {
            Utils.showErrorSnackbar(context, e);
          } else {
            log("[Error snackbar] unmounted; $e");
          }
        });
      }
    });
  }

  @override
  void unarchive() {
    ref.read(UiState.boardEditing.notifier).state = false;
    var projectMetadataModel = ref.read(ApiState.activeProjectMetadata)!;
    Utils.showAlertDialog(
        context,
        "${'unarchive'.resc()} `${columnModel.title}`?",
        "alert_unarch_content".resc(), () {
      log("column, unarchive");
      if (projectMetadataModel.closedColumns.contains(columnModel.id)) {
        columnModel.isActive = true;
        projectMetadataModel.closedColumns.remove(columnModel.id);
        ref.read(ApiState.activeProjectMetadata.notifier).state = projectMetadataModel;
        WebApi.saveProjectMetadata(columnModel.projectId, projectMetadataModel)
            .then((value) {
          if (!value) {
            Utils.showErrorSnackbar(context, "Could not save project metadata");
          } else {
            // abActionListener.refreshUi();
            Api.updateColumns(ref, columnModel.projectId);
          }
        }).onError((e, _) {
          if (mounted) {
            Utils.showErrorSnackbar(context, e);
          } else {
            log("[Error snackbar] unmounted; $e");
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: use popup button, Edit & Delete buttons? Or keep it simple?
    // log("col text, build: ${columnModel.title}");
    return TextField(
      controller: controller,
      onTap: () {
        startEdit();
        // ref.read(UiState.boardActiveState.notifier).state =
        //     widget.key as GlobalKey<EditableState>;
        // ref.read(UiState.boardActiveText.notifier).state = controller.text;
        // ref.read(UiState.boardActions.notifier).state = [
        //   AppBarAction.kDelete,
        //   columnModel.hideInDashboard == 1
        //       ? BoardAppBarAction.kUnarchive
        //       : BoardAppBarAction.kArchive,
        //   AppBarAction.kDiscard,
        //   AppBarAction.kDone
        // ];
        // ref.read(UiState.boardEditing.notifier).state = true;
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
      onEditingComplete: () => endEdit(true),
      decoration: InputDecoration(
          hintText: "column_empty_warn".resc(),
          border: InputBorder.none,
          hintStyle: const TextStyle(
              fontWeight: FontWeight.w400, fontStyle: FontStyle.italic)),
      // style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
