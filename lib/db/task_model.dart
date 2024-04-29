import 'package:drift/drift.dart';
import 'package:kanbored/db/column_model.dart';
import 'package:kanbored/db/converters.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/project_model.dart';
import 'package:kanbored/utils/app_data.dart';
import 'package:kanbored/utils/utils.dart';

class TaskModel extends Table {
  @override
  Set<Column> get primaryKey => {id, columnId, projectId};

  IntColumn get id => integer()();

  TextColumn get title => text()();

  TextColumn get description => text()();

  @JsonKey('date_creation')
  IntColumn get dateCreation => integer().nullable()();

  @JsonKey('color_id')
  TextColumn get colorId => text()();

  @JsonKey('project_id')
  IntColumn get projectId => integer().references(ProjectModel, #id)();

  @JsonKey('column_id')
  IntColumn get columnId => integer().references(ColumnModel, #id)();

  @JsonKey('owner_id')
  IntColumn get ownerId => integer()();

  IntColumn get position => integer()();

  @JsonKey('is_active')
  IntColumn get isActive => integer()();

  @JsonKey('date_completed')
  IntColumn get dateCompleted => integer().nullable()();

  IntColumn get score => integer().nullable()();

  @JsonKey('date_due')
  IntColumn get dateDue => integer().nullable()();

  @JsonKey('category_id')
  IntColumn get categoryId => integer()();

  @JsonKey('creator_id')
  IntColumn get creatorId => integer()();

  @JsonKey('date_modification')
  IntColumn get dateModification => integer().nullable()();

  TextColumn get reference => text().nullable()();

  @JsonKey('date_started')
  IntColumn get dateStarted => integer().nullable()();

  @JsonKey('time_spent')
  IntColumn get timeSpent => integer().nullable()();

  @JsonKey('time_estimated')
  IntColumn get timeEstimated => integer().nullable()();

  @JsonKey('swimlane_id')
  IntColumn get swimlaneId => integer()();

  @JsonKey('date_moved')
  IntColumn get dateMoved => integer()();

  @JsonKey('recurrence_status')
  IntColumn get recurrenceStatus => integer()();

  @JsonKey('recurrence_trigger')
  IntColumn get recurrenceTrigger => integer()();

  @JsonKey('recurrence_factor')
  IntColumn get recurrenceFactor => integer()();

  @JsonKey('recurrence_timeframe')
  IntColumn get recurrenceTimeframe => integer()();

  @JsonKey('recurrence_basedate')
  IntColumn get recurrenceBasedate => integer()();

  @JsonKey('recurrence_parent')
  IntColumn get recurrenceParent => integer().nullable()();

  @JsonKey('recurrence_child')
  IntColumn get recurrenceChild => integer().nullable()();

  IntColumn get priority => integer()();
}

class TaskMetadataModel extends Table {
  @override
  Set<Column> get primaryKey => {taskId};

  @JsonKey('task_id')
  IntColumn get taskId => integer().references(TaskModel, #id)();

  TextColumn get metadata => text().map(const TaskMetadataConverter())();
}

extension TaskModelCompanionExt on TaskModelCompanion {
  /*
[log] err: InvalidDataException: Sorry, TaskModelCompanion(id: Value(-1), title: Value(dasdsa), description: Value(), dateCreation: Value.absent(), colorId: Value.absent(), projectId: Value(24), columnId: Value(98), ownerId: Value.absent(), position: Value(0), isActive: Value.absent(), dateCompleted: Value.absent(), score: Value.absent(), dateDue: Value.absent(), categoryId: Value.absent(), creatorId: Value.absent(), dateModification: Value.absent(), reference: Value.absent(), dateStarted: Value.absent(), timeSpent: Value.absent(), timeEstimated: Value.absent(), swimlaneId: Value.absent(), dateMoved: Value.absent(), recurrenceStatus: Value.absent(), recurrenceTrigger: Value.absent(), recurrenceFactor: Value.absent(), recurrenceTimeframe: Value.absent(), recurrenceBasedate: Value.absent(), recurrenceParent: Value.absent(), recurrenceChild: Value.absent(), priority: Value.absent(), rowid: Value.absent()) cannot be used for that because:
• dateCreation: This value was required, but isn't present
• colorId: This value was required, but isn't present
• ownerId: This value was required, but isn't present
• isActive: This value was required, but isn't present
• categoryId: This value was required, but isn't present
• creatorId: This value was required, but isn't present
• swimlaneId: This value was required, but isn't present
• dateMoved: This value was required, but isn't present
• recurrenceStatus: This value was required, but isn't present
• recurrenceTrigger: This value was required, but isn't present
• recurrenceFactor: This value was required, but isn't present
• recurrenceTimeframe: This value was required, but isn't present
• recurrenceBasedate: This value was required, but isn't present
• priority: This value was required, but isn't present
   */
  static TaskModelCompanion create(
      int id, String title, int projectId, int columnId, int position,
      {String description = ""}) {
    return TaskModelCompanion(
      id: Value(id),
      title: Value(title),
      projectId: Value(projectId),
      columnId: Value(columnId),
      description: Value(description),
      position: Value(position),
      colorId: const Value("yellow"), // TODO: language dependent?
      ownerId: Value(AppData.userId),
      isActive: const Value(1),
      categoryId: const Value(0),
      creatorId: Value(AppData.userId),
      swimlaneId: const Value(0), //TODO?
      dateMoved: Value(Utils.currentTimestampInSec()),
      recurrenceStatus: const Value(0),
      recurrenceTrigger: const Value(0),
      recurrenceFactor: const Value(0),
      recurrenceTimeframe: const Value(0),
      recurrenceBasedate: const Value(0),
      priority: const Value(0),
    );
  }
}
