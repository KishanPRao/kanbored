import 'dart:async';
import 'dart:developer';

import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/db/database.dart';

class Api {
  // static Future<ProjectModelData> getProjects() {
  //   WebApi.getAllProjects()
  // }
  // static final db = AppDatabase();
  //
  // // TODO: run in timer
  // static void updateProjects() {
  //   const oneSec = Duration(seconds: 1);
  //   Timer.periodic(oneSec, (Timer t) {
  //     log("update projects");
  //     WebApi.getAllProjects().then((projects) async {
  //       db.transaction(() async {
  //         for (var project in projects) {
  //           log("project: $project");
  //           var data = ProjectModelData.fromJson(project);
  //           log("project data: $data");
  //           await db.into(db.projectModel).insert(data);
  //         }
  //       });
  //     });
  //   });
  // }

  static Stream<List<ProjectModelData>> watchProjects() {
    return (db.select(db.projectModel)).watch();
  }
}
