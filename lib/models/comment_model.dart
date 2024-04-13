import 'dart:convert';
import 'package:kanbored/models/model.dart';

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel implements Model {
  CommentModel({
    required this.id,
    required this.dateCreation,
    required this.dateModification,
    required this.taskId,
    required this.userId,
    required this.comment,
    required this.username,
    required this.name,
    required this.email,
    required this.avatarPath,
  });

  int id;
  int dateCreation;
  int dateModification;
  int taskId;
  int userId;
  String comment;
  String? username;
  String? name;
  String? email;
  String? avatarPath;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        dateCreation: json["date_creation"],
        dateModification: json["date_modification"],
        taskId: json["task_id"],
        userId: json["user_id"],
        comment: json["comment"],
        username: json["username"],
        name: json["name"],
        email: json["email"],
        avatarPath: json["avatar_path"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "date_creation": dateCreation,
        "date_modification": dateModification,
        "task_id": taskId,
        "user_id": userId,
        "comment": comment,
        "username": username,
        "name": name,
        "email": email,
        "avatar_path": avatarPath,
      };
}
