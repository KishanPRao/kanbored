import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/database_query.dart';

final activeProject = StateProvider<ProjectModelData?>((ref) => null);
final columnsInProject = StreamProvider((ref) {
  final database = ref.watch(AppDatabase.provider);
  final current = ref.watch(activeProject)?.id;
  return database.columnsInProject(current);
});
final currentProjects = StreamProvider((ref) {
  final database = ref.watch(AppDatabase.provider);
  return database.projects();
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

void removeDbProject(WidgetRef ref, int projectId) {
  final db = ref.watch(AppDatabase.provider);
  db.transaction(() async {
    await (db.delete(db.projectModel)..where((tbl) => tbl.id.equals(projectId))).go();
  });
}

// final isLoadingProvider = StateProvider((ref) => false);
