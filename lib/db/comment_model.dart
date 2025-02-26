import 'package:drift/drift.dart';
import 'package:kanbored/db/database.dart';

class CommentModel extends Table {
  @override
  Set<Column> get primaryKey => {id, taskId};

  IntColumn get id => integer()();

  @JsonKey('date_creation')
  IntColumn get dateCreation => integer().nullable()();

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

extension CommentModelCompanionExt on CommentModelCompanion {
  static CommentModelCompanion create(
      int id, int taskId, int userId, String comment,
      {int? dateCreation,
      int dateModification = 0,
      String? username,
      String? name,
      String? email,
      String? avatarPath}) {
    return CommentModelCompanion(
        id: Value(id),
        dateCreation: Value(dateCreation),
        dateModification: Value(dateModification),
        taskId: Value(taskId),
        userId: Value(userId),
        comment: Value(comment),
        username: Value(username),
        name: Value(name),
        email: Value(email),
        avatarPath: Value(avatarPath));
  }
}
