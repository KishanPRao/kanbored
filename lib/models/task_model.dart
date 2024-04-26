// To parse this JSON data, do
//
//     final taskModel = taskModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kanbored/models/model.dart';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel extends Model {
  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateCreation,
    required this.colorId,
    required this.projectId,
    required this.columnId,
    required this.ownerId,
    required this.position,
    required this.isActive,
    required this.dateCompleted,
    required this.score,
    required this.dateDue,
    required this.categoryId,
    required this.creatorId,
    required this.dateModification,
    required this.reference,
    required this.dateStarted,
    required this.timeSpent,
    required this.timeEstimated,
    required this.swimlaneId,
    required this.dateMoved,
    required this.recurrenceStatus,
    required this.recurrenceTrigger,
    required this.recurrenceFactor,
    required this.recurrenceTimeframe,
    required this.recurrenceBasedate,
    required this.recurrenceParent,
    required this.recurrenceChild,
    required this.priority,
    // required this.nbComments,
    // required this.nbFiles,
    // required this.nbLinks,
    // required this.nbExternalLinks,
    // required this.nbSubtasks,
    // required this.nbCompletedSubtasks,
  });

  int id;
  String title;
  String description;
  int dateCreation;
  String colorId;
  int projectId;
  int columnId;
  int ownerId;
  int position;
  int isActive;
  int? dateCompleted;
  int? score;
  int? dateDue;
  int categoryId;
  int creatorId;
  int? dateModification;
  String? reference;
  int? dateStarted;
  int? timeSpent;
  int? timeEstimated;
  int swimlaneId = 0;
  int dateMoved;
  int recurrenceStatus;
  int recurrenceTrigger;
  int recurrenceFactor;
  int recurrenceTimeframe;
  int recurrenceBasedate;
  int? recurrenceParent;
  int? recurrenceChild;
  int priority;
  // int nbComments;
  // int nbFiles;
  // int nbLinks;
  // int nbExternalLinks;
  // int nbSubtasks;
  // int nbCompletedSubtasks;

  Map<String, Color> taskColors = {
    "yellow": Colors.yellow.shade600,
    "blue": Colors.blue,
    "green": Colors.green,
    "purple": Colors.purple,
    "red": Colors.red,
    "orange": Colors.orange,
    "grey": Colors.grey,
    "brown": Colors.brown,
    "deep_orange": Colors.deepOrange,
    "dark_grey": Colors.grey.shade900,
    "pink": Colors.pink,
    "teal": Colors.teal,
    "cyan": Colors.cyan,
    "lime": Colors.lime,
    "light_green": Colors.lightGreen,
    "amber": Colors.amber,
  };

  Map<Color, String> taskColorsName = {
    Colors.yellow: "yellow",
    Colors.blue: "blue",
    Colors.green: "green",
    Colors.purple: "purple",
    Colors.red: "red",
    Colors.orange: "orange",
    Colors.grey: "grey",
    Colors.brown: "brown",
    Colors.deepOrange: "deep_orange",
    Colors.pink: "pink",
    Colors.teal: "teal",
    Colors.cyan: "cyan",
    Colors.lime: "lime",
    Colors.lightGreen: "light_green",
    Colors.amber: "amber",
  };

  List<ColorSwatch> taskColorsList = [
    Colors.yellow,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.red,
    Colors.orange,
    Colors.grey,
    Colors.brown,
    Colors.deepOrange,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.lime,
    Colors.lightGreen,
    Colors.amber,
  ];

  Color getTaskColor(String colorName) {
    return taskColors[colorName] ?? Colors.blue;
  }

  String getTaskColorName(Color color) {
    return taskColorsName[color] ?? "blue";
  }

  List<ColorSwatch> getTaskColorsList() {
    return taskColorsList;
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        dateCreation: json["date_creation"],
        colorId: json["color_id"],
        projectId: json["project_id"],
        columnId: json["column_id"],
        ownerId: json["owner_id"],
        position: json["position"],
        isActive: json["is_active"],
        dateCompleted: json["date_completed"],
        score: json["score"],
        dateDue: json["date_due"],
        categoryId: json["category_id"],
        creatorId: json["creator_id"],
        dateModification: json["date_modification"],
        reference: json["reference"],
        dateStarted: json["date_started"],
        timeSpent: json["time_spent"],
        timeEstimated: json["time_estimated"],
        swimlaneId: json["swimlane_id"],
        dateMoved: json["date_moved"],
        recurrenceStatus: json["recurrence_status"],
        recurrenceTrigger: json["recurrence_trigger"],
        recurrenceFactor: json["recurrence_factor"],
        recurrenceTimeframe: json["recurrence_timeframe"],
        recurrenceBasedate: json["recurrence_basedate"],
        recurrenceParent: json["recurrence_parent"],
        recurrenceChild: json["recurrence_child"],
        priority: json["priority"],
        // nbComments: json["nb_comments"],
        // nbFiles: json["nb_files"],
        // nbLinks: json["nb_links"],
        // nbExternalLinks: json["nb_external_links"],
        // nbSubtasks: json["nb_subtasks"],
        // nbCompletedSubtasks: json["nb_completed_subtasks"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "date_creation": dateCreation,
        "color_id": colorId,
        "project_id": projectId,
        "column_id": columnId,
        "owner_id": ownerId,
        "position": position,
        "is_active": isActive,
        "date_completed": dateCompleted,
        "score": score,
        "date_due": dateDue,
        "category_id": categoryId,
        "creator_id": creatorId,
        "date_modification": dateModification,
        "reference": reference,
        "date_started": dateStarted,
        "time_spent": timeSpent,
        "time_estimated": timeEstimated,
        "swimlane_id": swimlaneId,
        "date_moved": dateMoved,
        "recurrence_status": recurrenceStatus,
        "recurrence_trigger": recurrenceTrigger,
        "recurrence_factor": recurrenceFactor,
        "recurrence_timeframe": recurrenceTimeframe,
        "recurrence_basedate": recurrenceBasedate,
        "recurrence_parent": recurrenceParent,
        "recurrence_child": recurrenceChild,
        "priority": priority,
        // "nb_comments": nbComments,
        // "nb_files": nbFiles,
        // "nb_links": nbLinks,
        // "nb_external_links": nbExternalLinks,
        // "nb_subtasks": nbSubtasks,
        // "nb_completed_subtasks": nbCompletedSubtasks,
      };

  List<Model> filter(String query) {
    List<Model> filtered = [];
    if (query.isEmpty) return filtered;
    query = query.toLowerCase();
    if (title.toLowerCase().contains(query) ||
        description.toLowerCase().contains(query)) {
      filtered.add(this);
    }
    // TODO: subtask, comment
    return filtered;
  }
}
