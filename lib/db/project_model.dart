import 'package:drift/drift.dart';
import 'package:kanbored/db/converters.dart';

class ProjectModel extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();

  @JsonKey('is_active')
  IntColumn get isActive => integer()();

  TextColumn get token => text()();

  @JsonKey('last_modified')
  IntColumn get lastModified => integer()();

  @JsonKey('is_public')
  IntColumn get isPublic => integer()();

  @JsonKey('is_private')
  IntColumn get isPrivate => integer()();

  TextColumn get description => text().nullable()();

  TextColumn get identifier => text()();

  @JsonKey('start_date')
  TextColumn get startDate => text()();

  @JsonKey('end_date')
  TextColumn get endDate => text()();

  @JsonKey('owner_id')
  IntColumn get ownerId => integer()();

  @JsonKey('priority_default')
  IntColumn get priorityDefault => integer()();

  @JsonKey('priority_start')
  IntColumn get priorityStart => integer()();

  @JsonKey('priority_end')
  IntColumn get priorityEnd => integer()();

  TextColumn get email => text().nullable()();

  @JsonKey('predefined_email_subjects')
  TextColumn get predefinedEmailSubjects => text().nullable()();

  @JsonKey('per_swimlane_task_limits')
  IntColumn get perSwimlaneTaskLimits => integer()();

  @JsonKey('task_limit')
  IntColumn get taskLimit => integer()();

  @JsonKey('enable_global_tags')
  IntColumn get enableGlobalTags => integer()();

  @JsonKey('is_trello_imported')
  IntColumn get isTrelloImported => integer()();

  TextColumn get url => text().map(const UrlConverter())();
}
