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
  //
  // void createProject(Map<String, dynamic> json) {
  //   transaction(() async {
  //     var data = TaskModelData.fromJson(json);
  //     // log("project data: ${data.name}");
  //     // await into(projectModel).insertOnConflictUpdate(data);
  //     log("createProject");
  //   });
  // }
  //
  // Future<int> createLocalProject(String name) async {
  //   return transaction(() async {
  //     var lowestIdProj = await (select(projectModel)
  //           ..orderBy(
  //               [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)])
  //           ..limit(1))
  //         .getSingleOrNull();
  //     log("lowestIdProj: ${lowestIdProj?.id}, ${lowestIdProj?.name}");
  //     final lowestId = lowestIdProj?.id ?? 0;
  //     var data = ProjectModelCompanionExt.create(lowestId - 1, name);
  //     log("createLocalProject");
  //     return await into(projectModel).insertOnConflictUpdate(data);
  //   });
  // }

  Future<int> createLocalProject(int localId, String name) async {
    return transaction(() async {
      // var lowestIdProj = await (select(projectModel)
      //       ..orderBy(
      //           [(t) => OrderingTerm(expression: t.id, mode: OrderingMode.asc)])
      //       ..limit(1))
      //     .getSingleOrNull();
      // log("lowestIdProj: ${lowestIdProj?.id}, ${lowestIdProj?.name}");
      // final lowestId = lowestIdProj?.id ?? 0;
      // var data = ProjectModelCompanionExt.create(lowestId - 1, name);
      var data = ProjectModelCompanionExt.create(localId, name);
      log("createLocalProject");
      return await into(projectModel).insertOnConflictUpdate(data);
    });
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

  Future<ProjectModelData?> getProject(int id) async {
    return await (select(projectModel)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  void updateId(int oldId, int newId) async {
    (update(projectModel)..where((tbl) => tbl.id.equals(oldId)))
        .write(ProjectModelCompanion(id: Value(newId)));
  }

  void updateProject(ProjectModelData data) async {
    await into(projectModel).insertOnConflictUpdate(data);
  }

  void removeProject(int projectId) async {
    await (delete(projectModel)..where((tbl) => tbl.id.equals(projectId))).go();
  }
}
