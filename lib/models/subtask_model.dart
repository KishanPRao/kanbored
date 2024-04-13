import 'dart:convert';
import 'package:kanbored/models/model.dart';

SubtaskModel subtaskModelFromJson(String str) =>
    SubtaskModel.fromJson(json.decode(str));

String subtaskModelToJson(SubtaskModel data) => json.encode(data.toJson());

class SubtaskModel implements Model {
  static const kStatusTodo = 0;
  static const kStatusInProgress = 1;
  static const kStatusFinished = 2;

  SubtaskModel({
    required this.id,
    required this.title,
    required this.status,
    required this.timeEstimated,
    required this.timeSpent,
    required this.taskId,
    required this.userId,
    required this.position,
    required this.username,
    required this.name,
    required this.timerStartDate,
    required this.statusName,
    required this.isTimerStarted,
  });

  int id;
  String title;
  int status;
  int timeEstimated;
  int timeSpent;
  int taskId;
  int userId;
  int position; // TODO: use position info! Needed while reading or default sorted
  String? username;
  String? name;
  int timerStartDate;
  String statusName;
  bool isTimerStarted;

  factory SubtaskModel.fromJson(Map<String, dynamic> json) => SubtaskModel(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        timeEstimated: json["time_estimated"],
        timeSpent: json["time_spent"],
        taskId: json["task_id"],
        userId: json["user_id"],
        position: json["position"],
        username: json["username"],
        name: json["name"],
        timerStartDate: json["timer_start_date"],
        statusName: json["status_name"],
        isTimerStarted: json["is_timer_started"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "time_estimated": timeEstimated,
        "time_spent": timeSpent,
        "task_id": taskId,
        "user_id": userId,
        "position": position,
        "username": username,
        "name": name,
        "timer_start_date": timerStartDate,
        "status_name": statusName,
        "is_timer_started": isTimerStarted,
      };

  @override
  String toString() => toJson().toString();
}
