import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/constants.dart';

class Api {
  // static Future<ProjectModelData> getProjects() {
  //   WebApi.getAllProjects()
  // }
  // static final db = ;

  // TODO: run in timer
  static void updateProjects(WidgetRef ref, {recurring = false}) {
    function() {
      WebApi.getAllProjects().then((projects) async {
        updateDbProjects(ref, projects);
      });
    }

    function();
    if (recurring) recurringApi(function);
  }

  static Future<bool> removeProject(WidgetRef ref, int projectId) async {
    var result = await WebApi.removeProject(projectId);
    if (result) removeDbProject(ref, projectId);
    return result;
  }

  static void recurringApi(VoidCallback function) {
    function();
    const oneSec = Duration(seconds: apiTimerDurationInSec);
    Timer.periodic(oneSec, (Timer t) => function());
  }

// static Stream<List<ProjectModelData>> watchProjects() {
//   return (db.select(db.projectModel)).watch();
// }
}
