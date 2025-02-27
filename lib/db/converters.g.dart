// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'converters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskMetadata _$TaskMetadataFromJson(Map<String, dynamic> json) => TaskMetadata(
      (json['checklists'] as List<dynamic>)
          .map((e) => ChecklistMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskMetadataToJson(TaskMetadata instance) =>
    <String, dynamic>{
      'checklists': instance.checklists,
    };

ChecklistMetadata _$ChecklistMetadataFromJson(Map<String, dynamic> json) =>
    ChecklistMetadata(
      (json['id'] as num).toInt(),
      json['title'] as String,
      (json['position'] as num).toInt(),
      (json['items'] as List<dynamic>)
          .map((e) => CheckListItemMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChecklistMetadataToJson(ChecklistMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'position': instance.position,
      'items': instance.items,
    };

CheckListItemMetadata _$CheckListItemMetadataFromJson(
        Map<String, dynamic> json) =>
    CheckListItemMetadata(
      (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$CheckListItemMetadataToJson(
        CheckListItemMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

Url _$UrlFromJson(Map<String, dynamic> json) => Url(
      json['board'] as String,
      json['list'] as String,
      calendar: json['calendar'] as String?,
    );

Map<String, dynamic> _$UrlToJson(Url instance) => <String, dynamic>{
      'board': instance.board,
      'list': instance.list,
      'calendar': instance.calendar,
    };
