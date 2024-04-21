import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/db/database.dart';

class Api {
  static void recurringApi(VoidCallback function) {
    function();
    const oneSec = Duration(seconds: apiTimerDurationInSec);
    Timer.periodic(oneSec, (Timer t) => function());
  }

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

  static Future<bool> updateProject(
      WidgetRef ref, ProjectModelData data, {webUpdate = true}) async {
    ref.refresh(activeProject.notifier).state = data;
    var result = await WebApi.updateProject(data);
    if (result) updateDbProject(ref, data);
    return result;
  }

// static Stream<List<ProjectModelData>> watchProjects() {
//   return (db.select(db.projectModel)).watch();
// }
}
