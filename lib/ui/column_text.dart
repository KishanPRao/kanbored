import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/project_metadata_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/strings.dart';
import 'package:kanbored/ui/abstract_app_bar.dart';
import 'package:kanbored/ui/board_app_bar.dart';
import 'package:kanbored/ui/editing_state.dart';
import 'package:kanbored/ui/app_bar_action_listener.dart';
import 'package:kanbored/utils.dart';

class ColumnText extends StatefulWidget {
  final ProjectMetadataModel projectMetadataModel;
  final ColumnModel columnModel;
  final AppBarActionListener abActionListener;

  const ColumnText({
    super.key,
    required this.columnModel,
    required this.projectMetadataModel,
    required this.abActionListener,
  });

  @override
  State<StatefulWidget> createState() => ColumnTextState();
}

class ColumnTextState extends EditableState<ColumnText> {
  late ColumnModel columnModel;
  late ProjectMetadataModel projectMetadataModel;
  late AppBarActionListener abActionListener;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    columnModel = widget.columnModel;
    projectMetadataModel = widget.projectMetadataModel;
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

  // TODO: Cannot remove column, kanboard issue?
  @override
  void archive() {
    abActionListener.onEditEnd(false);
    Utils.showAlertDialog(
        context,
        "${'archive'.resc()} `${columnModel.title}`?",
        "alert_arch_content".resc(), () {
      log("column, archive");
      if (!projectMetadataModel.closedColumns.contains(columnModel.id)) {
        columnModel.isActive = false;
        projectMetadataModel.closedColumns.add(columnModel.id);
        Api.saveProjectMetadata(columnModel.projectId, projectMetadataModel)
            .then((value) {
          if (!value) {
            Utils.showErrorSnackbar(context, "Could not save project metadata");
          } else {
            abActionListener.refreshUi();
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
    abActionListener.onEditEnd(false);
    Utils.showAlertDialog(
        context,
        "${'unarchive'.resc()} `${columnModel.title}`?",
        "alert_unarch_content".resc(), () {
      log("column, unarchive");
      if (projectMetadataModel.closedColumns.contains(columnModel.id)) {
        columnModel.isActive = true;
        projectMetadataModel.closedColumns
            .removeWhere((item) => item == columnModel.id);
        Api.saveProjectMetadata(columnModel.projectId, projectMetadataModel)
            .then((value) {
          if (!value) {
            Utils.showErrorSnackbar(context, "Could not save project metadata");
          } else {
            abActionListener.refreshUi();
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
