import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kanbored/app_data.dart';

class Authenticator {
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
      "method": "getmyProjects",
      "id": 2134420212
    };
    final credentials = "$username:$password";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);
    final resp = await http.post(
      Uri.parse(endpoint),
      headers: <String, String>{"Authorization": "Basic $encoded"},
      body: json.encode(parameters),
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
    AppData.password = password;
    AppData.username = username;
    AppData.url = url;
    AppData.endpoint = endpoint;
    final myUser = await getMe();
    AppData.userId = myUser["id"];
    AppData.appRole = myUser["role"];
    AppData.authenticated = true;
    return true;
  }

  static Future getMe() async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getMe",
      "id": 1718627783
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
    if (decodedData['error'] != null) return Future.error(decodedData['error']);
    return decodedData['result'];
  }

  static Future<int> getUserIdByName(String username) async {
    final Map<String, dynamic> parameters = {
      "jsonrpc": "2.0",
      "method": "getUserByName",
      "id": 1769674782,
      "params": {"username": username}
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
    if (decodedData == null || decodedData['result'] == null) return 0;
    if (decodedData['error'] != null) return Future.error(decodedData['error']);
    int result = decodedData['result']['id'];
    return (result > 0) ? result : 0;
  }
}
