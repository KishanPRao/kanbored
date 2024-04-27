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
      json['name'] as String,
      json['position'] as int,
      (json['items'] as List<dynamic>)
          .map((e) => CheckListItemMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChecklistMetadataToJson(ChecklistMetadata instance) =>
    <String, dynamic>{
      'name': instance.name,
      'position': instance.position,
      'items': instance.items,
    };

CheckListItemMetadata _$CheckListItemMetadataFromJson(
        Map<String, dynamic> json) =>
    CheckListItemMetadata(
      json['id'] as int,
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

WebApiModel _$WebApiModelFromJson(Map<String, dynamic> json) => WebApiModel(
      json['apiId'] as int,
      json['apiName'] as String,
      json['apiType'] as int,
    );

Map<String, dynamic> _$WebApiModelToJson(WebApiModel instance) =>
    <String, dynamic>{
      'apiId': instance.apiId,
      'apiName': instance.apiName,
      'apiType': instance.apiType,
    };
