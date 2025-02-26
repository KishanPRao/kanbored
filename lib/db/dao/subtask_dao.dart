import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:kanbored/db/subtask_model.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/utils/app_data.dart';

part 'subtask_dao.g.dart';

@DriftAccessor(tables: [SubtaskModel])
class SubtaskDao extends DatabaseAccessor<AppDatabase> with _$SubtaskDaoMixin {
  SubtaskDao(super.db);

  Future<int> addSubtask(int localId, String title, int taskId) async {
    return transaction(() async {
      // var lowestIdItem = await (select(subtaskModel)
      //       ..orderBy(
      //           [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)])
      //       ..limit(1))
      //     .getSingleOrNull();
      var highestPositionItem = await (select(subtaskModel)
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.position, mode: OrderingMode.desc)
            ])
            ..limit(1))
          .getSingleOrNull();
      // log("lowestIdItem: ${lowestIdItem?.id}, ${lowestIdItem?.title}");
      // final lowestId = lowestIdItem?.id ?? 0;
      final highestPosition = highestPositionItem?.position ?? 0;
      var data = SubtaskModelCompanionExt.create(
          localId, title, taskId, AppData.userId, highestPosition);
      log("dao, addSubtask");
      return await into(subtaskModel).insertOnConflictUpdate(data);
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

  void updateSubtasks(List<dynamic> items) {
    // log("[dao] updateSubtasks");
    db.transaction(() async {
      // log("# projects ${projects.length}");
      for (var item in items) {
        // log("project: $project");
        var data = SubtaskModelData.fromJson(item);
        // log("project data: ${data.name}");
        await into(subtaskModel).insertOnConflictUpdate(data);
      }
    });
  }

  void updateId(int oldId, int newId) async {
    (update(subtaskModel)..where((tbl) => tbl.id.equals(oldId)))
        .write(SubtaskModelCompanion(id: Value(newId)));
  }

  void updateTaskId(int oldId, int newId) async {
    (update(subtaskModel)..where((tbl) => tbl.taskId.equals(oldId)))
        .write(SubtaskModelCompanion(taskId: Value(newId)));
  }
}
