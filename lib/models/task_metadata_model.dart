import 'dart:convert';
import 'dart:developer';
import 'package:kanbored/models/model.dart';

TaskMetadataModel taskMetadataModelFromJson(String str) =>
    TaskMetadataModel.fromJson(json.decode(str));

String taskMetadataModelToJson(TaskMetadataModel data) =>
    json.encode(data.toJson());

class CheckListItemMetadata extends Model {
  CheckListItemMetadata({
    required this.id,
  });

  int id;

  factory CheckListItemMetadata.fromJson(Map<String, dynamic> json) =>
      CheckListItemMetadata(
        id: json["id"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
      };

  @override
  String toString() => toJson().toString();
}

class CheckListMetadata extends Model {
  // NOTE: `position` starts with 1.
  CheckListMetadata({
    required this.name,
    required this.position,
    required this.items,
  });

  String name;
  int position;
  List<CheckListItemMetadata> items;

  factory CheckListMetadata.fromJson(Map<String, dynamic> json) =>
      CheckListMetadata(
        name: json["name"],
        position: json["position"],
        items: (json["items"] as List<dynamic>)
            .map((e) => CheckListItemMetadata.fromJson(e))
            .toList(),
      );

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "position": position,
        "items": items.map((e) => e.toJson()).toList() as List<dynamic>,
      };

  @override
  String toString() => toJson().toString();
}

class TaskMetadataModel extends Model {
  TaskMetadataModel({
    required this.checklists,
  });

  List<CheckListMetadata> checklists = [];

  factory TaskMetadataModel.fromJson(Map<String, dynamic> json) =>
      TaskMetadataModel(
          checklists: json["metadata"] != null
              ? (jsonDecode(json["metadata"])["checklists"] as List<dynamic>)
                  .map((e) => CheckListMetadata.fromJson(e))
                  .toList()
              : []);

  @override
  Map<String, dynamic> toJson() => {
        "metadata": jsonEncode({
          "checklists":
              checklists.map((e) => e.toJson()).toList() as List<dynamic>
        }),
      };

  @override
  String toString() => toJson().toString();
}
