// import 'package:drift/drift.dart';
// import 'package:kanbored/db/converters.dart';
// import 'package:kanbored/db/database.dart';
//
// class TaskMetadataModel extends Table {
//   @override
//   Set<Column> get primaryKey => {id, taskId};
//
//   IntColumn get id => integer()();
//
//   TextColumn get title => text()();
//
//   IntColumn get status => integer()();
//
//   @JsonKey('time_estimated')
//   IntColumn get timeEstimated => integer()();
//
//   @JsonKey('time_spent')
//   IntColumn get timeSpent => integer()();
//
//   @JsonKey('task_id')
//   IntColumn get taskId => integer()();
//
//   @JsonKey('user_id')
//   IntColumn get userId => integer()();
//
//   IntColumn get position =>
//       integer()(); // TODO: use position info! Needed while reading or default sorted
//   TextColumn get username => text().nullable()();
//
//   TextColumn get name => text().nullable()();
//
//   @JsonKey('timer_start_date')
//   IntColumn get timerStartDate => integer()();
//
//   @JsonKey('status_name')
//   TextColumn get statusName => text().nullable()();
//
//   @JsonKey('is_timer_started')
//   BoolColumn get isTimerStarted => boolean()();
// }
//
// extension TaskMetadataModelCompanionExt on TaskMetadataModelCompanion {
//   static TaskMetadataModelCompanion create(
//       int taskId, TaskMetadata taskMetadata) {
//     return TaskMetadataModelCompanion(
//         taskId: Value(taskId),
//         title: Value(title),
//         status: Value(status),
//         timeEstimated: Value(timeEstimated),
//         timeSpent: Value(timeSpent),
//         taskId: Value(taskId),
//         userId: Value(userId),
//         position: Value(position),
//         username: Value(username),
//         name: Value(name),
//         timerStartDate: Value(timerStartDate),
//         statusName: Value(statusName),
//         isTimerStarted: Value(isTimerStarted));
//   }
// }
