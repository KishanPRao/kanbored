import 'dart:convert';
import 'package:kanbored/models/model.dart';

ProjectMetadataModel projectMetadataModelFromJson(String str) =>
    ProjectMetadataModel.fromJson(json.decode(str));

String projectMetadataModelToJson(ProjectMetadataModel data) =>
    json.encode(data.toJson());

class ProjectMetadataModel implements Model {
  ProjectMetadataModel({
    required this.closedColumns,
  });
  List<int> closedColumns;

  factory ProjectMetadataModel.fromJson(Map<String, dynamic> json) {
    return ProjectMetadataModel(
      closedColumns: json["metadata"] != null
          ? List<int>.from(jsonDecode(json["metadata"])["closed_columns"])
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "metadata": jsonEncode({"closed_columns": closedColumns}),
      };
}
