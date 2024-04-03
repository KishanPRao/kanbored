import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kanbored/app_data.dart';
import 'package:kanbored/models/board_model.dart';
import 'package:kanbored/models/comment_model.dart';
import 'package:kanbored/models/model.dart';
import 'package:kanbored/models/project_model.dart';
import 'dart:developer';

import 'package:kanbored/models/subtask_model.dart';
import 'package:kanbored/models/task_metadata_model.dart';

class Api {
  static Future<bool> login(
      String url, String username, String password) async {
    final resp = await http.post(
      Uri.parse("$url/users/login"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'username': username,
        'password': password,
      }),
      encoding: Encoding.getByName("utf-8"),
    );
    log("Resp: ${resp.body}, ${resp.headers}");
    if (resp.statusCode != 200) {
      Map<String, String> error = {
        'message':
            'Unknown Error! Please, check your credentials and access permission! Status: ${resp.statusCode}'
      };
      return Future.error(error);
    }

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
    AppData.url = url;
    AppData.username = username;
    AppData.password = password;
    AppData.userId = decodedData["id"];
    AppData.token = decodedData["token"];
    AppData.tokenExpires = decodedData["tokenExpires"];
    AppData.authenticated = true;
    return true;
  }

  // static Future getMe() async => baseApi("getMe", 1718627783);
  // static Future getMyDashboard() async => baseApi("getMyDashboard", 447898718);
  // static Future getMyProjectsList() async => baseApi("getMyProjectsList", 987834805);
  // static Future<List<ProjectModel>> getmyProjects() async =>
  //     listApi("getmyProjects", 2134420212, ProjectModel.fromJson);
  //
  // static Future<List<BoardModel>> getBoard(int projectId) async =>
  //     listApi("getBoard", 827046470, BoardModel.fromJson,
  //         params: {"project_id": projectId});
  //
  // static Future<List<SubtaskModel>> getAllSubtasks(int taskId) async =>
  //     listApi("getAllSubtasks", 2087700490, SubtaskModel.fromJson,
  //         params: {"task_id": taskId});
  //
  // static Future<List<CommentModel>> getAllComments(int taskId) async =>
  //     listApi("getAllComments", 148484683, CommentModel.fromJson,
  //         params: {"task_id": taskId});
  //
  // // TODO: Use for mutliple checklist, shopping list
  // static Future<TaskMetadataModel> getTaskMetadata(int taskId) async =>
  //     singleApi("getTaskMetadata", 133280317, TaskMetadataModel.fromJson,
  //         params: {"task_id": taskId});


  static Future<List<BoardModel>> getAllBoards() async =>
      listApi("/api/boards", 2134420212, BoardModel.fromJson);

  static Future<T> singleApi<T extends Model>(
      String method, int id, T Function(Map<String, dynamic>) constructor,
      {Map<String, Object> params = const {}}) async {
    final dynamic result =
        await baseApi(method, id, constructor, params: params)
            as Map<String, dynamic>;
    return constructor(result);
  }

  static Future<List<T>> listApi<T extends Model>(
      String apiPath, int id, T Function(Map<String, dynamic>) constructor,
      {Map<String, Object> params = const {}}) async {
    final results =
        await baseApi(apiPath, id, constructor, params: params) as List<dynamic>;
    final List<T> models = [];
    for (var data in results) {
      final model = constructor(data);
      models.add(model);
    }
    return models;
  }

  static dynamic baseApi<T extends Model>(
      String apiPath, int id, T Function(Map<String, dynamic>) constructor,
      {Map<String, Object> params = const {}}) async {
    // final credentials = "${AppData.username}:${AppData.password}";
    final resp = await http.get(
      Uri.parse("${AppData.url}$apiPath"),
      headers: {"Accept": "application/json", "Authorization" : AppData.token},
      // encoding: Encoding.getByName("utf-8"),
    );

    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    // log("decodedData: $decodedData");

    if (decodedData['error'] != null) return Future.error(decodedData['error']);
    return decodedData['result'];
  }
}
