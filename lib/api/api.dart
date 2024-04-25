import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils/utils.dart';

// ignore_for_file: use_build_context_synchronously
class Api {
  static Timer recurringApi(VoidCallback function, {int seconds = apiTimerDurationInSec}) {
    function();
    final oneSec = Duration(seconds: seconds);
    return Timer.periodic(oneSec, (Timer t) => function());
  }

  // TODO: use DAO

  // List update:
  static void updateProjects(WidgetRef ref, {recurring = false}) {
    function() {
      WebApi.getAllProjects().then((items) async {
        ref.read(AppDatabase.provider).projectDao.updateProjects(items);
        // updateDbProjects(ref, items);
      });
    }

    function();
    if (recurring) recurringApi(function);
  }

  static void updateColumns(WidgetRef ref, int projectId, {recurring = false}) {
    function() {
      WebApi.getColumns(projectId).then((items) async {
        // TODO: alt approach?
        // if (ref.context.mounted) {
        //   updateDbColumns(ref, items);
        // }
        ref.read(AppDatabase.provider).columnDao.updateColumns(items);
      });
    }

    function();
    if (recurring) recurringApi(function);
  }

  static void updateTasks(WidgetRef ref, int projectId, {recurring = false}) {
    function() {
      Future.wait([
        WebApi.getAllTasks(projectId, 1), // active
        WebApi.getAllTasks(projectId, 0), //inactive
      ]).then((value) {
        var tasks = value[0];
        tasks.addAll(value[1]);
        // log("tasks: $tasks");
        ref.read(AppDatabase.provider).taskDao.updateTasks(tasks);
      });
    }

    function();
    if (recurring) recurringApi(function);
  }

  // Single update:

  static Future<bool> updateProject(WidgetRef ref, ProjectModelData data,
      {webUpdate = true}) async {
    ref.read(activeProject.notifier).state = data;
    var result = true;
    if (webUpdate) {
      result = await WebApi.updateProject(data);
    }
    if (result) ref.read(AppDatabase.provider).projectDao.updateProject(data);
    return result;
  }

  static Future<bool> updateColumn(WidgetRef ref, ColumnModelData data,
      {webUpdate = true}) async {
    ref.read(activeColumn.notifier).state = data;
    if (webUpdate) {
      var result = await WebApi.updateColumn(data);
      if (result) ref.read(AppDatabase.provider).columnDao.updateColumn(data);
      return result;
    }
    return true;
  }

  static Future<bool> openTask(WidgetRef ref, int taskId) async {
    final result = await WebApi.openTask(taskId);
    if (result is int) {
      ref.read(AppDatabase.provider).taskDao.openTask(taskId);
    } else {
      Utils.showErrorSnackbar(ref.context, "Could not update task");
    }
    return result;
  }

  static Future<bool> closeTask(WidgetRef ref, int taskId) async {
    final result = await WebApi.closeTask(taskId);
    if (result is int) {
      ref.read(AppDatabase.provider).taskDao.closeTask(taskId);
    } else {
      Utils.showErrorSnackbar(ref.context, "Could not update task");
    }
    return result;
  }

  static Future<bool> updateTask(WidgetRef ref, TaskModelData data) async {
    final result = await WebApi.updateTask(data);
    if (result) {
      ref.read(AppDatabase.provider).taskDao.updateTask(data);
    } else {
      Utils.showErrorSnackbar(ref.context, "Could not update task");
    }
    return result;
  }

  //
  // static Future<TaskMetadataModelData?> retrieveTaskMetadata(
  //     WidgetRef ref, int taskId,
  //     {webUpdate = true}) async {
  //   var data = await WebApi.getTaskMetadata(taskId);
  //   if (data["task_id"] == null) {
  //     return null;
  //   }
  //   data["task_id"] = int.parse(data["task_id"]);
  //   return updateDbTaskMetadata(ref, data);
  // }
  //
  // static Future<TaskMetadataModelData?> retrieveActiveTaskMetadata(
  //     WidgetRef ref,
  //     {webUpdate = true}) async {
  //   var task = ref.read(activeTask)!;
  //   var metadata = retrieveTaskMetadata(ref, task.id);
  //   ref.read(activeTaskMetadata.notifier).state = await metadata;
  //   return metadata;
  // }

  // Create:
  static Future<dynamic> createProject(
      WidgetRef ref, String title) async {
    // final result = await WebApi.createProject(title);
    // if (result is int) {
    //   // ref.read(AppDatabase.provider).projectDao.addTcask(taskData);
    // } else {
    //   Utils.showErrorSnackbar(ref.context, "Could not create task");
    // }
    // return result;
    ref.read(AppDatabase.provider).projectDao.createLocalProject(title);
    // Add to queue
    // Merge value on result
  }

  static Future<dynamic> createTask(
      WidgetRef ref, int projectId, int columnId, String title) async {
    final result = await WebApi.createTask(projectId, columnId, title);
    if (result is int) {
      final taskData = await WebApi.getTask(result, projectId);
      ref.read(AppDatabase.provider).taskDao.createTask(taskData);
    } else {
      Utils.showErrorSnackbar(ref.context, "Could not create task");
    }
    return result;
  }

  // Remove:
  static Future<bool> removeProject(WidgetRef ref, int projectId) async {
    var result = await WebApi.removeProject(projectId);
    if (result) ref.read(AppDatabase.provider).projectDao.removeProject(projectId);
    return result;
  }

  static Future<bool> removeTask(WidgetRef ref, int taskId) async {
    var result = await WebApi.removeTask(taskId);
    if (result) ref.read(AppDatabase.provider).taskDao.removeTask(taskId);
    return result;
  }

// static Stream<List<ProjectModelData>> watchProjects() {
//   return (db.select(db.projectModel)).watch();
// }
}
