import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:kanbored/db/comment_model.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils/app_data.dart';

part 'comment_dao.g.dart';

@DriftAccessor(tables: [CommentModel])
class CommentDao extends DatabaseAccessor<AppDatabase> with _$CommentDaoMixin {
  CommentDao(super.db);

  Future<int> addComment(int localId, String comment, int taskId) async {
    return transaction(() async {
      var data = CommentModelCompanionExt.create(
          localId, taskId, AppData.userId, comment);
      log("dao, addComment");
      return await into(commentModel).insertOnConflictUpdate(data);
    });
  }

  void updateComment(CommentModelData data) async {
    await into(commentModel).insertOnConflictUpdate(data);
  }

  Stream<List<CommentModelData>> watchCommentsInTask(int taskId) {
    final query = select(commentModel)
      ..where((tbl) {
        return tbl.taskId.equals(taskId);
      })
      ..orderBy([(t) => OrderingTerm(expression: t.dateCreation)]);
    return query.watch();
  }

  void updateComments(List<dynamic> items) {
    // log("[dao] updateComments");
    db.transaction(() async {
      // log("# projects ${projects.length}");
      for (var item in items) {
        // log("project: $project");
        var data = CommentModelData.fromJson(item);
        // log("project data: ${data.name}");
        await into(commentModel).insertOnConflictUpdate(data);
      }
    });
  }

  void updateId(int oldId, int newId) async {
    (update(commentModel)..where((tbl) => tbl.id.equals(oldId)))
        .write(CommentModelCompanion(id: Value(newId)));
  }

  void updateTaskId(int oldId, int newId) async {
    (update(commentModel)..where((tbl) => tbl.taskId.equals(oldId)))
        .write(CommentModelCompanion(taskId: Value(newId)));
  }
}
