import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/web_api_model.dart';
import 'package:kanbored/utils/app_data.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/utils/utils.dart';

// ignore_for_file: use_build_context_synchronously
class Api {
  Api._privateConstructor();

  static final Api instance = Api._privateConstructor();

  static Timer recurringApi(void Function() function,
      {int seconds = apiTimerDurationInSec}) {
    final oneSec = Duration(seconds: seconds);
    return Timer.periodic(oneSec, (Timer t) => function());
  }

// TODO: use DAO

// List update:

// Single update:

// Create:

// static Stream<List<ProjectModelData>> watchProjects() {
//   return (db.select(db.projectModel)).watch();
// }
}

extension ApiProject on Api {
  void createProject(WidgetRef ref, String name) async {
    // if (result is int) {
    //   // ref.read(AppDatabase.provider).projectDao.addTcask(taskData);
    // } else {
    //   Utils.showErrorSnackbar(ref.context, "Could not create task");
    // }
    // return result;
    // WebApi.createProject(title)
    final localId = await ref.read(AppDatabase.provider).apiStorageDao.nextId();
    final id = await ref
        .read(AppDatabase.provider)
        .projectDao
        .createLocalProject(localId, name);
    log("create local project: $id; $localId");
    ref.read(AppDatabase.provider).apiStorageDao.addApiTask(
          WebApiModel.createProject,
          {"name": name, "owner_id": AppData.userId},
          localId,
        );
    // Add to queue
    // Merge value on result
  }

  void updateProject(WidgetRef ref, ProjectModelData data) async {
    // ref.read(activeProject.notifier).state = data;
    // var result = true;
    // if (webUpdate) {
    //   result = await WebApi.updateProject(data);
    // }
    // if (result) ref.read(AppDatabase.provider).projectDao.updateProject(data);
    // return result;
    ref.read(AppDatabase.provider).projectDao.updateProject(data);
    log("updateProject");
    ref.read(AppDatabase.provider).apiStorageDao.addApiTask(
          WebApiModel.updateProject,
          {
            "project_id": Utils.generateUpdateIdString(data.id),
            "name": data.name,
          },
          data.id,
        );
    // TODO: call enable/disable project
  }

  Future<bool> removeProject(WidgetRef ref, int projectId) async {
    var result = await WebApi.removeProject(projectId);
    if (result) {
      ref.read(AppDatabase.provider).projectDao.removeProject(projectId);
    }
    return result;
  }

  Timer? updateProjects(WidgetRef ref, {recurring = false}) {
    function() {
      // TODO: try catch, SocketException
      WebApi.getAllProjects().then((items) async {
        ref.read(AppDatabase.provider).projectDao.updateProjects(items);
        // updateDbProjects(ref, items);
      });
    }

    function();
    if (recurring) return Api.recurringApi(function);
    return null;
  }
}

extension ApiColumn on Api {
  void addColumn(WidgetRef ref, int projectId, String title) async {
    final localId = await ref.read(AppDatabase.provider).apiStorageDao.nextId();
    await ref
        .read(AppDatabase.provider)
        .columnDao
        .addColumn(localId, title, projectId);
    log("[api] addColumn: $localId");
    ref.read(AppDatabase.provider).apiStorageDao.addApiTask(
          WebApiModel.addColumn,
          [Utils.generateUpdateIdString(projectId), title],
          localId,
        );
  }

  void updateColumn(WidgetRef ref, ColumnModelData data) async {
    ref.read(AppDatabase.provider).columnDao.updateColumn(data);
    log("[api] updateColumn");
    ref.read(AppDatabase.provider).apiStorageDao.addApiTask(
          WebApiModel.updateColumn,
          [
            Utils.generateUpdateIdString(data.id),
            data.title,
            data.taskLimit,
            data.description,
          ],
          data.id,
        );
    // TODO: call enable/disable project
  }

  Timer? updateColumns(WidgetRef ref, int projectId, {recurring = false}) {
    function() {
      WebApi.getColumns(projectId).then((items) async {
        // TODO: alt approach?
        // if (ref.context.mounted) {
        //   updateDbColumns(ref, items);
        // }
        ref.readIfMounted(AppDatabase.provider)?.columnDao.updateColumns(items);
      });
    }

    function();
    if (recurring) return Api.recurringApi(function);
    return null;
  }
}

extension ApiTask on Api {
  Timer? updateTasks(WidgetRef ref, int projectId, {recurring = false}) {
    function() {
      Future.wait([
        WebApi.getAllTasks(projectId, 1), // active
        WebApi.getAllTasks(projectId, 0), //inactive
      ]).then((values) {
        var tasks = values[0];
        tasks.addAll(values[1]);
        // log("tasks: $tasks");
        log("update tasks: ${tasks.length}");
        ref.readIfMounted(AppDatabase.provider)?.taskDao.updateTasks(tasks);
      });
    }

    function();
    if (recurring) return Api.recurringApi(function);
    return null;
  }

  Future<bool> openTask(WidgetRef ref, int taskId) async {
    final result = await WebApi.openTask(taskId);
    if (result is int) {
      ref.read(AppDatabase.provider).taskDao.openTask(taskId);
    } else {
      Utils.showErrorSnackbar(ref.context, "Could not update task");
    }
    return result;
  }

  Future<bool> closeTask(WidgetRef ref, int taskId) async {
    final result = await WebApi.closeTask(taskId);
    if (result is int) {
      ref.read(AppDatabase.provider).taskDao.closeTask(taskId);
    } else {
      Utils.showErrorSnackbar(ref.context, "Could not update task");
    }
    return result;
  }

  Future<bool> updateTask(WidgetRef ref, TaskModelData data) async {
    final result = await WebApi.updateTask(data);
    if (result) {
      ref.read(AppDatabase.provider).taskDao.updateTask(data);
    } else {
      Utils.showErrorSnackbar(ref.context, "Could not update task");
    }
    return result;
  }

  Future<int> createTask(
      WidgetRef ref, int projectId, int columnId, String title) async {
    final localId = await ref.read(AppDatabase.provider).apiStorageDao.nextId();
    await ref
        .read(AppDatabase.provider)
        .taskDao
        .createTask(localId, projectId, columnId, title);
    log("[api] createTask: $localId");
    ref.read(AppDatabase.provider).apiStorageDao.addApiTask(
          WebApiModel.createTask,
          {
            "owner_id": AppData.userId,
            "creator_id": AppData.userId,
            "date_started": null,
            "date_due": null,
            "description": "",
            "category_id": 0,
            "score": null,
            "title": title,
            "project_id": Utils.generateUpdateIdString(projectId),
            "color_id": "yellow",
            "column_id": Utils.generateUpdateIdString(columnId),
            "recurrence_status": 0,
            "recurrence_trigger": 0,
            "recurrence_factor": 0,
            "recurrence_timeframe": 0,
            "recurrence_basedate": 0,
            "time_estimated": 0,
            "time_spent": 0,
            "nb_comments": 0,
          },
          localId,
        );
    return localId;
  }

  // Remove:

  Future<bool> removeTask(WidgetRef ref, int taskId) async {
    var result = await WebApi.removeTask(taskId);
    if (result) ref.read(AppDatabase.provider).taskDao.removeTask(taskId);
    return result;
  }
}

extension ApiTaskMetadata on Api {
  // Future<TaskMetadataModelData?> retrieveTaskMetadata(WidgetRef ref, int taskId,
  //     {webUpdate = true}) async {
  //   var data = await WebApi.getTaskMetadata(taskId);
  //   if (data["task_id"] == null) {
  //     return null;
  //   }
  //   data["task_id"] = int.parse(data["task_id"]);
  //   return updateDbTaskMetadata(ref, data);
  // }
  //
  // Future<TaskMetadataModelData?> retrieveActiveTaskMetadata(WidgetRef ref,
  //     {webUpdate = true}) async {
  //   var task = ref.read(activeTask)!;
  //   var metadata = retrieveTaskMetadata(ref, task.id);
  //   ref.read(activeTaskMetadata.notifier).state = await metadata;
  //   return metadata;
  // }
  // TODO: create
  // void updateSubtask(WidgetRef ref, SubtaskModelData data) async {
  //   ref.read(AppDatabase.provider).subtaskDao.updateSubtask(data);
  //   log("[api] updateSubtask");
  //   ref.read(AppDatabase.provider).apiStorageDao.addApiTask(
  //     WebApiModel.updateSubtask,
  //     {
  //       "id": Utils.generateUpdateIdString(data.id),
  //       "task_id": Utils.generateUpdateIdString(data.taskId),
  //       "title": data.title,
  //       "user_id": data.userId,
  //       "time_estimated": data.timeEstimated,
  //       "time_spent": data.timeSpent,
  //       "status": data.status,
  //     },
  //     data.id,
  //   );
  //   // TODO: call enable/disable project
  // }

  Timer? retrieveTaskMetadata(WidgetRef ref, int taskId, {recurring = false}) {
    function() {
      WebApi.getTaskMetadata(taskId).then((items) async {
        // TODO: alt approach?
        // if (ref.context.mounted) {
        //   updateDbColumns(ref, items);
        // }
        // log("updateSubtasks: $items");
        ref
            .readIfMounted(AppDatabase.provider)
            ?.taskMetadataDao
            .updateTaskMetadata(taskId, items);
      });
    }

    function();
    if (recurring) return Api.recurringApi(function);
    return null;
  }
}

extension ApiSubtask on Api {
  // TODO: create
  void updateSubtask(WidgetRef ref, SubtaskModelData data) async {
    ref.read(AppDatabase.provider).subtaskDao.updateSubtask(data);
    log("[api] updateSubtask");
    ref.read(AppDatabase.provider).apiStorageDao.addApiTask(
          WebApiModel.updateSubtask,
          {
            "id": Utils.generateUpdateIdString(data.id),
            "task_id": Utils.generateUpdateIdString(data.taskId),
            "title": data.title,
            "user_id": data.userId,
            "time_estimated": data.timeEstimated,
            "time_spent": data.timeSpent,
            "status": data.status,
          },
          data.id,
        );
    // TODO: call enable/disable project
  }

  Timer? updateSubtasks(WidgetRef ref, int taskId, {recurring = false}) {
    function() {
      WebApi.getAllSubtasks(taskId).then((items) async {
        // TODO: alt approach?
        // if (ref.context.mounted) {
        //   updateDbColumns(ref, items);
        // }
        // log("updateSubtasks: $items");
        ref
            .readIfMounted(AppDatabase.provider)
            ?.subtaskDao
            .updateSubtasks(items);
      });
    }

    function();
    if (recurring) return Api.recurringApi(function);
    return null;
  }
}

extension ApiComment on Api {
  // TODO: create
  void updateComment(WidgetRef ref, CommentModelData data) async {
    ref.read(AppDatabase.provider).commentDao.updateComment(data);
    log("[api] updateComment");
    ref.read(AppDatabase.provider).apiStorageDao.addApiTask(
          WebApiModel.updateComment,
          {
            "id": Utils.generateUpdateIdString(data.id),
            "content": data.comment
          },
          data.id,
        );
  }

  Timer? updateComments(WidgetRef ref, int taskId, {recurring = false}) {
    function() {
      WebApi.getAllComments(taskId).then((items) async {
        // TODO: alt approach?
        // if (ref.context.mounted) {
        //   updateDbColumns(ref, items);
        // }
        ref
            .readIfMounted(AppDatabase.provider)
            ?.commentDao
            .updateComments(items);
      });
    }

    function();
    if (recurring) return Api.recurringApi(function);
    return null;
  }
}

// TODO: remove if unneeded
extension WidgetRefExt on WidgetRef {
  T? readIfMounted<T>(ProviderListenable<T> provider) {
    if (context.mounted) {
      return read(provider);
    }
    return null;
  }
}
