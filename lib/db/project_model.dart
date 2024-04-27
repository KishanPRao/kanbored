import 'package:drift/drift.dart';
import 'package:kanbored/db/converters.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils/app_data.dart';
import 'package:kanbored/utils/utils.dart';

class ProjectModel extends Table {
  @override
  Set<Column> get primaryKey => {id};

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

  // TODO: confirm that it works w/ normal `kanboard`
  @JsonKey('is_trello_imported')
  IntColumn get isTrelloImported => integer().nullable()();

  TextColumn get url => text().map(const UrlConverter())();
}

extension ProjectModelCompanionExt on ProjectModelCompanion {
  static ProjectModelCompanion create(int id, String name,
      {int isActive = 1,
      String token = "",
      int? lastModified,
      int isPublic = 0,
      int isPrivate = 0,
      String identifier = "",
      String startDate = "",
      String endDate = "",
      int? ownerId,
      int priorityDefault = 0,
      int priorityStart = 0,
      int priorityEnd = 3, // TODO:?
      int perSwimlaneTaskLimits = 0,
      int taskLimit = 0,
      int enableGlobalTags = 1,
      Url? url}) {
    lastModified ??= Utils.currentTimestampInSec();
    ownerId ??= AppData.userId;
    url ??= Url.create();
    return ProjectModelCompanion(
        id: Value(id),
        name: Value(name),
        isActive: Value(isActive),
        token: Value(token),
        lastModified: Value(lastModified),
        isPublic: Value(isPublic),
        isPrivate: Value(isPrivate),
        identifier: Value(identifier),
        startDate: Value(startDate),
        endDate: Value(endDate),
        ownerId: Value(ownerId),
        priorityDefault: Value(priorityDefault),
        priorityStart: Value(priorityStart),
        priorityEnd: Value(priorityEnd),
        perSwimlaneTaskLimits: Value(perSwimlaneTaskLimits),
        taskLimit: Value(taskLimit),
        enableGlobalTags: Value(enableGlobalTags),
        url: Value(url));
  }
}
