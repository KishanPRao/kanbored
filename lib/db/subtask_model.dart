import 'package:drift/drift.dart';
import 'package:kanbored/db/database.dart';

class SubtaskModel extends Table {
  @override
  Set<Column> get primaryKey => {id, taskId};

  IntColumn get id => integer()();

  TextColumn get title => text()();

  IntColumn get status => integer()();

  @JsonKey('time_estimated')
  IntColumn get timeEstimated => integer()();

  @JsonKey('time_spent')
  IntColumn get timeSpent => integer()();

  @JsonKey('task_id')
  IntColumn get taskId => integer()();

  @JsonKey('user_id')
  IntColumn get userId => integer()();

  IntColumn get position =>
      integer()(); // TODO: use position info! Needed while reading or default sorted
  TextColumn get username => text().nullable()();

  TextColumn get name => text().nullable()();

  @JsonKey('timer_start_date')
  IntColumn get timerStartDate => integer()();

  @JsonKey('status_name')
  TextColumn get statusName => text().nullable()();

  @JsonKey('is_timer_started')
  BoolColumn get isTimerStarted => boolean()();
}

extension SubtaskModelCompanionExt on SubtaskModelCompanion {
  static SubtaskModelCompanion create(
      int id, String title, int taskId, int userId, int position,
      {int status = 0,
      int timeSpent = 0,
      int timeEstimated = 0,
      int timerStartDate = 0,
      String statusName = "Todo",
      String? username,
      String? name,
      bool isTimerStarted = false}) {
    return SubtaskModelCompanion(
        id: Value(id),
        title: Value(title),
        status: Value(status),
        timeEstimated: Value(timeEstimated),
        timeSpent: Value(timeSpent),
        taskId: Value(taskId),
        userId: Value(userId),
        position: Value(position),
        username: Value(username),
        name: Value(name),
        timerStartDate: Value(timerStartDate),
        statusName: Value(statusName),
        isTimerStarted: Value(isTimerStarted));
  }
}
