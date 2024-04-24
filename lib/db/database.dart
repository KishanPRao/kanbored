import 'dart:developer';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/db/column_model.dart';
import 'package:kanbored/db/comment_model.dart';
import 'package:kanbored/db/converters.dart';
import 'package:kanbored/db/project_model.dart';
import 'package:kanbored/db/subtask_model.dart';
import 'package:kanbored/db/task_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  ColumnModel,
  CommentModel,
  ProjectModel,
  SubtaskModel,
  TaskModel,
  TaskMetadataModel,
], daos: [
  ProjectDao,
  ColumnDao,
  TaskDao,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static final StateProvider<AppDatabase> provider = StateProvider((ref) {
    final database = AppDatabase();
    ref.onDispose(database.close);
    return database;
  });
}

@DriftAccessor(tables: [ProjectModel])
class ProjectDao extends DatabaseAccessor<AppDatabase> with _$ProjectDaoMixin {
  ProjectDao(super.db);

  Stream<List<ProjectModelData>> allProjects() {
    final query = select(projectModel)
      ..orderBy([(t) => OrderingTerm(expression: t.name)]);
    return query.watch();
  }
}

@DriftAccessor(tables: [ColumnModel])
class ColumnDao extends DatabaseAccessor<AppDatabase> with _$ColumnDaoMixin {
  ColumnDao(super.db);

  Stream<List<ColumnModelData>> watchColumnsInProject(int projectId) {
    final query = select(columnModel)
      ..where((tbl) {
        return tbl.projectId.equals(projectId);
      })
      ..orderBy([(t) => OrderingTerm(expression: t.position)]);
    return query.watch();
  }
}

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

  Future<TaskModelData> getTask(int taskId) {
    final query = select(taskModel)
      ..where((tbl) {
        return tbl.id.equals(taskId);
      });
    return query.getSingle();
  }

  void addTask(Map<String, dynamic> json) {
    transaction(() async {
      var data = TaskModelData.fromJson(json);
      // log("project data: ${data.name}");
      await into(taskModel).insertOnConflictUpdate(data);
      log("fin add");
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

  void removeTask(int taskId) {
    transaction(() async {
      await (delete(taskModel)..where((tbl) => tbl.id.equals(taskId))).go();
    });
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}


extension DataClassExtension on DataClass {
  dynamic toJsonWithKeys(List<String> keys) {
    dynamic jsonData = toJson();
    if (jsonData is Map<String, dynamic>) {
      jsonData.removeWhere((key, value) => !keys.contains(key));
      return jsonData;
    } else {
      log("Other");
    }
    return jsonData;
  }
}