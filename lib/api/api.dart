import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/db/database.dart';

class Api {
  static void recurringApi(VoidCallback function) {
    function();
    const oneSec = Duration(seconds: apiTimerDurationInSec);
    Timer.periodic(oneSec, (Timer t) => function());
  }

  static void updateProjects(WidgetRef ref, {recurring = false}) {
    function() {
      WebApi.getAllProjects().then((items) async {
        updateDbProjects(ref, items);
      });
    }

    function();
    if (recurring) recurringApi(function);
  }

  static void updateColumns(WidgetRef ref, int projectId, {recurring = false}) {
    function() {
      WebApi.getColumns(projectId).then((items) async {
        // TODO: alt approach?
        if (ref.context.mounted) {
          updateDbColumns(ref, items);
        }
      });
    }

    function();
    if (recurring) recurringApi(function);
  }

  static void updateTasks(WidgetRef ref, int projectId, {recurring = false}) {
    function() {
      // active, inactive tasks
      Future.wait([
        WebApi.getAllTasks(projectId, 1),
        WebApi.getAllTasks(projectId, 0),
      ]).then((value) {
        var tasks = value[0];
        tasks.addAll(value[1]);
        // log("tasks: $tasks");
        updateDbTasks(ref, tasks);
      });
    }

    function();
    if (recurring) recurringApi(function);
  }

  static Future<bool> removeProject(WidgetRef ref, int projectId) async {
    var result = await WebApi.removeProject(projectId);
    if (result) removeDbProject(ref, projectId);
    return result;
  }

  static Future<bool> updateProject(WidgetRef ref, ProjectModelData data,
      {webUpdate = true}) async {
    ref.read(activeProject.notifier).state = data;
    var result = true;
    if (webUpdate) {
      result = await WebApi.updateProject(data);
    }
    if (result) updateDbProject(ref, data);
    return result;
  }

  static Future<bool> updateColumn(WidgetRef ref, ColumnModelData data,
      {webUpdate = true}) async {
    ref.read(activeColumn.notifier).state = data;
    if (webUpdate) {
      var result = await WebApi.updateColumn(data);
      if (result) updateDbColumn(ref, data);
      return result;
    }
    return true;
  }

  static Future<TaskMetadataModelData?> retrieveTaskMetadata(
      WidgetRef ref, int taskId,
      {webUpdate = true}) async {
    var data = await WebApi.getTaskMetadata(taskId);
    if (data["task_id"] == null) {
      return null;
    }
    data["task_id"] = int.parse(data["task_id"]);
    return updateDbTaskMetadata(ref, data);
  }

  static Future<TaskMetadataModelData?> retrieveActiveTaskMetadata(
      WidgetRef ref,
      {webUpdate = true}) async {
    var task = ref.read(activeTask)!;
    var metadata = retrieveTaskMetadata(ref, task.id);
    ref.read(activeTaskMetadata.notifier).state = await metadata;
    return metadata;
  }

// static Stream<List<ProjectModelData>> watchProjects() {
//   return (db.select(db.projectModel)).watch();
// }
}
