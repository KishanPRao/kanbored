import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/task_model.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [TaskModel])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  // Stream<List<TaskModelData>> watchTasksInProject(int projectId) {
  //   final query = select(taskModel)
  //     ..where((tbl) {
  //       return tbl.projectId.equals(projectId);
  //     })
  //     ..orderBy([(t) => OrderingTerm(expression: t.position)]);
  //   return query.watch();
  // }

  Stream<List<TaskModelData>> watchTasksInColumn(int columnId) {
    final query = select(taskModel)
      ..where((tbl) {
        return tbl.columnId.equals(columnId);
      })
      ..orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.watch();
  }

  Future<List<TaskModelData>> getAllTasks() {
    final query = select(taskModel);
    return query.get();
  }

  Future<TaskModelData> getTask(int taskId) {
    final query = select(taskModel)
      ..where((tbl) {
        return tbl.id.equals(taskId);
      });
    return query.getSingle();
  }

  /// Creates a task, get highest task position to place at the end of the column
  Future<int> createTask(int id, int projectId, int columnId, String title) {
    return transaction(() async {
      var highestPositionItem = await (select(taskModel)
            ..where((tbl) => tbl.columnId.equals(columnId))
            ..where((tbl) => tbl.projectId.equals(projectId))
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.position, mode: OrderingMode.desc)
            ])
            ..limit(1))
          .getSingleOrNull();
      // log("lowestIdItem: ${lowestIdItem?.id}, ${lowestIdItem?.title}");
      final highestPosition = highestPositionItem?.position ?? 0;
      var data = TaskModelCompanionExt.create(
        id,
        title,
        projectId,
        columnId,
        highestPosition,
      );
      log("dao, createTask");
      return await into(taskModel).insertOnConflictUpdate(data);
    });
  }

  void _updateTask(int taskId, TaskModelCompanion taskModelCompanion) {
    transaction(() async {
      await (update(taskModel)..where((tbl) => tbl.id.equals(taskId)))
          .write(taskModelCompanion);
      log("fin _updateTask");
    });
  }

  void updateTask(TaskModelData data) {
    transaction(() async {
      await into(taskModel).insertOnConflictUpdate(data);
      log("fin updateTask");
    });
  }

  void openTask(int taskId) =>
      _updateTask(taskId, const TaskModelCompanion(isActive: Value(1)));

  void closeTask(int taskId) =>
      _updateTask(taskId, const TaskModelCompanion(isActive: Value(0)));

  void removeTask(int taskId) async {
    await (delete(taskModel)..where((tbl) => tbl.id.equals(taskId))).go();
  }

  void updateTasks(List<dynamic> items) {
    db.transaction(() async {
      // log("# projects ${projects.length}");
      for (var item in items) {
        // log("project: $project");
        var data = TaskModelData.fromJson(item);
        // log("project data: ${data.name}");
        await into(taskModel).insertOnConflictUpdate(data);
      }
    });
  }

  void updateId(int oldId, int newId) async {
    (update(taskModel)..where((tbl) => tbl.id.equals(oldId)))
        .write(TaskModelCompanion(id: Value(newId)));
  }
}
