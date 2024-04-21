import 'package:drift/drift.dart';
import 'package:kanbored/db/column_model.dart';
import 'package:kanbored/db/converters.dart';
import 'package:kanbored/db/project_model.dart';

class TaskModel extends Table {
  @override
  Set<Column> get primaryKey => {id, columnId, projectId};

  IntColumn get id => integer()();

  TextColumn get title => text()();

  TextColumn get description => text()();

  @JsonKey('date_creation')
  IntColumn get dateCreation => integer()();

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

  TextColumn get metadata =>
      text().map(const TaskMetadataConverter())();
}
