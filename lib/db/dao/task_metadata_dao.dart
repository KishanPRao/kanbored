import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:kanbored/db/converters.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/task_model.dart';

part 'task_metadata_dao.g.dart';

@DriftAccessor(tables: [TaskMetadataModel])
class TaskMetadataDao extends DatabaseAccessor<AppDatabase>
    with _$TaskMetadataDaoMixin {
  TaskMetadataDao(super.db);

  Future<int> addTaskMetadata(int taskId, TaskMetadata taskMetadata) async {
    return transaction(() async {
      var data = TaskMetadataModelCompanionExt.create(taskId, taskMetadata);
      log("dao, addTaskMetadata");
      return await into(taskMetadataModel).insertOnConflictUpdate(data);
    });
  }

  void writeTaskMetadata(TaskMetadataModelData data) async {
    await into(taskMetadataModel).insertOnConflictUpdate(data);
  }

  void updateSubtaskId(int taskId, TaskMetadataModelData taskMetadata, int oldId, int newId) async {
    (update(taskMetadataModel)
      ..where((tbl) => tbl.taskId.equals(taskId)))
        .write(TaskMetadataModelCompanion(metadata: Value(taskMetadata.metadata)));
  }

  void updateTaskMetadata(int taskId, Map<String, dynamic> item) {
    // log("[dao] updateTaskMetadata");
    // TODO: null data?
    item["task_id"] = taskId;
    if (!item.containsKey("metadata")) {
      log("[dao] no task metadata!");
      item["metadata"] = "{\"checklists\": []}";
    }
    db.transaction(() async {
      // log("# projects ${projects.length}");
      // for (var item in items) {
      // log("task metadata: $item");
      //{metadata: {"checklists":[{"name":"Checklist1","position":1,"items":[{"id":16},{"id":17},{"id":18}]},{"name":"Checklist","position":2,"items":[{"id":19},{"id":20}]}]}}
      //{task_id: 77}
      var data = TaskMetadataModelData.fromJson(item);
      // // log("project data: ${data.name}");
      await into(taskMetadataModel).insertOnConflictUpdate(data);
      // }
    });
  }

  Stream<List<TaskMetadataModelData>> watchTaskMetadataInTask(int taskId) {
    final query = select(taskMetadataModel)
      ..where((tbl) {
        return tbl.taskId.equals(taskId);
      });
    return query.watch();
  }

  // void updateTaskMetadata(List<dynamic> items) {
  //   log("[dao] updateTaskMetadatas");
  //   db.transaction(() async {
  //     // log("# projects ${projects.length}");
  //     for (var item in items) {
  //       // log("project: $project");
  //       var data = TaskMetadataModelData.fromJson(item);
  //       // log("project data: ${data.name}");
  //       await into(taskMetadataModel).insertOnConflictUpdate(data);
  //     }
  //   });
  // }

  Stream<TaskMetadataModelData?> watchTaskMetadataForTask(int taskId) {
    final query = select(taskMetadataModel)
      ..where((tbl) {
        return tbl.taskId.equals(taskId);
      })
      ..limit(1);
    return query.watchSingleOrNull();
  }

  Future<TaskMetadataModelData?> getTaskMetadataForTask(int taskId) {
    final query = select(taskMetadataModel)
      ..where((tbl) {
        return tbl.taskId.equals(taskId);
      })
      ..limit(1);
    return query.getSingleOrNull();
  }

  // Future<int> getNextChecklistId(TaskMetadataModelData taskMetadata) async {
  //   var maxChecklist = taskMetadata.metadata.checklists.reduce((a, b) => a.id > b.id ? a : b);
  //   // log("lowestIdItem: ${lowestIdItem?.id}, ${lowestIdItem?.title}");
  //   // final lowestId = lowestIdItem?.id ?? 0;
  //   log("max checklist: $maxChecklist");
  //   var nextId = maxChecklist.id + 1;
  //   return nextId;
  // }

  // TODO
  void addChecklist(String title) {}

  void updateTaskId(int oldId, int newId) async {
    (update(taskMetadataModel)..where((tbl) => tbl.taskId.equals(oldId)))
        .write(TaskMetadataModelCompanion(taskId: Value(newId)));
  }
}

extension TaskMetadataModelCompanionExt on TaskMetadataModelCompanion {
  static TaskMetadataModelCompanion create(
      int taskId, TaskMetadata taskMetadata) {
    return TaskMetadataModelCompanion(
        taskId: Value(taskId), metadata: Value(taskMetadata));
  }
}
