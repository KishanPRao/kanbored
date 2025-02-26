import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:json_annotation/json_annotation.dart' as j;

part 'converters.g.dart';

// MARK: TaskMetadata
class TaskMetadataConverter extends TypeConverter<TaskMetadata, String>
    with JsonTypeConverter2<TaskMetadata, String, String> {
  const TaskMetadataConverter();

  @override
  String toJson(TaskMetadata value) => (jsonEncode(value.toJson()));

  @override
  TaskMetadata fromJson(String json) => TaskMetadata.fromJson(jsonDecode(json));

  // TODO: test
  @override
  TaskMetadata fromSql(String fromDb) =>
      TaskMetadata.fromJson(jsonDecode(fromDb) as Map<String, dynamic>);

  @override
  String toSql(TaskMetadata value) => jsonEncode(value);
}

@j.JsonSerializable()
class TaskMetadata {
  List<ChecklistMetadata> checklists;

  TaskMetadata(this.checklists);

  factory TaskMetadata.fromJson(Map<String, dynamic> json) =>
      _$TaskMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$TaskMetadataToJson(this);
}

@j.JsonSerializable()
class ChecklistMetadata {
  String name;  // TODO: use title instead?
  int position; /* position of checklist */
  List<CheckListItemMetadata> items;

  ChecklistMetadata(this.name, this.position, this.items);

  factory ChecklistMetadata.fromJson(Map<String, dynamic> json) =>
      _$ChecklistMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$ChecklistMetadataToJson(this);
}

@j.JsonSerializable()
class CheckListItemMetadata {
  int id; /* subtask id */

  CheckListItemMetadata(this.id);

  factory CheckListItemMetadata.fromJson(Map<String, dynamic> json) =>
      _$CheckListItemMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$CheckListItemMetadataToJson(this);
}

// MARK: Url
class UrlConverter extends TypeConverter<Url, String>
    with JsonTypeConverter2<Url, String, Map<String, dynamic>> {
  const UrlConverter();

  @override
  Map<String, dynamic> toJson(Url value) => value.toJson();

  @override
  Url fromJson(Map<String, dynamic> json) => Url.fromJson(json);

  @override
  Url fromSql(String fromDb) =>
      Url.fromJson(jsonDecode(fromDb) as Map<String, dynamic>);

  @override
  String toSql(Url value) => jsonEncode(value);
}

@j.JsonSerializable()
class Url {
  String board;
  String list;
  String? calendar;

  Url(this.board, this.list, {this.calendar});

  factory Url.fromJson(Map<String, dynamic> json) => _$UrlFromJson(json);

  Map<String, dynamic> toJson() => _$UrlToJson(this);

  static Url create({String board = "", String list = "", String? calendar}) {
    return Url(board, list, calendar: calendar);
  }
}

// MARK: WebApi
// class WebApiModelConverter extends TypeConverter<WebApiModel, String>
//     with JsonTypeConverter2<WebApiModel, String, Map<String, dynamic>> {
//   const WebApiModelConverter();
//
//   @override
//   Map<String, dynamic> toJson(WebApiModel value) => value.toJson();
//
//   @override
//   WebApiModel fromJson(Map<String, dynamic> json) => WebApiModel.fromJson(json);
//
//   @override
//   WebApiModel fromSql(String fromDb) =>
//       WebApiModel.fromJson(jsonDecode(fromDb) as Map<String, dynamic>);
//
//   @override
//   String toSql(WebApiModel value) => jsonEncode(value);
// }
//
// @j.JsonSerializable()
// class WebApiModel {
//   const WebApiModel(this.apiId, this.apiName, this.apiType);
//
//   final int apiId;
//   final String apiName;
//   final int apiType;
//
//   factory WebApiModel.fromJson(Map<String, dynamic> json) =>
//       _$WebApiModelFromJson(json);
//
//   Map<String, dynamic> toJson() => _$WebApiModelToJson(this);
// }
