import 'dart:developer';

class Model {
  factory Model.fromJson(Map<String, dynamic> json) {
    return Model();
  }
  Model();

  dynamic toJson() => {};

  @override
  String toString() => toJson().toString();
}

extension ModelExtension on Model {
  dynamic toJsonWithKeys(List<String> keys) {
    dynamic jsonData = toJson();
    if (jsonData is Map<String, dynamic>) {
      jsonData.removeWhere((key, value) => !keys.contains(key));
      return jsonData;
    } else {
      log("Other");
    }
    return jsonData;
  }
}
