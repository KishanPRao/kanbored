import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api_state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/utils/constants.dart';

class Api {
  static Timer recurringApi(void Function() function,
      {int seconds = apiTimerDurationInSec}) {
    function();
    final oneSec = Duration(seconds: seconds);
    return Timer.periodic(oneSec, (Timer t) => function());
  }

  static void updateProjects(WidgetRef ref, {recurring = false}) {
    function() {
      WebApi.getAllProjects().then((items) async {
        ref.read(ApiState.allProjects.notifier).state = items;
      });
    }

    function();
    if (recurring) recurringApi(function);
  }

  static void updateColumns(WidgetRef ref, int projectId, {recurring = false}) {
    function() {
      WebApi.getColumns(projectId).then((items) async {
        ref.read(ApiState.columnsInActiveProject.notifier).state = items;
      });
    }

    function();
    if (recurring) recurringApi(function);
  }

  static void updateTasks(WidgetRef ref, int projectId, {recurring = false}) {
    function() {
      Future.wait([
        WebApi.getAllTasks(projectId, 1), // active
        WebApi.getAllTasks(projectId, 0), //inactive
      ]).then((value) {
        var tasks = value[0];
        tasks.addAll(value[1]);
        // log("tasks: $tasks");
        ref.read(ApiState.tasksInActiveProject.notifier).state = tasks;
      });
    }

    function();
    if (recurring) recurringApi(function);
  }
}
