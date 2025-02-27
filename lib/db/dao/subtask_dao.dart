import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:kanbored/db/subtask_model.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils/app_data.dart';

part 'subtask_dao.g.dart';

@DriftAccessor(tables: [SubtaskModel])
class SubtaskDao extends DatabaseAccessor<AppDatabase> with _$SubtaskDaoMixin {
  SubtaskDao(super.db);

  void createSubtask(int id, String title, int taskId) async {
    return transaction(() async {
      var highestPositionItem = await (select(subtaskModel)
        ..where((tbl) => tbl.taskId.equals(taskId))
        ..orderBy([
              (t) =>
              OrderingTerm(expression: t.position, mode: OrderingMode.desc)
        ])
        ..limit(1))
          .getSingleOrNull();
      // log("lowestIdItem: ${lowestIdItem?.id}, ${lowestIdItem?.title}");
      final highestPosition = highestPositionItem?.position ?? 0;
      var data = SubtaskModelCompanionExt.create(
        id,
        title,
        taskId,
        highestPosition,
      );
      log("dao, createSubtask");
      await into(subtaskModel).insertOnConflictUpdate(data);
    });
  }

  void updateSubtask(SubtaskModelData data) async {
    await into(subtaskModel).insertOnConflictUpdate(data);
  }

  Stream<List<SubtaskModelData>> watchSubtasksInTask(int taskId) {
    final query = select(subtaskModel)
      ..where((tbl) {
        return tbl.taskId.equals(taskId);
      })
      ..orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.watch();
  }

  Future<SubtaskModelData?> getSubtask(int subtaskId) {
    final query = select(subtaskModel)
      ..where((tbl) {
        return tbl.id.equals(subtaskId);
      })..limit(1);
    return query.getSingleOrNull();
  }

  void updateSubtasks(List<dynamic> items) {
    // log("[dao] updateSubtasks");
    db.transaction(() async {
      // log("# projects ${projects.length}");
      for (var item in items) {
        // log("project: $project");
        var data = SubtaskModelData.fromJson(item);
        // log("subtask data: ${data.title}, ${data.status}");
        await into(subtaskModel).insertOnConflictUpdate(data);
      }
    });
  }

  Future<void> updateId(int oldId, int newId) async {
    (update(subtaskModel)..where((tbl) => tbl.id.equals(oldId)))
        .write(SubtaskModelCompanion(id: Value(newId)));
  }

  void updateTaskId(int oldId, int newId) async {
    (update(subtaskModel)..where((tbl) => tbl.taskId.equals(oldId)))
        .write(SubtaskModelCompanion(taskId: Value(newId)));
  }
}
