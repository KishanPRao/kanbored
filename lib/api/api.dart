import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kanbored/app_data.dart';
import 'package:kanbored/models/model.dart';
import 'package:kanbored/models/project_model.dart';

class Api {
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
            'Unknown Error! Please, try again or contact your administrator'
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

  // static Future getMe() async => baseApi("getMe", 1718627783);
  // static Future getMyDashboard() async => baseApi("getMyDashboard", 447898718);
  // static Future getMyProjectsList() async => baseApi("getMyProjectsList", 987834805);
  static Future<List<ProjectModel>> getmyProjects() async =>
      baseApi("getmyProjects", 2134420212, ProjectModel.fromJson);

  static Future<List<T>> baseApi<T extends Model>(String method, int id,
      T Function(Map<String, dynamic>) constructor) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": method,
      "id": id
    };
    final credentials = "${AppData.username}:${AppData.password}";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    final resp = await http.post(
      Uri.parse(AppData.endpoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
      encoding: Encoding.getByName("utf-8"),
    );

    final decodedData = json.decode(utf8.decode(resp.bodyBytes));
    print("decodedData: ${decodedData}");

    if (decodedData['error'] != null) return Future.error(decodedData['error']);
    final List<dynamic> results = decodedData['result'];
    final List<T> models = [];
    for (var data in results) {
      final model = constructor(data);
      models.add(model);
    }
    return models;
  }
}
