// To parse this JSON data, do
//
//     final projectModel = projectModelFromJson(jsonString);

import 'dart:convert';

import 'package:kanbored/models/model.dart';

ProjectModel projectModelFromJson(String str) =>
    ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

class ProjectModel implements Model {
  ProjectModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.token,
    required this.lastModified,
    required this.isPublic,
    required this.isPrivate,
    required this.description,
    required this.identifier,
    required this.startDate,
    required this.endDate,
    required this.ownerId,
    required this.priorityDefault,
    required this.priorityStart,
    required this.priorityEnd,
    required this.email,
    required this.predefinedEmailSubjects,
    required this.perSwimlaneTaskLimits,
    required this.taskLimit,
    required this.enableGlobalTags,
    required this.isTrelloImported,
    required this.url,
  });

  int id;
  String name;
  bool isActive;
  String token;
  int lastModified;
  int isPublic;
  int isPrivate;
  String? description;
  String identifier;
  String startDate;
  String endDate;
  int ownerId;
  int priorityDefault;
  int priorityStart;
  int priorityEnd;
  String? email;
  String? predefinedEmailSubjects;
  int perSwimlaneTaskLimits;
  int taskLimit;
  int enableGlobalTags;
  Url url;
  int isTrelloImported;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json["id"],
        name: json["name"],
        isActive: json["is_active"] == 1,
        token: json["token"],
        lastModified: json["last_modified"],
        isPublic: json["is_public"],
        isPrivate: json["is_private"],
        description: json["description"],
        identifier: json["identifier"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        ownerId: json["owner_id"],
        priorityDefault: json["priority_default"],
        priorityStart: json["priority_start"],
        priorityEnd: json["priority_end"],
        email: json["email"],
        predefinedEmailSubjects: json["predefined_email_subjects"],
        perSwimlaneTaskLimits: json["per_swimlane_task_limits"],
        taskLimit: json["task_limit"],
        enableGlobalTags: json["enable_global_tags"],
        isTrelloImported: json["is_trello_imported"],
        url: Url.fromJson(json["url"]),

      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_active": isActive ? 1 : 0,
        "token": token,
        "last_modified": lastModified,
        "is_public": isPublic,
        "is_private": isPrivate,
        "description": description,
        "identifier": identifier,
        "start_date": startDate,
        "end_date": endDate,
        "owner_id": ownerId,
        "priority_default": priorityDefault,
        "priority_start": priorityStart,
        "priority_end": priorityEnd,
        "email": email,
        "predefined_email_subjects": predefinedEmailSubjects,
        "per_swimlane_task_limits": perSwimlaneTaskLimits,
        "task_limit": taskLimit,
        "enable_global_tags": enableGlobalTags,
        "is_trello_imported": isTrelloImported,
        "url": url.toJson(),
      };
}

class Url {
  Url({
    required this.board,
    required this.list,
    required this.calendar,
  });

  String board;
  String list;
  String? calendar;

  factory Url.fromJson(Map<String, dynamic> json) => Url(
        board: json["board"],
        list: json["list"],
        calendar: json["calendar"],
      );

  Map<String, dynamic> toJson() => {
        "board": board,
        "list": list,
        "calendar": calendar,
      };
}
