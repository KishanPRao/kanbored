import 'dart:developer';

class Model {
  factory Model.fromJson(Map<String, dynamic> json) {
    return Model();
  }

  dynamic toJson() => {};

  Model();
}

extension ModelExtension on Model {
  dynamic toJsonWithKeys(List<String> keys) {
    dynamic jsonData = toJson();
    if (jsonData is Map<String, dynamic>) {
      log("Map");
      jsonData.removeWhere((key, value) => !keys.contains(key));
      return jsonData;
    } else {
      log("Other");
    }
    return jsonData;
  }
}
