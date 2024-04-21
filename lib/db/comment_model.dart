import 'package:drift/drift.dart';

class CommentModel extends Table {
  IntColumn get id => integer()();

  @JsonKey('date_creation')
  IntColumn get dateCreation => integer()();

  @JsonKey('date_modification')
  IntColumn get dateModification => integer()();

  @JsonKey('task_id')
  IntColumn get taskId => integer()();

  @JsonKey('user_id')
  IntColumn get userId => integer()();

  TextColumn get comment => text()();

  TextColumn get username => text().nullable()();

  TextColumn get name => text().nullable()();

  TextColumn get email => text().nullable()();

  @JsonKey('avatar_path')
  TextColumn get avatarPath => text().nullable()();
}
