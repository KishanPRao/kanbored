import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/database_query.dart';

final activeProject = StateProvider<ProjectModelData?>((ref) => null);
final activeColumn = StateProvider<ColumnModelData?>((ref) => null);
final activeTask = StateProvider<TaskModelData?>((ref) => null);
final activeTaskMetadata = StateProvider<TaskMetadataModelData?>((ref) => null);

final columnsInProject = StreamProvider.autoDispose((ref) {
  final database = ref.watch(AppDatabase.provider);
  final current = ref
      .watch(activeProject)
      ?.id;
  return database.columnsInProject(current);
});

final tasksInProject = StreamProvider.autoDispose((ref) {
  final database = ref.watch(AppDatabase.provider);
  final current = ref
      .watch(activeProject)
      ?.id;
  return database.tasksInProject(current);
});

// StreamProvider<List<TaskModelData>> tasksInColumn(int columnId) =>
//     StreamProvider.autoDispose((ref) {
//       final database = ref.watch(AppDatabase.provider);
//       return database.tasksInColumn(columnId);
//     });

final allProjects = StreamProvider.autoDispose((ref) {
  final database = ref.watch(AppDatabase.provider);
  return database.projects();
});

final taskMetadata = StreamProvider.autoDispose((ref) {
  final database = ref.watch(AppDatabase.provider);
  final current = ref
      .watch(activeTask)
      ?.id;
  return database.taskMetadata(current);
});

void updateDbProjects(WidgetRef ref, List<dynamic> projects) {
  final db = ref.watch(AppDatabase.provider);
  db.transaction(() async {
    // log("# projects ${projects.length}");
    for (var project in projects) {
      // log("project: $project");
      var data = ProjectModelData.fromJson(project);
      // log("project data: ${data.name}");
      await db.into(db.projectModel).insertOnConflictUpdate(data);
    }
  });
}

void updateDbColumns(WidgetRef ref, List<dynamic> columns) {
  final db = ref.watch(AppDatabase.provider);
  db.transaction(() async {
    // log("# projects ${projects.length}");
    for (var column in columns) {
      // log("project: $project");
      var data = ColumnModelData.fromJson(column);
      // log("project data: ${data.name}");
      await db.into(db.columnModel).insertOnConflictUpdate(data);
    }
  });
}

void updateDbTasks(WidgetRef ref, List<dynamic> tasks) {
  final db = ref.watch(AppDatabase.provider);
  db.transaction(() async {
    // log("# projects ${projects.length}");
    for (var task in tasks) {
      // log("project: $project");
      var data = TaskModelData.fromJson(task);
      // log("project data: ${data.name}");
      await db.into(db.taskModel).insertOnConflictUpdate(data);
    }
  });
}

TaskMetadataModelData updateDbTaskMetadata(WidgetRef ref, dynamic metadata) {
  var data = TaskMetadataModelData.fromJson(metadata);
  final db = ref.watch(AppDatabase.provider);
  db.transaction(() async {
    await db.into(db.taskMetadataModel).insertOnConflictUpdate(data);
  });
  return data;
}

void removeDbProject(WidgetRef ref, int projectId) {
  final db = ref.watch(AppDatabase.provider);
  db.transaction(() async {
    await (db.delete(db.projectModel)
      ..where((tbl) => tbl.id.equals(projectId)))
        .go();
  });
}

void updateDbProject(WidgetRef ref, ProjectModelData data) {
  final db = ref.watch(AppDatabase.provider);
  db.transaction(() async {
    await db.into(db.projectModel).insertOnConflictUpdate(data);
  });
}

void updateDbColumn(WidgetRef ref, ColumnModelData data) {
  final db = ref.watch(AppDatabase.provider);
  db.transaction(() async {
    await db.into(db.columnModel).insertOnConflictUpdate(data);
  });
}

// final isLoadingProvider = StateProvider((ref) => false);
