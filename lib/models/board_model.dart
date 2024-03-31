import 'dart:convert';
import 'package:kanbored/models/column_model.dart';
import 'package:kanbored/models/model.dart';

BoardModel boardModelFromJson(String str) =>
    BoardModel.fromJson(json.decode(str));

String boardModelToJson(BoardModel data) => json.encode(data.toJson());

class BoardModel implements Model {
  BoardModel({
    required this.id,
    required this.name,
    required this.position,
    required this.isActive,
    required this.projectId,
    required this.description,
    required this.taskLimit,
    required this.columns,
    required this.nbSwimlanes,
    required this.nbColumns,
    required this.nbTasks,
    required this.score,
  });

  int id;
  String name;
  int position;
  int isActive;
  int projectId;
  String description;
  int taskLimit;
  List<ColumnModel> columns;
  int nbSwimlanes;
  int nbColumns;
  int nbTasks;
  int score;

  factory BoardModel.fromJson(Map<String, dynamic> json) => BoardModel(
        id: json["id"],
        name: json["name"],
        position: json["position"],
        isActive: json["is_active"],
        projectId: json["project_id"],
        description: json["description"],
        taskLimit: json["task_limit"],
        columns: (json["columns"] as List<dynamic>)
            .map((e) => ColumnModel.fromJson(e))
            .toList(),
        nbSwimlanes: json["nb_swimlanes"],
        nbColumns: json["nb_columns"],
        nbTasks: json["nb_tasks"],
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "position": position,
        "isActive": isActive,
        "project_id": projectId,
        "description": description,
        "task_limit": taskLimit,
        "columns": columns.map((e) => e.toJson()),
        "nb_swimlanes": nbSwimlanes,
        "nb_columns": nbColumns,
        "nb_tasks": nbTasks,
        "score": score,
      };
}
