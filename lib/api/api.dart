import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanbored/api/api_state.dart';
import 'package:kanbored/api/web_api.dart';
import 'package:kanbored/utils/constants.dart';
import 'package:kanbored/utils/utils.dart';

class Api {
  static Timer recurringApi(void Function() function,
      {int seconds = apiTimerDurationInSec}) {
    final oneSec = Duration(seconds: seconds);
    return Timer.periodic(oneSec, (Timer t) => function());
  }

  static Timer? updateProjects(WidgetRef ref, {recurring = false}) {
    function() {
      WebApi.getAllProjects().then((items) async {
        ref.readIfMounted(ApiState.allProjects.notifier)?.state = items;
      });
    }

    function();
    if (recurring) return recurringApi(function);
    return null;
  }

  static Timer? updateColumns(WidgetRef ref, int projectId, {recurring = false}) {
    function() {
      WebApi.getColumns(projectId).then((items) async {
        ref.readIfMounted(ApiState.columnsInActiveProject.notifier)?.state =
            items;
      });
    }

    function();
    if (recurring) return recurringApi(function);
    return null;
  }

  static Timer? updateTasks(WidgetRef ref, int projectId, {recurring = false}) {
    function() {
      Future.wait([
        WebApi.getAllTasks(projectId, 1), // active
        WebApi.getAllTasks(projectId, 0), //inactive
      ]).then((values) {
        var tasks = values[0];
        tasks.addAll(values[1]);
        // log("tasks: $tasks");
        log("update tasks: ${tasks.length}");
        ref.readIfMounted(ApiState.tasksInActiveProject.notifier)?.state =
            tasks;
      });
    }

    function();
    if (recurring) return recurringApi(function);
    return null;
  }
}

extension WidgetRefExt on WidgetRef {
  T? readIfMounted<T>(ProviderListenable<T> provider) {
    if (context.mounted) {
      return read(provider);
    }
    return null;
  }
}
