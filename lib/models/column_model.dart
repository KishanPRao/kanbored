// To parse this JSON data, do
//
//     final columnModel = columnModelFromJson(jsonString);

import 'dart:convert';

import 'package:kanbored/models/model.dart';
import 'package:kanbored/models/task_model.dart';

ColumnModel columnModelFromJson(String str) =>
    ColumnModel.fromJson(json.decode(str));

String columnModelToJson(ColumnModel data) => json.encode(data.toJson());

class ColumnModel extends Model {
  ColumnModel({
    required this.id,
    required this.title,
    required this.position,
    required this.taskLimit,
    required this.description,
    required this.hideInDashboard,
    required this.projectId,
    required this.nbOpenTasks,
    required this.nbClosedTasks,
    required this.nbTasks,
    required this.score,
    required this.tasks,
    required this.columnNbTasks,
    required this.columnScore,
    required this.columnNbScore,
    required this.columnNbOpenTasks,
  });

  int id;
  String title;
  int position;
  int taskLimit;
  String description;
  int hideInDashboard;
  int projectId;
  int nbOpenTasks;
  int nbClosedTasks;
  int nbTasks;
  int score;
  List<TaskModel> tasks;
  int columnNbTasks;
  int columnScore;
  int columnNbScore;
  int columnNbOpenTasks;

  List<TaskModel> get activeTasks => tasks.where((t) => t.isActive == 1).toList();

  List<TaskModel> get inactiveTasks => tasks.where((t) => t.isActive == 0).toList();

  factory ColumnModel.fromJson(Map<String, dynamic> json) => ColumnModel(
        id: json["id"],
        title: json["title"],
        position: json["position"],
        taskLimit: json["task_limit"],
        description: json["description"],
        hideInDashboard: json["hide_in_dashboard"],
        projectId: json["project_id"],
        nbOpenTasks: json["nb_open_tasks"],
        nbClosedTasks: json["nb_closed_tasks"],
        nbTasks: json["nb_tasks"],
        score: json["score"],
        tasks: (json["tasks"] as List<dynamic>)
            .map((e) => TaskModel.fromJson(e))
            .toList(),
        columnNbTasks: json["column_nb_tasks"],
        columnScore: json["column_score"],
        columnNbScore: json["column_nb_score"],
        columnNbOpenTasks: json["column_nb_open_tasks"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "position": position,
        "task_limi": taskLimit,
        "description": description,
        "hide_in_dashboard": hideInDashboard,
        "project_id": projectId,
        "nb_open_tasks": nbOpenTasks,
        "nb_closed_tasks": nbClosedTasks,
        "nb_tasks": nbTasks,
        "score": score,
        "tasks": tasks.map((e) => e.toJson()),
        "column_nb_tasks": columnNbTasks,
        "column_score": columnScore,
        "column_nb_score": columnNbScore,
        "column_nb_open_tasks": columnNbOpenTasks,
      };

  List<Model> filter(String query) {
    List<Model> filtered = [];
    if (query.isEmpty) return filtered;
    query = query.toLowerCase();
    if (title.toLowerCase().contains(query)) {
      filtered.add(this);
    }
    filtered.addAll(tasks.expand((t) => t.filter(query)));
    return filtered;
  }
}
