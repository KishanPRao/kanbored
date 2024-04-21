import 'package:drift/drift.dart';

class SubtaskModel extends Table {
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
