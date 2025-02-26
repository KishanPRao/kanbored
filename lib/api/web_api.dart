import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kanbored/api/state.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/web_api_model.dart';
import 'package:kanbored/models/board_model.dart';
import 'package:kanbored/models/comment_model.dart';
import 'package:kanbored/models/model.dart';
import 'package:kanbored/models/project_metadata_model.dart';
import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';
import 'package:kanbored/models/task_model.dart';
import 'package:kanbored/utils/app_data.dart';

class WebApi {
  static Future<bool> login(
      String url, String username, String password) async {
    String endpoint = url;
    int searchResult = url.indexOf('/jsonrpc.php');
    if (searchResult < 0) {
      endpoint += '/jsonrpc.php';
    }
    bool? validURL = Uri.tryParse(endpoint)?.isAbsolute;
    if (validURL == null || !validURL) {
      Map<String, String> error = {
        'message':
            'We could not reach your Kanboard Endpoint. Please, check your Endpoint URL and try again!'
      };
      return Future.error(error);
    }

    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getMe",
      "id": 2134420212
    };
    final credentials = "$username:$password";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    final resp = await http.post(
      Uri.parse(endpoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
      encoding: Encoding.getByName("utf-8"),
    );

    dynamic decodedData;
    try {
      decodedData =
          json.decode(utf8.decode(resp.bodyBytes)) as Map<String, dynamic>;
    } on FormatException catch (_) {
      Map<String, String> error = {
        'message':
            'Could not decode data! Please, try again or contact your administrator'
      };
      return Future.error(error);
    }
    if (decodedData == null) {
      Map<String, String> error = {
        'message':
            'Unknown Error! Please, check your credentials and access permission!'
      };
      return Future.error(error);
    }
    if (decodedData['error'] != null) return Future.error(decodedData['error']);
    final myUser = decodedData['result'];
    AppData.password = password;
    AppData.username = username;
    AppData.url = url;
    AppData.endpoint = endpoint;
    AppData.userId = myUser["id"];
    AppData.appRole = myUser["role"];
    AppData.authenticated = true;
    return true;
  }

  //////////////////////////////////// SETTER //////////////////////////////////

  // CREATE

  static String createProject(String name) =>
      setApiParams("createProject", 1797076613,
          params: {"name": name, "owner_id": AppData.userId});

  static Future<dynamic> addColumn(int projectId, String title) =>
      setApi("addColumn", 638544704, params: [projectId, title]);

  static Future<dynamic> createTask(
          int projectId, int columnId, String title) async =>
      setApi("createTask", 1176509098, params: {
        "owner_id": AppData.userId,
        "creator_id": AppData.userId,
        "date_started": null,
        "date_due": null,
        "description": "",
        "category_id": 0,
        "score": null,
        "title": title,
        "project_id": projectId,
        "color_id": "yellow",
        "column_id": columnId,
        "recurrence_status": 0,
        "recurrence_trigger": 0,
        "recurrence_factor": 0,
        "recurrence_timeframe": 0,
        "recurrence_basedate": 0,
        "time_estimated": 0,
        "time_spent": 0,
        "nb_comments": 0,
      });

  static Future<int> createSubtask(int taskId, String subtaskName) async =>
      setApi("createSubtask", 2041554661, params: {
        "title": subtaskName,
        "task_id": taskId,
      });

  static Future<dynamic> createComment(int taskId, String content) async =>
      setApi("createComment", 1580417921, params: {
        "task_id": taskId,
        "user_id": AppData.userId,
        "content": content
      });

  // UPDATE

  static Future<bool> updateProject(ProjectModelData model) async =>
      setApi("updateProject", 1853996288,
          params: {"project_id": model.id, "name": model.name});

  static Future<bool> updateColumn(ColumnModelData model) async =>
      setApi("updateColumn", 480740641,
          params: [model.id, model.title, model.taskLimit, model.description]);

  static Future<bool> updateTask(TaskModelData taskModel) async =>
      setApi("updateTask", 1406803059,
          params: taskModel.toJsonWithKeys([
                "id",
                "title",
                "color_id",
                "owner_id",
                "description",
                "score",
                // "category_id",
                // "priority",
                // "recurrence_status",
                // "recurrence_trigger",
                // "recurrence_factor",
                // "recurrence_timeframe",
                // "recurrence_basedate",
                // "reference",
                // "tags",
                // "date_started",
              ] +
              ((taskModel.dateDue == null || taskModel.dateDue == 0)
                  ? []
                  : ["date_due"])));

  static Future<bool> updateComment(CommentModel model) async =>
      setApi("updateComment", 496470023,
          params: {"id": model.id, "content": model.comment});

  static Future<bool> updateSubtask(SubtaskModel subtaskModel) async =>
      setApi("updateSubtask", 191749979,
          params: subtaskModel.toJsonWithKeys([
            "id",
            "task_id",
            "title",
            "user_id",
            "time_estimated",
            "time_spent",
            "status",
          ]));

  // Additional Updates

  static Future<bool> enableProject(int id) async =>
      setApi("enableProject", 1775494839, params: {"project_id": id});

  static Future<bool> disableProject(int id) async =>
      setApi("disableProject", 1734202312, params: {"project_id": id});

  static Future<bool> saveProjectMetadata(
          int projectId, ProjectMetadataModel projectMetadataModel) async =>
      setApi("saveProjectMetadata", 1797076613, params: {
        "project_id": projectId,
        "values": projectMetadataModel.toJson()
      });

  static Future<bool> saveTaskMetadata(
          int taskId, TaskMetadataModel taskMetadata) async =>
      setApi("saveTaskMetadata", 133280317,
          params: [taskId, taskMetadata.toJson()]);

  static Future<bool> openTask(int id) async =>
      setApi("openTask", 1888531925, params: {"task_id": id});

  static Future<bool> closeTask(int id) async =>
      setApi("closeTask", 1654396960, params: {"task_id": id});

  // Delete

  static Future<bool> removeProject(int id) async =>
      setApi("removeProject", 46285125, params: {"project_id": id});

  static Future<bool> removeColumn(int id) async =>
      setApi("removeColumn", 1433237746, params: {"column_id": id});

  static Future<bool> removeTask(int id) async =>
      setApi("removeTask", 1423501287, params: {"task_id": id});

  static Future<bool> removeComment(int id) async =>
      setApi("removeComment", 328836871, params: {"comment_id": id});

  static Future<bool> removeSubtask(int id) async =>
      setApi("removeSubtask", 1382487306, params: {"subtask_id": id});

  // Delete multiple
  // TODO
  static Future<Iterable<bool>> removeAllTasks(Iterable<int> ids) async =>
      setMultiApi("removeTask", 1423501287,
          multiParams: ids.map((id) => {"task_id": id}));

  //////////////////////////////////// GETTER //////////////////////////////////
  //
  // static Future<List<ProjectModel>> getmyProjects() async =>
  //     listApi("getmyProjects", 2134420212, ProjectModel.fromJson);

  static Future<List<dynamic>> getAllProjects() async =>
      await baseApi("getAllProjects", 2134420212) as List<dynamic>;

  static Future<List<BoardModel>> getBoard(int projectId) async {
    if (projectId < 0) {
      return Future.error("getBoard: Invalid project id: $projectId");
    }
    return listApi("getBoard", 827046470, BoardModel.fromJson,
        params: {"project_id": projectId});
  }

  static Future<List<dynamic>> getColumns(int projectId) async {
    if (projectId < 0) {
      return Future.error("getColumns: Invalid project id: $projectId");
    }
    return await baseApi("getColumns", 887036325,
        params: {"project_id": projectId}) as List<dynamic>;
  }

  static Future<List<dynamic>> getAllTasks(int projectId, int isActive) async {
    if (projectId < 0) {
      return Future.error("getAllTasks: Invalid project id: $projectId");
    }
    return await baseApi("getAllTasks", 133280317,
            params: {"project_id": projectId, "status_id": isActive})
        as List<dynamic>;
  }

  static Future<List<dynamic>> getAllSubtasks(int taskId) async {
    if (taskId < 0) {
      return Future.error("getAllSubtasks: Invalid task id: $taskId");
    }
    return await baseApi("getAllSubtasks", 2087700490,
        params: {"task_id": taskId}) as List<dynamic>;
  }

  static Future<List<dynamic>> getAllComments(int taskId) async {
    if (taskId < 0) {
      return Future.error("getAllComments: Invalid task id: $taskId");
    }
    return await baseApi("getAllComments", 148484683,
        params: {"task_id": taskId}) as List<dynamic>;
  }

  // TODO: Use for mutliple checklist, shopping list
  static Future<dynamic> getTaskMetadata(int taskId) async {
    if (taskId < 0) {
      return Future.error("getTaskMetadata: Invalid task id: $taskId");
    }
    return baseApi("getTaskMetadata", 133280317, params: {"task_id": taskId});
  }

  static Future<ProjectMetadataModel> getProjectMetadata(int projectId) async {
    return singleApi("getProjectMetadata", 1797076613, ProjectMetadataModel.fromJson,
        params: {"project_id": projectId});
  }

  static Future<Map<String, dynamic>> getTask(int taskId, int projectId) async {
    dynamic values = await Future.wait([
      _getTask(taskId),
      _searchTasks(params: {"project_id": projectId, "query": "id:$taskId"})
    ]);
    Map<String, dynamic> searchResult = (values[1] as List<dynamic>).first;
    var mergedValues = (values[0] as Map<String, dynamic>);
    mergedValues.addAll(searchResult);
    return mergedValues;
    // var task = TaskModel.fromJson(mergedValues);
    // return task;
  }

  static Future<dynamic> _getTask(int taskId) async =>
      baseApi("getTask", 700738119, params: {"task_id": taskId});

  /* Search queries:
  title, desc, comment
  TODO: checklist, subtask
   */
  static Future<List<TaskModel>> searchTasks(
      int projectId, String query) async {
    var values = await Future.wait([
      _searchTasks(params: {"project_id": projectId, "query": "title:$query"}),
      _searchTasks(
          params: {"project_id": projectId, "query": "description:$query"}),
      _searchTasks(
          params: {"project_id": projectId, "query": "comment:$query"}),
    ]);
    List<TaskModel> tasks = [];
    for (var tasksJsonList in values) {
      for (var taskJson in tasksJsonList) {
        tasks.add(TaskModel.fromJson(taskJson));
      }
    }
    return tasks;
  }

  static Future<dynamic> _searchTasks({dynamic params = const {}}) async =>
      baseApi("searchTasks", 1468511716, params: params);

  //////////////////////////////////// API //////////////////////////////////

  static String setApiParams<T>(String method, int id,
      {dynamic params = const {}}) {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": method,
      "id": id,
      "params": params
    };
    return json.encode(parameters);
  }

  static Future<Iterable<T>> setMultiApi<T>(String method, int id,
      {Iterable<dynamic> multiParams = const []}) async {
    return await baseMultiApi(method, id, multiParams: multiParams);
  }

  static Future<T> setApi<T>(String method, int id,
      {dynamic params = const {}}) async {
    return await baseApi(method, id, saveCache: true, params: params) as T;
  }

  static Future<T> singleApi<T extends Model>(
      String method, int id, T Function(Map<String, dynamic>) constructor,
      {Map<String, dynamic> params = const {}}) async {
    final dynamic result =
        await baseApi(method, id, params: params) as Map<String, dynamic>;
    return constructor(result);
  }

  static Future<List<T>> listApi<T extends Model>(
      String method, int id, T Function(Map<String, dynamic>) constructor,
      {Map<String, dynamic> params = const {}}) async {
    final results = await baseApi(method, id, params: params) as List<dynamic>;
    final List<T> models = [];
    for (var data in results) {
      final model = constructor(data);
      models.add(model);
    }
    return models;
  }

  static Future<List<T>> baseMultiApi<T>(String method, int id,
      {Iterable<dynamic> multiParams = const []}) async {
    var parameters = multiParams
        .map((params) =>
            {"jsonrpc": "2.0", "method": method, "id": id, "params": params})
        .toList();
    // log("Multi base api, params: $parameters");
    final credentials = "${AppData.username}:${AppData.password}";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    final resp = await http.post(
      Uri.parse(AppData.endpoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
      encoding: Encoding.getByName("utf-8"),
    );
    List<dynamic> decodedDataList = json.decode(utf8.decode(resp.bodyBytes));
    // log("Multi base api, decodedData: ${utf8.decode(resp.bodyBytes)}");
    // log("Multi base api, decodedData: $decodedData");
    return decodedDataList
        .map<T>((decodedData) => decodedData['result'])
        .toList();
  }

  static dynamic baseApi<T extends Model>(String method, int id,
      {bool saveCache = false, dynamic params = const {}}) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": method,
      "id": id,
      "params": params
    };
    // log("Base api, params: $parameters");
    final credentials = "${AppData.username}:${AppData.password}";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    final jsonData = json.encode(parameters);
    // log("jsonStr: $jsonData");
    // log("creds: $credentials, ${AppData.endpoint}");
    // log("creds: $encoded");
    final http.Response resp;
    try {
      resp = await http.post(
        Uri.parse(AppData.endpoint),
        headers: <String, String>{"Authorization": "Basic $encoded"},
        body: jsonData,
        encoding: Encoding.getByName("utf-8"),
      );
    } on SocketException catch (e) {
      return Future.error("Couldn't connect to server");
    } on Exception catch (e) {
      return Future.error("Couldn't connect to server: ${e.toString()}");
    }
    // TODO: other errors?
    if (saveCache && resp.statusCode != 200) {
      log("save cache");
    }

    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    // log("decodedData: ${utf8.decode(resp.bodyBytes)}");
    // log("baseapi: $params, decodedData: $decodedData");
    if (resp.statusCode != 200) {
      log("baseapi: $params, decodedData: $decodedData");
    }

    if (decodedData['error'] != null) return Future.error(decodedData['error']);
    return decodedData['result'];
  }

  static dynamic api(ApiStorageModelData apiData) async {
    final params = apiData.webApiParams
        // .replaceAll("\"$apiProjectUpdateId\"", apiData.updateId.toString())
        // .replaceAll("\"$apiColumnUpdateId\"", apiData.updateId.toString()
        // TODO: with create task
        ;
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": apiData.apiName,
      "id": apiData.apiId,
      "params": json.decode(params)
    };
    log("api, params: ${apiData.webApiParams} => $params");
    final credentials = "${AppData.username}:${AppData.password}";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    // log("creds: $credentials, ${AppData.endpoint}");
    // log("creds: $encoded");
    log("parameters: $parameters");
    final resp = await http.post(
      Uri.parse(AppData.endpoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
      encoding: Encoding.getByName("utf-8"),
    );
    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    // log("decodedData: ${utf8.decode(resp.bodyBytes)}");
    if (resp.statusCode != 200) {
      log("api: $params, decodedData: $decodedData");
    }

    if (decodedData['error'] != null) return Future.error(decodedData['error']);
    return decodedData['result'];
  }

  static Future<bool> handleApiRequest(
      WidgetRef ref, ApiStorageModelData apiData) async {
    final dynamic result = await api(apiData);
    final apiDao = ref.read(AppDatabase.provider).apiStorageDao;
    // All creation APIs result in int or bool
    if (result is int) {
      log("handleApiRequest: creation API; ${apiData.apiName}");
      if (apiData.apiId == WebApiModel.createProject.apiId) {
        log("handleApiRequest: create proj");
        // update project dao, with id
        ref
            .read(AppDatabase.provider)
            .projectDao
            .updateId(apiData.updateId, result);
        ref
            .read(AppDatabase.provider)
            .columnDao
            .updateProjectId(apiData.updateId, result);
        ref
            .read(AppDatabase.provider)
            .taskDao
            .updateProjectId(apiData.updateId, result);
        log("handleApiRequest: update id ${apiData.updateId} => $result");
        // TODO: outside, if successful
        apiDao.removeApiTask(apiData.id);
        var projectModel = ref.read(activeProject);
        if (projectModel != null && projectModel.id == apiData.updateId) {
          ref.read(activeProject.notifier).state =
              projectModel.copyWith(id: result);
          log("Update active proj: ${apiData.updateId} => $result");
        }
      } else if (apiData.apiId == WebApiModel.addColumn.apiId) {
        log("handleApiRequest: addColumn");
        ref
            .read(AppDatabase.provider)
            .columnDao
            .updateId(apiData.updateId, result);
        ref
            .read(AppDatabase.provider)
            .taskDao
            .updateColumnId(apiData.updateId, result);
        log("handleApiRequest: update id ${apiData.updateId} => $result");
        apiDao.removeApiTask(apiData.id);
      } else if (apiData.apiId == WebApiModel.createTask.apiId) {
        log("handleApiRequest: createTask: ${apiData.updateId}, ${apiData.webApiParams}");
        ref
            .read(AppDatabase.provider)
            .taskDao
            .updateId(apiData.updateId, result);
        log("handleApiRequest: update task id ${apiData.updateId} => $result");
        apiDao.removeApiTask(apiData.id);
      }
      // NOTE: Only creation needs updating, internal `updateId`
      apiDao.updateApiTask(apiData.updateId, result, apiData);
    } else if (result is bool) {
      if (result) {
        apiDao.removeApiTask(apiData.id);
      } else {
        log("Failed to finish task: ${apiData.apiName}, ${apiData.webApiParams}");
        return false;
      }
    }
    return false;
  }
}
