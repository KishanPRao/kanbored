import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:kanbored/db/database.dart';
import 'package:kanbored/db/project_model.dart';

part 'project_dao.g.dart';

@DriftAccessor(tables: [ProjectModel])
class ProjectDao extends DatabaseAccessor<AppDatabase> with _$ProjectDaoMixin {
  ProjectDao(super.db);

  Stream<List<ProjectModelData>> watchProjects() {
    final query = select(projectModel)
      ..orderBy([(t) => OrderingTerm(expression: t.name)]);
    return query.watch();
  }

  void createProject(Map<String, dynamic> json) {
    transaction(() async {
      var data = TaskModelData.fromJson(json);
      // log("project data: ${data.name}");
      // await into(projectModel).insertOnConflictUpdate(data);
      log("createProject");
    });
  }

  Future<int> createLocalProject(String name) async {
    var data = ProjectModelCompanionExt.create(name);
    log("createLocalProject");
    return await into(projectModel).insertOnConflictUpdate(data);
  }

  void updateProjects(List<dynamic> items) {
    // TODO: better to map data outside transaction?
    db.transaction(() async {
      // log("# projects ${projects.length}");
      for (var item in items) {
        // log("project: $project");
        var data = ProjectModelData.fromJson(item);
        // log("project data: ${data.name}");
        await into(projectModel).insertOnConflictUpdate(data);
      }
    });
  }

  void updateProject(ProjectModelData data) async {
    await into(projectModel).insertOnConflictUpdate(data);
  }

  void removeProject(int projectId) async {
    await (delete(projectModel)..where((tbl) => tbl.id.equals(projectId))).go();
  }
}